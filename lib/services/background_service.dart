import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackgroundService {
  // מופע יחיד של השירות
  static final FlutterBackgroundService _service = FlutterBackgroundService();
  
  // מזהה התראה לשירות רקע
  static const int _notificationId = 888;
  
  // הגדרות ברירת מחדל
  static double maxDistanceFromCar = 50.0; // מטרים
  static int alertTimeoutSeconds = 30;
  static String carBluetoothDeviceId = '';
  
  // אתחול השירות
  static Future<void> initializeService() async {
    try {
      await _service.configure(
        androidConfiguration: AndroidConfiguration(
          onStart: onStart,
          autoStart: true,
          isForegroundMode: true,
          notificationChannelId: 'car_safety_background',
          initialNotificationTitle: 'מערכת בטיחות לרכב',
          initialNotificationContent: 'מעקב אחר מיקום הרכב',
          foregroundServiceNotificationId: _notificationId,
          autoStartOnBoot: true,
        ),
        iosConfiguration: IosConfiguration(
          autoStart: true,
          onForeground: onStart,
          onBackground: onIosBackground,
        ),
      );
      
      print('שירות רקע אותחל בהצלחה');
    } catch (e) {
      print('שגיאה באתחול שירות רקע: $e');
    }
  }
  
  // התחלת מעקב
  static Future<void> startMonitoring() async {
    try {
      final isRunning = await _service.isRunning();
      if (!isRunning) {
        await _service.startService();
      }
      _service.invoke('start_monitoring');
      print('התחיל מעקב');
    } catch (e) {
      print('שגיאה בהתחלת מעקב: $e');
    }
  }
  
  // עצירת מעקב
  static Future<void> stopMonitoring() async {
    try {
      _service.invoke('stop_monitoring');
      print('עצר מעקב');
    } catch (e) {
      print('שגיאה בעצירת מעקב: $e');
    }
  }
  
  // עדכון הגדרות
  static Future<void> updateSettings({
    double? maxDistance,
    int? alertTimeout,
    String? bluetoothDeviceId,
  }) async {
    try {
      final settings = {
        'max_distance': maxDistance ?? maxDistanceFromCar,
        'alert_timeout': alertTimeout ?? alertTimeoutSeconds,
        'bluetooth_device_id': bluetoothDeviceId ?? carBluetoothDeviceId,
      };
      
      _service.invoke('update_settings', settings);
      
      // עדכון המשתנים המקומיים
      if (maxDistance != null) maxDistanceFromCar = maxDistance;
      if (alertTimeout != null) alertTimeoutSeconds = alertTimeout;
      if (bluetoothDeviceId != null) carBluetoothDeviceId = bluetoothDeviceId;
      
      print('הגדרות עודכנו');
    } catch (e) {
      print('שגיאה בעדכון הגדרות: $e');
    }
  }
  
  // בדיקה אם השירות פועל
  static Future<bool> isServiceRunning() async {
    try {
      return await _service.isRunning();
    } catch (e) {
      print('שגיאה בבדיקת מצב השירות: $e');
      return false;
    }
  }
}

// פונקציה ראשית לשירות הרקע - Android
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  print('שירות רקע התחיל');
  
  // משתנים למעקב
  bool isMonitoring = false;
  bool isParked = false;
  Position? parkingPosition;
  DateTime? userDepartureTime;
  StreamSubscription<Position>? locationSubscription;
  
  // הגדרות
  double maxDistance = 50.0;
  int alertTimeout = 30;
  String bluetoothDeviceId = '';
  
  // טעינת הגדרות
  try {
    final prefs = await SharedPreferences.getInstance();
    maxDistance = prefs.getDouble('max_distance') ?? 50.0;
    alertTimeout = prefs.getInt('alert_timeout') ?? 30;
    bluetoothDeviceId = prefs.getString('bluetooth_device_id') ?? '';
  } catch (e) {
    print('שגיאה בטעינת הגדרות: $e');
  }
  
  // הגדרת שירות foreground באנדרואיד
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  
  // מאזין לפקודות
  service.on('start_monitoring').listen((event) async {
    print('התחלת מעקב');
    isMonitoring = true;
    
    // התחלת מעקב מיקום
    try {
      locationSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      ).listen((Position position) async {
        if (!isMonitoring) return;
        
        print('מיקום עודכן: ${position.latitude}, ${position.longitude}');
        
        // זיהוי חניה (מהירות נמוכה)
        if (!isParked && position.speed < 1.0) {
          isParked = true;
          parkingPosition = position;
          userDepartureTime = null;
          print('זוהתה חניה');
        }
        
        // בדיקת מרחק מהרכב החונה
        if (isParked && parkingPosition != null) {
          double distance = Geolocator.distanceBetween(
            position.latitude,
            position.longitude,
            parkingPosition!.latitude,
            parkingPosition!.longitude,
          );
          
          // אם המשתמש התרחק מהרכב
          if (distance > maxDistance && userDepartureTime == null) {
            userDepartureTime = DateTime.now();
            print('משתמש התרחק מהרכב: ${distance.toStringAsFixed(1)} מטר');
            
            // כאן ניתן להוסיף לוגיקה להתראות
            // לדוגמה: שליחת אירוע לאפליקציה הראשית
            service.invoke('user_departed_from_car', {
              'distance': distance,
              'parking_location': {
                'latitude': parkingPosition!.latitude,
                'longitude': parkingPosition!.longitude,
              },
              'current_location': {
                'latitude': position.latitude,
                'longitude': position.longitude,
              },
            });
          }
        }
      });
    } catch (e) {
      print('שגיאה במעקב מיקום: $e');
    }
  });
  
  service.on('stop_monitoring').listen((event) {
    print('עצירת מעקב');
    isMonitoring = false;
    isParked = false;
    parkingPosition = null;
    userDepartureTime = null;
    locationSubscription?.cancel();
  });
  
  service.on('update_settings').listen((event) {
    if (event != null) {
      maxDistance = event['max_distance'] ?? maxDistance;
      alertTimeout = event['alert_timeout'] ?? alertTimeout;
      bluetoothDeviceId = event['bluetooth_device_id'] ?? bluetoothDeviceId;
      print('הגדרות עודכנו בשירות הרקע');
    }
  });
  
  // עדכון תקופתי של הודעת השירות
  Timer.periodic(const Duration(seconds: 30), (timer) async {
    if (service is AndroidServiceInstance) {
      try {
        String status = isMonitoring ? 'פעיל' : 'לא פעיל';
        String parkingStatus = isParked ? 'חונה' : 'נוסע';
        
        service.setForegroundNotificationInfo(
          title: 'מערכת בטיחות לרכב',
          content: 'מעקב: $status | מצב: $parkingStatus',
        );
      } catch (e) {
        print('שגיאה בעדכון הודעת שירות: $e');
      }
    }
  });
}

// פונקציה לרקע iOS
@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  print('שירות רקע iOS פועל');
  return true;
}
