import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/detection_service.dart';
import '../services/location_service.dart';
import '../services/bluetooth_service.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';
import '../l10n/app_localizations.dart';

class DeveloperDebugScreen extends StatefulWidget {
  const DeveloperDebugScreen({super.key});

  @override
  _DeveloperDebugScreenState createState() => _DeveloperDebugScreenState();
}

class _DeveloperDebugScreenState extends State<DeveloperDebugScreen> {
  List<String> _debugLogs = [];

  void _addLog(String message) {
    setState(() {
      _debugLogs.insert(0, '${DateTime.now().toLocal().toString().substring(11, 19)}: $message');
      if (_debugLogs.length > 20) {
        _debugLogs = _debugLogs.take(20).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final detectionService = Provider.of<DetectionService>(context);
    final locationService = Provider.of<LocationService>(context);
    final bluetoothService = Provider.of<BluetoothService>(context);
    final notificationService = Provider.of<NotificationService>(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🔧 Developer Debug'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Service Status Card
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📊 Service Status',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDebugStatusRow('GPS Location', locationService.lastPosition != null),
                    _buildDebugStatusRow('Bluetooth', bluetoothService.isConnected),
                    _buildDebugStatusRow('Detection Service', detectionService.isMonitoring),
                    _buildDebugStatusRow('Vehicle Parked', locationService.isParked),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Test Actions Card
            Card(
              color: Colors.green[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🧪 Test Actions',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Location Test Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              locationService.manuallyRecordParkingPosition();
                              _addLog('Manual parking position recorded');
                            },
                            icon: const Icon(Icons.local_parking),
                            label: const Text('Simulate Parking'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await bluetoothService.startScan();
                              _addLog('Bluetooth scan started');
                            },
                            icon: const Icon(Icons.bluetooth_searching),
                            label: const Text('Scan Bluetooth'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Alert Test Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              detectionService.manuallyTriggerAlert();
                              _addLog('Manual alert triggered');
                            },
                            icon: const Icon(Icons.warning),
                            label: const Text('Trigger Alert'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await notificationService.showServiceNotification(
                                title: 'Test Notification',
                                content: 'This is a test notification from developer mode',
                              );
                              _addLog('Test notification sent');
                            },
                            icon: const Icon(Icons.notifications),
                            label: const Text('Test Notification'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Service Control Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (detectionService.isMonitoring) {
                                detectionService.stopMonitoring();
                                _addLog('Monitoring stopped');
                              } else {
                                detectionService.startMonitoring();
                                _addLog('Monitoring started');
                              }
                            },
                            icon: Icon(detectionService.isMonitoring ? Icons.stop : Icons.play_arrow),
                            label: Text(detectionService.isMonitoring ? 'Stop Monitor' : 'Start Monitor'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: detectionService.isMonitoring ? Colors.red : Colors.green,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _debugLogs.clear();
                              });
                            },
                            icon: const Icon(Icons.clear),
                            label: const Text('Clear Logs'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Current Data Card
            Card(
              color: Colors.purple[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📈 Current Data',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[700],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDebugDataRow('GPS Lat/Lng', 
                      locationService.lastPosition != null 
                        ? '${locationService.lastPosition!.latitude.toStringAsFixed(6)}, ${locationService.lastPosition!.longitude.toStringAsFixed(6)}'
                        : 'No location data'),
                    _buildDebugDataRow('Distance from Car', '${locationService.getDistanceFromParking().toStringAsFixed(1)} meters'),
                    _buildDebugDataRow('Bluetooth Device', bluetoothService.connectedDeviceName ?? 'Not connected'),
                    _buildDebugDataRow('Trip Active', detectionService.currentTrip != null ? 'Yes' : 'No'),
                    if (detectionService.currentTrip != null)
                      _buildDebugDataRow('Trip Duration', 
                        _getTripDuration(detectionService.currentTrip!.startTime)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Debug Logs Card
            Card(
              color: Colors.grey[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📝 Debug Logs',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: _debugLogs.length,
                        itemBuilder: (context, index) {
                          return Text(
                            _debugLogs[index],
                            style: const TextStyle(
                              color: Colors.green,
                              fontFamily: 'monospace',
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDebugStatusRow(String label, bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(width: 8),
          Text(label),
          const Spacer(),
          Text(
            isActive ? 'ACTIVE' : 'INACTIVE',
            style: TextStyle(
              color: isActive ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDebugDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.purple[700]),
            ),
          ),
        ],
      ),
    );
  }

  String _getTripDuration(DateTime startTime) {
    final duration = DateTime.now().difference(startTime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
