import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../services/storage_service.dart';
import '../services/locale_service.dart';
import '../utils/permissions_helper.dart';
import '../models/settings_model.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isLoading = true;
  bool _startOnBoot = false;
  bool _useBluetooth = true;
  bool _useGPS = true;
  bool _enableSoundAlerts = true;
  bool _enableVibration = true;
  String _appVersion = '';
  
  int _initialAlertTimeout = 30; // seconds
  int _secondaryAlertTimeout = 60; // seconds
  int _maxDistanceFromCar = 50; // meters

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _appVersion = packageInfo.version;
      });
    } catch (e) {
      // Error loading app version
      print('Error loading app version: $e');
    }
  }

  Future<void> _loadSettings() async {
    final storageService = Provider.of<StorageService>(context, listen: false);
    
    try {
      final settings = await storageService.getAppSettings();
      
      setState(() {
        _startOnBoot = settings.startOnBoot;
        _useBluetooth = settings.useBluetooth;
        _useGPS = settings.useGPS;
        _enableSoundAlerts = settings.enableSoundAlerts;
        _enableVibration = settings.enableVibration;
        _initialAlertTimeout = settings.initialAlertTimeoutSeconds;
        _secondaryAlertTimeout = settings.secondaryAlertTimeoutSeconds;
        _maxDistanceFromCar = settings.maxDistanceFromCar;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading settings: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSettings() async {
    final l10n = AppLocalizations.of(context);
    final storageService = Provider.of<StorageService>(context, listen: false);
    
    final settings = AppSettings(
      startOnBoot: _startOnBoot,
      useBluetooth: _useBluetooth,
      useGPS: _useGPS,
      enableSoundAlerts: _enableSoundAlerts,
      enableVibration: _enableVibration,
      initialAlertTimeoutSeconds: _initialAlertTimeout,
      secondaryAlertTimeoutSeconds: _secondaryAlertTimeout,
      maxDistanceFromCar: _maxDistanceFromCar,
    );
    
    await storageService.saveAppSettings(settings);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.settingsSaved)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final localeService = Provider.of<LocaleService>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: localeService.textDirection,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildLanguageSettings(l10n),
                    const SizedBox(height: 24),
                    _buildGeneralSettings(l10n),
                    const SizedBox(height: 24),
                    _buildAlertSettings(l10n),
                    const SizedBox(height: 24),
                    _buildSensorSettings(l10n),
                    const SizedBox(height: 24),
                    _buildAboutSection(l10n),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _saveSettings,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        l10n.save,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildLanguageSettings(AppLocalizations l10n) {
    return Consumer<LocaleService>(
      builder: (context, localeService, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.language,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: Text(l10n.language),
                  subtitle: Text(localeService.isHebrew 
                    ? l10n.hebrew 
                    : l10n.english),
                  leading: const Icon(Icons.language),
                  trailing: DropdownButton<String>(
                    value: localeService.currentLocale.languageCode,
                    onChanged: (String? newLanguage) async {
                      if (newLanguage != null) {
                        await localeService.changeLanguage(newLanguage);
                      }
                    },
                    items: [
                      DropdownMenuItem<String>(
                        value: 'he',
                        child: Text(localeService.getLocalizedLanguageName('he')),
                      ),
                      DropdownMenuItem<String>(
                        value: 'en',
                        child: Text(localeService.getLocalizedLanguageName('en')),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue.shade800),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.languageChangeImmediate,
                            style: TextStyle(color: Colors.blue.shade800),
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
      },
    );
  }

  Widget _buildGeneralSettings(AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.generalSettings,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: Text(l10n.startOnBoot),
              subtitle: Text(l10n.startOnBootDescription),
              value: _startOnBoot,
              onChanged: (value) {
                setState(() {
                  _startOnBoot = value;
                });
                
                if (value) {
                  PermissionsHelper.requestAutoStartPermission(context);
                }
              },
            ),
            SwitchListTile(
              title: Text(l10n.enableSoundAlerts),
              subtitle: Text('${l10n.enableSoundAlerts} - ${l10n.enableSoundAlerts}'),
              value: _enableSoundAlerts,
              onChanged: (value) {
                setState(() {
                  _enableSoundAlerts = value;
                });
              },
            ),
            SwitchListTile(
              title: Text(l10n.enableVibration),
              subtitle: Text('${l10n.enableVibration} - ${l10n.enableVibration}'),
              value: _enableVibration,
              onChanged: (value) {
                setState(() {
                  _enableVibration = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertSettings(AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.alertSettings,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(l10n.initialAlertTimeout),
              subtitle: Text(l10n.initialAlertTimeout),
              trailing: DropdownButton<int>(
                value: _initialAlertTimeout,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _initialAlertTimeout = value;
                    });
                  }
                },
                items: [15, 30, 45, 60, 90, 120, 180].map((seconds) {
                  String label = seconds < 60 
                      ? '$seconds ${l10n.seconds60Plus}' 
                      : '${seconds ~/ 60} ${l10n.minutes}';
                  
                  return DropdownMenuItem<int>(
                    value: seconds,
                    child: Text(label),
                  );
                }).toList(),
              ),
            ),
            ListTile(
              title: Text(l10n.secondaryAlertTimeout),
              subtitle: Text(l10n.secondaryAlertTimeout),
              trailing: DropdownButton<int>(
                value: _secondaryAlertTimeout,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _secondaryAlertTimeout = value;
                    });
                  }
                },
                items: [15, 30, 45, 60, 90, 120, 180].map((seconds) {
                  String label = seconds < 60 
                      ? '$seconds ${l10n.seconds60Plus}' 
                      : '${seconds ~/ 60} ${l10n.minutes}';
                  
                  return DropdownMenuItem<int>(
                    value: seconds,
                    child: Text(label),
                  );
                }).toList(),
              ),
            ),
            ListTile(
              title: Text(l10n.distanceFromCar),
              subtitle: Text(l10n.distanceFromCarDescription),
              trailing: DropdownButton<int>(
                value: _maxDistanceFromCar,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _maxDistanceFromCar = value;
                    });
                  }
                },
                items: [20, 30, 50, 75, 100].map((meters) {
                  return DropdownMenuItem<int>(
                    value: meters,
                    child: Text('$meters ${l10n.meters}'),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorSettings(AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.sensorSettings,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: Text(l10n.useBluetooth),
              subtitle: Text(l10n.useBluetoothDescription),
              value: _useBluetooth,
              onChanged: (value) async {
                setState(() {
                  _useBluetooth = value;
                });
                
                if (value) {
                  await PermissionsHelper.requestBluetoothPermissions(context);
                }
              },
            ),
            SwitchListTile(
              title: Text(l10n.useGPS),
              subtitle: Text(l10n.useGPSDescription),
              value: _useGPS,
              onChanged: (value) async {
                setState(() {
                  _useGPS = value;
                });
                
                if (value) {
                  await PermissionsHelper.requestLocationPermissions(context);
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade800),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.sensorRequirement,
                        style: TextStyle(color: Colors.blue.shade800),
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

  Widget _buildAboutSection(AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.aboutApp,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(l10n.appVersion),
              subtitle: Text(_appVersion),
              leading: const Icon(Icons.info_outline),
            ),
            const Divider(),
            ListTile(
              title: Text(l10n.checkPermissions),
              subtitle: Text(l10n.ensurePermissions),
              leading: const Icon(Icons.security),
              onTap: () => _checkAllPermissions(l10n),
            ),
            ListTile(
              title: Text(l10n.privacyPolicy),
              subtitle: Text(l10n.readPrivacyPolicy),
              leading: const Icon(Icons.privacy_tip_outlined),
              onTap: () => _showPrivacyPolicy(l10n),
            ),
            ListTile(
              title: Text(l10n.contactSupport),
              subtitle: Text(l10n.contactSupportDescription),
              leading: const Icon(Icons.email_outlined),
              onTap: () => _contactSupport(l10n),
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _checkAllPermissions(AppLocalizations l10n) async {
    setState(() {
      _isLoading = true;
    });
    
    // Check all required permissions
    final hasLocationPermission = await PermissionsHelper.requestLocationPermissions(context);
    final hasBluetoothPermission = await PermissionsHelper.requestBluetoothPermissions(context);
    final hasNotificationPermission = await PermissionsHelper.requestNotificationPermission(context);
    final hasSmsPermission = await PermissionsHelper.requestSmsPermission(context);
    
    setState(() {
      _isLoading = false;
    });
    
    // Show permissions summary
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.permissionsStatus),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPermissionStatus(l10n.location, hasLocationPermission),
            _buildPermissionStatus(l10n.bluetooth, hasBluetoothPermission),
            _buildPermissionStatus(l10n.notifications, hasNotificationPermission),
            _buildPermissionStatus(l10n.sms, hasSmsPermission),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPermissionStatus(String permissionName, bool isGranted) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            isGranted ? Icons.check_circle : Icons.cancel,
            color: isGranted ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Text(permissionName),
        ],
      ),
    );
  }
  
  void _showPrivacyPolicy(AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.privacyPolicy),
        content: SingleChildScrollView(
          child: Text(l10n.privacyPolicyContent),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }
  
  void _contactSupport(AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.contactSupport),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.contactDetails),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.email, size: 18),
                const SizedBox(width: 8),
                Text(l10n.supportEmail),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.phone, size: 18),
                const SizedBox(width: 8),
                Text(l10n.supportPhone),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }
}
