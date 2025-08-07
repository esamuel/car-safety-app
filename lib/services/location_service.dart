import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  // סטרים לשידור שינויי מיקום
  StreamSubscription<Position>? _positionStreamSubscription;
  final _locationController = StreamController<Position>.broadcast();
  
  // מצבי מיקום
  Position? _lastPosition;
  Position? _parkingPosition;
  
  // מהירות והאטה
  double? _lastSpeed;
  DateTime? _lastSpeedUpdate;
  bool _isParked = false;
  
  // היסטוריית מיקומים לזיהוי דפוסים
  List<Position> _recentPositions = [];
  
  // Getters
  Stream<Position> get locationStream => _locationController.stream;
  Position? get lastPosition => _lastPosition;
  Position? get parkingPosition => _parkingPosition;
  bool get isParked => _isParked;
  
  // אירועים להאזנה
  final _parkingDetectedController = StreamController<Position>.broadcast();
  Stream<Position> get onParkingDetected => _parkingDetectedController.stream;
  
  // אתחול השירות
  Future<void> init() async {
    // בדיקת הרשאות מיקום
    bool permissionsGranted = await _checkLocationPermissions();
    if (!permissionsGranted) {
      throw Exception('הרשאות מיקום נדרשות לפעולת האפליקציה');
    }
    
    // טעינת מיקום חניה אחרון אם קיים
    await _loadLastParkingPosition();
    
    // התחלת מעקב אחר מיקום
    await _startLocationTracking();
    
    return;
  }
  
  // בדיקת הרשאות מיקום
  Future<bool> _checkLocationPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }
    
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      // המשתמש דחה לצמיתות את בקשת ההרשאה
      return false;
    }
    
    return true;
  }
  
  // מעקב אחר מיקום
  Future<void> _startLocationTracking() async {
    // הגדרות מעקב המיקום - איזון בין דיוק לחיסכון בסוללה
    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // עדכון מיקום כל 10 מטרים
    );
    
    // מנוי על עדכוני מיקום
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(_onPositionUpdate);
  }
  
  // טיפול בעדכון מיקום
  void _onPositionUpdate(Position position) {
    _lastPosition = position;
    _locationController.add(position);
    
    // שמירת היסטוריית מיקומים (עד 20 מיקומים אחרונים)
    _recentPositions.add(position);
    if (_recentPositions.length > 20) {
      _recentPositions.removeAt(0);
    }
    
    // עדכון מהירות
    _updateSpeedData(position);
    
    // בדיקת האם הרכב חנה
    _detectParkingStatus(position);
  }
  
  // עדכון נתוני מהירות
  void _updateSpeedData(Position position) {
    final now = DateTime.now();
    
    // שמירת מהירות נוכחית ועיתוי
    _lastSpeed = position.speed;
    _lastSpeedUpdate = now;
  }
  
  // זיהוי מצב חניה
  void _detectParkingStatus(Position position) {
    // אם אין די נתונים, לא ניתן לזהות חניה
    if (_lastSpeed == null || _recentPositions.length < 5) {
      return;
    }
    
    // זיהוי חניה: מהירות נמוכה למשך זמן מסוים + המכונית לא זזה
    bool isCurrentlyMoving = position.speed > 1.0; // מהירות במטרים/שנייה
    
    // בדיקה אם הרכב נעצר (היה בתנועה וכעת במהירות אפס)
    if (!isCurrentlyMoving && !_isParked) {
      // בדיקה אם המיקום לא השתנה משמעותית ב-X שניות האחרונות
      bool stationaryForPeriod = _isStationaryForPeriod();
      
      if (stationaryForPeriod) {
        // רכב חונה
        _isParked = true;
        _parkingPosition = position;
        _parkingDetectedController.add(position);
        
        // שמירת מיקום החניה
        _saveParkingPosition(position);
      }
    } 
    // אם הרכב מתחיל לנוע שוב
    else if (isCurrentlyMoving && _isParked) {
      _isParked = false;
      _parkingPosition = null;
    }
  }
  
  // בדיקה אם הרכב נייח לאורך זמן
  bool _isStationaryForPeriod() {
    if (_recentPositions.length < 5) {
      return false;
    }
    
    // חישוב מרחקים בין המיקומים האחרונים
    double maxDistance = 0;
    Position referencePosition = _recentPositions.last;
    
    for (int i = _recentPositions.length - 2; i >= _recentPositions.length - 5; i--) {
      double distance = Geolocator.distanceBetween(
        referencePosition.latitude,
        referencePosition.longitude,
        _recentPositions[i].latitude,
        _recentPositions[i].longitude,
      );
      
      if (distance > maxDistance) {
        maxDistance = distance;
      }
    }
    
    // אם המרחק המקסימלי בין המיקומים האחרונים קטן מ-20 מטר, הרכב נייח
    return maxDistance < 20;
  }
  
  // שמירת מיקום חניה
  Future<void> _saveParkingPosition(Position position) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('parking_latitude', position.latitude);
      await prefs.setDouble('parking_longitude', position.longitude);
      await prefs.setString('parking_time', DateTime.now().toIso8601String());
    } catch (e) {
      print('שגיאה בשמירת מיקום חניה: $e');
    }
  }
  
  // טעינת מיקום חניה אחרון
  Future<void> _loadLastParkingPosition() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      double? lat = prefs.getDouble('parking_latitude');
      double? lng = prefs.getDouble('parking_longitude');
      String? timeStr = prefs.getString('parking_time');
      
      if (lat != null && lng != null && timeStr != null) {
        // יצירת אובייקט Position מהנתונים השמורים
        final timestamp = DateTime.parse(timeStr);
        
        _parkingPosition = Position(
          latitude: lat,
          longitude: lng,
          timestamp: timestamp,
          accuracy: 0,
          altitude: 0,
          altitudeAccuracy: 0,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0,
        );
        
        // בדיקה אם החניה רלוונטית (לא מלפני יותר מ-24 שעות)
        final now = DateTime.now();
        final difference = now.difference(timestamp);
        if (difference.inHours < 24) {
          _isParked = true;
        } else {
          // אם החניה ישנה מדי, נאפס אותה
          _parkingPosition = null;
          _isParked = false;
        }
      }
    } catch (e) {
      print('שגיאה בטעינת מיקום חניה: $e');
    }
  }
  
  // קבלת מרחק מהחניה
  double getDistanceFromParking() {
    if (_lastPosition == null || _parkingPosition == null) {
      return 0;
    }
    
    return Geolocator.distanceBetween(
      _lastPosition!.latitude,
      _lastPosition!.longitude,
      _parkingPosition!.latitude,
      _parkingPosition!.longitude,
    );
  }
  
  // המרת מיקום לכתובת
  Future<String> getAddressFromPosition(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return '${place.street ?? ""}, ${place.locality ?? ""}, ${place.country ?? ""}';
      }
      
      return 'כתובת לא ידועה';
    } catch (e) {
      print('שגיאה בהמרת מיקום לכתובת: $e');
      return 'לא ניתן לקבל כתובת';
    }
  }
  
  // פונקציה להפעלה ידנית של רישום מיקום חניה
  void manuallyRecordParkingPosition() {
    if (_lastPosition != null) {
      _parkingPosition = _lastPosition;
      _isParked = true;
      _parkingDetectedController.add(_lastPosition!);
      _saveParkingPosition(_lastPosition!);
    }
  }
  
  // Backward compatibility method for detection service
  void recordParkingPosition() {
    manuallyRecordParkingPosition();
  }
  
  // Legacy method name for backward compatibility
  double distanceFromParking() {
    return getDistanceFromParking();
  }
  
  // ניקוי משאבים
  void dispose() {
    _positionStreamSubscription?.cancel();
    _locationController.close();
    _parkingDetectedController.close();
  }
}
