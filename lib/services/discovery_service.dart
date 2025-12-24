import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:nsd/nsd.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:network_info_plus/network_info_plus.dart';
import '../models/device.dart';

class DiscoveryService extends ChangeNotifier {
  final String _serviceType = '_aktie._tcp';
  final int _servicePort = 8888;
  
  Discovery? _discovery;
  Registration? _registration;
  
  final List<Device> _discoveredDevices = [];
  List<Device> get discoveredDevices => List.unmodifiable(_discoveredDevices);
  
  String _deviceName = 'Unknown Device';
  String get deviceName => _deviceName;
  
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Load device name from preferences
      final prefs = await SharedPreferences.getInstance();
      _deviceName = prefs.getString('device_name') ?? await _getDefaultDeviceName();
      
      // Register this device on the network
      await _registerService();
      
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing discovery service: $e');
    }
  }

  Future<String> _getDefaultDeviceName() async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        return Platform.localHostname;
      } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
        return Platform.localHostname;
      }
    } catch (e) {
      debugPrint('Error getting device name: $e');
    }
    return 'Unknown Device';
  }

  Future<void> setDeviceName(String name) async {
    _deviceName = name;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('device_name', name);
    
    // Re-register with new name
    await stopDiscovery();
    await _registerService();
    await startDiscovery();
    
    notifyListeners();
  }

  Future<void> _registerService() async {
    try {
      final info = NetworkInfo();
      final wifiIP = await info.getWifiIP();
      
      if (wifiIP == null) {
        debugPrint('No WiFi IP address found');
        return;
      }

      _registration = await register(
        Service(
          name: _deviceName,
          type: _serviceType,
          port: _servicePort,
        ),
      );
      
      debugPrint('Service registered: $_deviceName on port $_servicePort');
    } catch (e) {
      debugPrint('Error registering service: $e');
    }
  }

  Future<void> startDiscovery() async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      _discovery = await startDiscovery(_serviceType);
      
      _discovery!.addServiceListener((service, status) {
        if (status == ServiceStatus.found) {
          _onServiceFound(service);
        } else if (status == ServiceStatus.lost) {
          _onServiceLost(service);
        }
      });
      
      debugPrint('Discovery started for $_serviceType');
    } catch (e) {
      debugPrint('Error starting discovery: $e');
    }
  }

  void _onServiceFound(Service service) async {
    try {
      // Resolve the service to get IP and port
      final resolvedService = await resolve(service);
      
      // Don't add ourselves
      if (resolvedService.name == _deviceName) {
        return;
      }

      final device = Device(
        id: '${resolvedService.host}:${resolvedService.port}',
        name: resolvedService.name ?? 'Unknown',
        ipAddress: resolvedService.host ?? '',
        port: resolvedService.port ?? _servicePort,
      );

      if (!_discoveredDevices.contains(device)) {
        _discoveredDevices.add(device);
        notifyListeners();
        debugPrint('Device found: ${device.name} at ${device.ipAddress}:${device.port}');
      }
    } catch (e) {
      debugPrint('Error resolving service: $e');
    }
  }

  void _onServiceLost(Service service) {
    _discoveredDevices.removeWhere((device) => 
      device.name == service.name
    );
    notifyListeners();
    debugPrint('Device lost: ${service.name}');
  }

  Future<void> stopDiscovery() async {
    try {
      await _discovery?.stop();
      await _registration?.unregister();
      _discoveredDevices.clear();
      notifyListeners();
      debugPrint('Discovery stopped');
    } catch (e) {
      debugPrint('Error stopping discovery: $e');
    }
  }

  @override
  void dispose() {
    stopDiscovery();
    super.dispose();
  }
}
