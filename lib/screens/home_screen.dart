import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/discovery_service.dart';
import '../services/transfer_service.dart';
import '../widgets/user_header.dart';
import '../widgets/device_list.dart';
import '../widgets/file_picker_button.dart';
import '../models/device.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeServices();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _initializeServices();
    } else if (state == AppLifecycleState.paused) {
      context.read<DiscoveryService>().stopDiscovery();
    }
  }

  Future<void> _initializeServices() async {
    final discoveryService = context.read<DiscoveryService>();
    final transferService = context.read<TransferService>();

    await discoveryService.initialize();
    await transferService.initialize();

    discoveryService.startDiscovery();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      body: SafeArea(
        child: Column(
          children: [
            // Header with user info and close button
            const UserHeader(),

            // Main content area
            Expanded(
              child: Consumer<DiscoveryService>(
                builder: (context, discoveryService, child) {
                  final devices = discoveryService.discoveredDevices;

                  if (devices.isEmpty) {
                    return _buildEmptyState();
                  }

                  return DeviceList(devices: devices);
                },
              ),
            ),

            // Help text at bottom
            _buildHelpText(),

            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: const FilePickerButton(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          const Text(
            'No People Found',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'There is no one nearby to share with.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 16,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildHelpText() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Can\'t see people nearby?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'To share, make sure both devices have\nthe app open and are on the same network.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Icon(
            Icons.devices,
            color: Colors.white.withOpacity(0.3),
            size: 60,
          ),
        ],
      ),
    );
  }
}
