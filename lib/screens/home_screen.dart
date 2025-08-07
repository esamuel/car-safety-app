import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/detection_service.dart';
import '../services/location_service.dart';
import '../services/bluetooth_service.dart';
import '../widgets/status_indicator.dart';
import '../l10n/app_localizations.dart';
import 'profile_screen.dart';
import 'contacts_screen.dart';
import 'settings_screen.dart';
import 'developer_debug_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isMonitoring = false;

  @override
  Widget build(BuildContext context) {
    final detectionService = Provider.of<DetectionService>(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isMonitoring = !_isMonitoring;
                      if (_isMonitoring) {
                        detectionService.startTrip();
                      } else {
                        detectionService.endTrip();
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isMonitoring ? Colors.red : Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    _isMonitoring ? l10n.stopMonitoring : l10n.startMonitoring,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 24),
                // System Status Indicators
                _buildSystemStatusSection(context, l10n),
                const SizedBox(height: 16),
                // Current Trip Info
                if (_isMonitoring) _buildTripInfoCard(context, l10n),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildFeatureButton(
                      icon: Icons.people,
                      label: l10n.contacts,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContactsScreen(),
                          ),
                        );
                      },
                    ),
                    _buildFeatureButton(
                      icon: Icons.settings,
                      label: l10n.settings,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsScreen(),
                          ),
                        );
                      },
                    ),
                    _buildFeatureButton(
                      icon: Icons.person,
                      label: l10n.profile,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DeveloperDebugScreen(),
            ),
          );
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.bug_report, color: Colors.white),
        tooltip: 'Developer Debug',
      ),
    );
  }

  Widget _buildSystemStatusSection(BuildContext context, AppLocalizations l10n) {
    final locationService = Provider.of<LocationService>(context);
    final bluetoothService = Provider.of<BluetoothService>(context);
    
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.system_update_alt, color: Colors.blue[600]),
                const SizedBox(width: 8),
                Text(
                  'System Status',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.blue[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // GPS Status
            _buildStatusRow(
              icon: Icons.gps_fixed,
              label: l10n.locationService,
              isConnected: locationService.lastPosition != null,
              details: locationService.lastPosition != null 
                  ? 'Location: ${locationService.lastPosition!.latitude.toStringAsFixed(4)}, ${locationService.lastPosition!.longitude.toStringAsFixed(4)}'
                  : l10n.locationServiceDisabled,
            ),
            const SizedBox(height: 8),
            // Bluetooth Status
            _buildStatusRow(
              icon: Icons.bluetooth,
              label: l10n.bluetoothService,
              isConnected: bluetoothService.isConnected,
              details: bluetoothService.isConnected 
                  ? '${l10n.connectedToDevice}: ${bluetoothService.connectedDeviceName ?? "Unknown"}'
                  : l10n.disconnectedFromDevice,
            ),
            const SizedBox(height: 8),
            // Parking Status
            _buildStatusRow(
              icon: Icons.local_parking,
              label: 'Parking Detection',
              isConnected: locationService.isParked,
              details: locationService.isParked 
                  ? '${l10n.parkingDetected} - Distance: ${locationService.getDistanceFromParking().toStringAsFixed(1)}m'
                  : 'Vehicle in motion or no parking detected',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow({
    required IconData icon,
    required String label,
    required bool isConnected,
    required String details,
  }) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isConnected ? Colors.green : Colors.red,
          ),
          child: Icon(
            icon,
            size: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                details,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: isConnected ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isConnected ? Colors.green : Colors.red,
              width: 1,
            ),
          ),
          child: Text(
            isConnected ? 'Active' : 'Inactive',
            style: TextStyle(
              color: isConnected ? Colors.green[700] : Colors.red[700],
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTripInfoCard(BuildContext context, AppLocalizations l10n) {
    final detectionService = Provider.of<DetectionService>(context);
    final locationService = Provider.of<LocationService>(context);
    
    return Card(
      color: Colors.blue[50],
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.trip_origin, color: Colors.blue[600]),
                const SizedBox(width: 8),
                Text(
                  'Current Trip',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.blue[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (detectionService.currentTrip != null) ..[
              _buildTripInfoRow(
                icon: Icons.access_time,
                label: 'Trip Duration',
                value: _getTripDuration(detectionService.currentTrip!.startTime),
              ),
              const SizedBox(height: 6),
              if (locationService.isParked) ..[
                _buildTripInfoRow(
                  icon: Icons.local_parking,
                  label: 'Parking Duration',
                  value: locationService.parkingPosition != null 
                      ? _getParkingDuration()
                      : 'Just parked',
                ),
                const SizedBox(height: 6),
              ],
              _buildTripInfoRow(
                icon: Icons.location_on,
                label: 'Current Distance from Car',
                value: '${locationService.getDistanceFromParking().toStringAsFixed(1)} meters',
              ),
            ] else [
              const Text('Trip information not available'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTripInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.blue[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            color: Colors.blue[700],
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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

  String _getParkingDuration() {
    final locationService = Provider.of<LocationService>(context, listen: false);
    if (locationService.parkingPosition == null) return 'Unknown';
    
    final duration = DateTime.now().difference(locationService.parkingPosition!.timestamp);
    final minutes = duration.inMinutes;
    
    if (minutes < 1) {
      return 'Just now';
    } else if (minutes < 60) {
      return '${minutes}m ago';
    } else {
      final hours = duration.inHours;
      final remainingMinutes = minutes % 60;
      return '${hours}h ${remainingMinutes}m ago';
    }
  }

  Widget _buildFeatureButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.blue.shade100,
            child: Icon(icon, color: Colors.blue, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}
