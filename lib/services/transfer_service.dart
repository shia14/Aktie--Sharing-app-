import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../models/device.dart';

enum TransferStatus {
  idle,
  sending,
  receiving,
  completed,
  failed,
  cancelled,
}

class FileTransfer {
  final String id;
  final String fileName;
  final int fileSize;
  final Device device;
  TransferStatus status;
  double progress;
  
  FileTransfer({
    required this.id,
    required this.fileName,
    required this.fileSize,
    required this.device,
    this.status = TransferStatus.idle,
    this.progress = 0.0,
  });
}

class TransferService extends ChangeNotifier {
  ServerSocket? _serverSocket;
  final int _port = 8888;
  
  final List<FileTransfer> _transfers = [];
  List<FileTransfer> get transfers => List.unmodifiable(_transfers);
  
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Start listening for incoming connections
      _serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, _port);
      _serverSocket!.listen(_handleIncomingConnection);
      
      _isInitialized = true;
      debugPrint('Transfer service initialized on port $_port');
    } catch (e) {
      debugPrint('Error initializing transfer service: $e');
    }
  }

  void _handleIncomingConnection(Socket socket) {
    debugPrint('Incoming connection from ${socket.remoteAddress.address}');
    
    final List<int> buffer = [];
    Map<String, dynamic>? metadata;
    int bytesReceived = 0;
    bool receivingMetadata = true;
    
    socket.listen(
      (data) {
        if (receivingMetadata) {
          buffer.addAll(data);
          
          // Look for metadata delimiter (newline)
          final delimiterIndex = buffer.indexOf(10); // \n
          if (delimiterIndex != -1) {
            final metadataBytes = buffer.sublist(0, delimiterIndex);
            final metadataString = String.fromCharCodes(metadataBytes);
            
            try {
              metadata = _parseMetadata(metadataString);
              receivingMetadata = false;
              buffer.removeRange(0, delimiterIndex + 1);
              
              // Create transfer record
              final transfer = FileTransfer(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                fileName: metadata!['fileName'] as String,
                fileSize: metadata!['fileSize'] as int,
                device: Device(
                  id: socket.remoteAddress.address,
                  name: metadata!['senderName'] as String,
                  ipAddress: socket.remoteAddress.address,
                  port: socket.remotePort,
                ),
                status: TransferStatus.receiving,
              );
              
              _transfers.add(transfer);
              notifyListeners();
              
              _receiveFile(socket, transfer, buffer);
            } catch (e) {
              debugPrint('Error parsing metadata: $e');
              socket.close();
            }
          }
        }
      },
      onError: (error) {
        debugPrint('Socket error: $error');
        socket.close();
      },
      onDone: () {
        debugPrint('Connection closed');
        socket.close();
      },
    );
  }

  Map<String, dynamic> _parseMetadata(String metadataString) {
    final parts = metadataString.split('|');
    return {
      'fileName': parts[0],
      'fileSize': int.parse(parts[1]),
      'senderName': parts[2],
    };
  }

  Future<void> _receiveFile(Socket socket, FileTransfer transfer, List<int> initialBuffer) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final downloadsDir = Directory(path.join(directory.path, 'Aktie Downloads'));
      
      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
      }
      
      final filePath = path.join(downloadsDir.path, transfer.fileName);
      final file = File(filePath);
      final sink = file.openWrite();
      
      int bytesReceived = initialBuffer.length;
      sink.add(initialBuffer);
      
      await for (var data in socket) {
        sink.add(data);
        bytesReceived += data.length;
        
        transfer.progress = bytesReceived / transfer.fileSize;
        notifyListeners();
        
        if (bytesReceived >= transfer.fileSize) {
          break;
        }
      }
      
      await sink.close();
      
      transfer.status = TransferStatus.completed;
      transfer.progress = 1.0;
      notifyListeners();
      
      debugPrint('File received: $filePath');
      
      // Send acknowledgment
      socket.write('OK\n');
      await socket.flush();
      socket.close();
      
    } catch (e) {
      debugPrint('Error receiving file: $e');
      transfer.status = TransferStatus.failed;
      notifyListeners();
      socket.close();
    }
  }

  Future<void> sendFile(String filePath, Device device) async {
    Socket? socket;
    
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('File does not exist');
      }
      
      final fileName = path.basename(filePath);
      final fileSize = await file.length();
      
      final transfer = FileTransfer(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        fileName: fileName,
        fileSize: fileSize,
        device: device,
        status: TransferStatus.sending,
      );
      
      _transfers.add(transfer);
      notifyListeners();
      
      // Connect to the device
      socket = await Socket.connect(device.ipAddress, device.port, timeout: const Duration(seconds: 10));
      
      // Send metadata
      final metadata = '$fileName|$fileSize|${await _getDeviceName()}\n';
      socket.write(metadata);
      await socket.flush();
      
      // Send file data in chunks
      final stream = file.openRead();
      int bytesSent = 0;
      
      await for (var chunk in stream) {
        socket.add(chunk);
        bytesSent += chunk.length;
        
        transfer.progress = bytesSent / fileSize;
        notifyListeners();
      }
      
      await socket.flush();
      
      // Wait for acknowledgment
      final response = await socket.timeout(const Duration(seconds: 5)).first;
      final ack = String.fromCharCodes(response).trim();
      
      if (ack == 'OK') {
        transfer.status = TransferStatus.completed;
        transfer.progress = 1.0;
      } else {
        transfer.status = TransferStatus.failed;
      }
      
      notifyListeners();
      debugPrint('File sent: $fileName (${_formatBytes(fileSize)})');
      
    } catch (e) {
      debugPrint('Error sending file: $e');
      final transfer = _transfers.lastWhere((t) => t.device == device);
      transfer.status = TransferStatus.failed;
      notifyListeners();
    } finally {
      socket?.close();
    }
  }

  Future<String> _getDeviceName() async {
    try {
      return Platform.localHostname;
    } catch (e) {
      return 'Unknown Device';
    }
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  void clearTransfers() {
    _transfers.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _serverSocket?.close();
    super.dispose();
  }
}
