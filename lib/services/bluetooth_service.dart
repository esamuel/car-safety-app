import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Note: Bluetooth packages temporarily disabled due to compatibility issues
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

// Simplified device class for mock purposes
class MockBluetoothDevice {
  final String id;
  final String name;
  final int rssi;
  
  MockBluetoothDevice({required this.id, required this.name, this.rssi = 0});
}

class BluetoothService {
  // Mock Bluetooth functionality until proper packages are integrated
  
  // מכשירים
  List<MockBluetoothDevice> _discoveredDevices = [];
  String? _carDeviceId; // מזהה מכשיר הרכב שנשמר
  MockBluetoothDevice? _connectedCarDevice; // מכשיר הרכב המחובר
  
  // סטטוס חיבור
  bool _isConnected = false;
  bool _isScanning = false;
  
  // סטרימים לאירועים
  final _connectionStatusController = StreamController<bool>.broadcast();
  Timer? _mockConnectionTimer;
  Timer? _mockScanTimer;
  
  // פונקציות callback
  VoidCallback? onConnect;
  VoidCallback? onDisconnect;
  
  // Getters
  Stream<bool> get connectionStatus => _connectionStatusController.stream;
  bool get isConnected => _isConnected;
  List<MockBluetoothDevice> get discoveredDevices => _discoveredDevices;
  String? get connectedDeviceName => _connectedCarDevice?.name;
  
  // אתחול השירות
  Future<void> init() async {
    print('אתחול שירות Bluetooth (מצב סימולציה)');
    
    // בדיקת הרשאות Bluetooth
    bool permissionsGranted = await _checkBluetoothPermissions();
    if (!permissionsGranted) {
      print('הרשאות Bluetooth חסרות');
      return;
    }
    
    // טעינת מזהה מכשיר הרכב אם קיים
    await _loadSavedCarDevice();
    
    // סימולציה של מצב Bluetooth זמין
    if (_carDeviceId != null) {
      // סימולציה של התחברות אוטומטית למכשיר שמור
      Future.delayed(Duration(seconds: 2), () {
        _connectToSavedDevice();
      });
    }
    
    return;
  }
  
  // בדיקת הרשאות Bluetooth
  Future<bool> _checkBluetoothPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ].request();
    
    return statuses[Permission.bluetoothScan]!.isGranted && 
           statuses[Permission.bluetoothConnect]!.isGranted;
  }
  
  // טעינת מזהה מכשיר הרכב שנשמר
  Future<void> _loadSavedCarDevice() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _carDeviceId = prefs.getString('car_bluetooth_device_id');
    } catch (e) {
      print('שגיאה בטעינת מזהה מכשיר Bluetooth: $e');
    }
  }
  
  // שמירת מזהה מכשיר הרכב
  Future<void> _saveCarDevice(String deviceId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('car_bluetooth_device_id', deviceId);
      _carDeviceId = deviceId;
    } catch (e) {
      print('שגיאה בשמירת מזהה מכשיר Bluetooth: $e');
    }
  }
  
  // התחברות למכשיר שמור
  Future<void> _connectToSavedDevice() async {
    if (_carDeviceId == null) return;
    
    try {
      await connectToDevice(_carDeviceId!);
    } catch (e) {
      print('שגיאה בהתחברות למכשיר שמור: $e');
    }
  }
  
  // סריקת מכשירי Bluetooth (סימולציה)
  Future<void> startScan() async {
    if (_isScanning) return;
    
    _isScanning = true;
    _discoveredDevices = [];
    
    print('מתחיל סריקת Bluetooth (סימולציה)');
    
    // סימולציה של מכשירים שנמצאו
    _mockScanTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (timer.tick <= 5) { // מוסיף מכשיר כל 2 שניות במשך 10 שניות
        _discoveredDevices.add(MockBluetoothDevice(
          id: 'mock_device_${timer.tick}',
          name: 'רכב ${timer.tick}',
          rssi: -50 - (timer.tick * 10),
        ));
      } else {
        timer.cancel();
        _isScanning = false;
        print('סיום סריקת Bluetooth (סימולציה)');
      }
    });
  }
  
  // עצירת סריקה (סימולציה)
  Future<void> stopScan() async {
    if (!_isScanning) return;
    
    _mockScanTimer?.cancel();
    _isScanning = false;
    print('עצירת סריקת Bluetooth (סימולציה)');
  }
  
  // התחברות למכשיר (סימולציה)
  Future<void> connectToDevice(String deviceId) async {
    print('מתחבר למכשיר: $deviceId (סימולציה)');
    
    // ניתוק מהתקן קודם אם מחובר
    if (_isConnected) {
      await disconnectFromDevice();
    }
    
    // סימולציה של תהליך התחברות
    _mockConnectionTimer = Timer(Duration(seconds: 2), () {
      _isConnected = true;
      _updateConnectionStatus(true);
      
      // שמירת פרטי המכשיר
      _saveCarDevice(deviceId);
      _connectedCarDevice = _discoveredDevices.firstWhere(
        (d) => d.id == deviceId,
        orElse: () => MockBluetoothDevice(
          id: deviceId,
          name: 'רכב מחובר',
        ),
      );
      
      print('התחברות למכשיר Bluetooth הושלמה (סימולציה)');
      
      // הפעלת callback להתחברות
      onConnect?.call();
      
      // סימולציה של ניתוק אחרי 30 שניות (לבדיקת המערכת)
      Timer(Duration(seconds: 30), () {
        if (_isConnected) {
          print('ניתוק אוטומטי מ-Bluetooth (סימולציה)');
          _isConnected = false;
          _updateConnectionStatus(false);
          onDisconnect?.call();
        }
      });
    });
  }
  
  // ניתוק ממכשיר (סימולציה)
  Future<void> disconnectFromDevice() async {
    _mockConnectionTimer?.cancel();
    _isConnected = false;
    _updateConnectionStatus(false);
    
    print('ניתוק ממכשיר Bluetooth (סימולציה)');
    
    // הפעלת callback לניתוק
    onDisconnect?.call();
  }
  
  // עדכון סטטוס חיבור
  void _updateConnectionStatus(bool connected) {
    _isConnected = connected;
    _connectionStatusController.add(connected);
  }
  
  // בדיקה אם מכשיר הרכב השמור מחובר
  Future<bool> isCarDeviceConnected() async {
    if (_carDeviceId == null) return false;
    
    // בדיקה אם המכשיר מחובר כרגע
    return _isConnected;
  }
  
  // Backward compatibility method
  Future<bool> isConnectedToCar() async {
    return isCarDeviceConnected();
  }
  
  // Backward compatibility method
  Future<void> startScanning() async {
    return startScan();
  }
  
  // ניקוי משאבים
  void dispose() {
    _mockScanTimer?.cancel();
    _mockConnectionTimer?.cancel();
    _connectionStatusController.close();
  }
}
