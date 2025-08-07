import 'dart:async';
import 'package:geolocator/geolocator.dart';
import '../models/user_model.dart';
import '../models/trip_model.dart';
import '../models/contact_model.dart';
import '../models/settings_model.dart';
import 'location_service.dart';
import 'bluetooth_service.dart';
import 'notification_service.dart';
import 'storage_service.dart';

class DetectionService {
  // שירותים נדרשים
  final LocationService locationService;
  final BluetoothService bluetoothService;
  final NotificationService notificationService;
  final StorageService storageService;
  
  // טיימרים ומונים
  Timer? _detectionTimer;
  Timer? _alertTimer;
  DateTime? _parkingTime;
  DateTime? _userDepartureTime;
  bool _initialAlertSent = false;
  bool _secondaryAlertSent = false;
  bool _emergencyAlertSent = false;
  
  // סטטוס מערכת
  bool _isMonitoring = false;
  bool _isPotentialRiskDetected = false;
  Trip? _currentTrip;
  
  // מנויים על אירועים
  StreamSubscription? _locationSubscription;
  StreamSubscription? _bluetoothSubscription;
  StreamSubscription? _parkingSubscription;
  
  // אירועים לשימוש חיצוני
  final _riskDetectedController = StreamController<void>.broadcast();
  final _monitoringStatusController = StreamController<bool>.broadcast();
  
  // Getters
  Stream<void> get onRiskDetected => _riskDetectedController.stream;
  Stream<bool> get monitoringStatus => _monitoringStatusController.stream;
  bool get isMonitoring => _isMonitoring;
  Trip? get currentTrip => _currentTrip;
  
  // Constructor
  DetectionService({
    required this.locationService,
    required this.bluetoothService,
    required this.notificationService,
    required this.storageService,
  });
  
  // אתחול השירות
  Future<void> init() async {
    // האזנה לאירועי מיקום
    _parkingSubscription = locationService.onParkingDetected.listen(_onParkingDetected);
    
    // האזנה לאירועי Bluetooth
    bluetoothService.onDisconnect = _onBluetoothDisconnect;
    _bluetoothSubscription = bluetoothService.connectionStatus.listen(_onBluetoothStatusChanged);
    
    // טעינת הגדרות
    await _loadSettings();
    
    return;
  }
  
  // טעינת הגדרות
  Future<void> _loadSettings() async {
    // כאן ניתן לטעון הגדרות ספציפיות שישפיעו על האלגוריתם
  }
  
  // התחלת ניטור
  Future<void> startMonitoring() async {
    if (_isMonitoring) return;
    
    _isMonitoring = true;
    _monitoringStatusController.add(true);
    
    // יצירת נסיעה חדשה
    _currentTrip = Trip(
      startTime: DateTime.now(),
      startLocation: locationService.lastPosition,
    );
    
    // איפוס משתנים
    _resetAlertStatus();
    
    // התחלת טיימר בדיקה
    _startDetectionTimer();
    
    print('ניטור הופעל');
  }
  
  // הפסקת ניטור
  Future<void> stopMonitoring() async {
    if (!_isMonitoring) return;
    
    _isMonitoring = false;
    _monitoringStatusController.add(false);
    
    // ביטול טיימרים
    _detectionTimer?.cancel();
    _alertTimer?.cancel();
    
    // סיום נסיעה נוכחית
    if (_currentTrip != null) {
      _currentTrip!.endTime = DateTime.now();
      _currentTrip!.endLocation = locationService.lastPosition;
      
      // שמירת הנסיעה במסד הנתונים
      await storageService.saveTrip(_currentTrip!);
      _currentTrip = null;
    }
    
    // איפוס משתנים
    _resetAlertStatus();
    
    print('ניטור הופסק');
  }
  
  // איפוס סטטוס התראות
  void _resetAlertStatus() {
    _initialAlertSent = false;
    _secondaryAlertSent = false;
    _emergencyAlertSent = false;
    _isPotentialRiskDetected = false;
    _parkingTime = null;
    _userDepartureTime = null;
  }
  
  // התחלת טיימר בדיקה
  void _startDetectionTimer() {
    // ביטול טיימר קודם אם קיים
    _detectionTimer?.cancel();
    
    // הפעלת טיימר חדש שבודק מצב כל 30 שניות
    _detectionTimer = Timer.periodic(Duration(seconds: 30), (_) {
      _checkForRiskSituation();
    });
  }
  
  // טיפול באירוע חניה
  void _onParkingDetected(Position parkingPosition) {
    if (!_isMonitoring) return;
    
    print('זוהתה חניה במיקום: ${parkingPosition.latitude}, ${parkingPosition.longitude}');
    
    // שמירת זמן החניה
    _parkingTime = DateTime.now();
    
    // אם יש נסיעה פעילה, נעדכן את מיקום הסיום
    if (_currentTrip != null) {
      _currentTrip!.parkingLocation = parkingPosition;
    }
  }
  
  // טיפול בניתוק Bluetooth
  void _onBluetoothDisconnect() {
    if (!_isMonitoring || _parkingTime == null) return;
    
    print('זוהה ניתוק Bluetooth');
    
    // שמירת זמן היציאה מהרכב
    _userDepartureTime = DateTime.now();
    
    // בדיקת פוטנציאל לסיכון
    _evaluateRiskAfterDeparture();
  }
  
  // טיפול בשינוי סטטוס Bluetooth
  void _onBluetoothStatusChanged(bool connected) {
    if (!_isMonitoring) return;
    
    if (!connected && _parkingTime != null) {
      // אם המכשיר התנתק ויש חניה פעילה, זה יכול להעיד על יציאה מהרכב
      _userDepartureTime = DateTime.now();
      _evaluateRiskAfterDeparture();
    }
  }
  
  // הערכת סיכון לאחר יציאה מהרכב
  Future<void> _evaluateRiskAfterDeparture() async {
    if (_userDepartureTime == null || _parkingTime == null) return;
    
    // בדיקת הסבירות שיש ילד ברכב
    bool childLikelyPresent = await _isChildLikelyPresent();
    
    if (childLikelyPresent) {
      _isPotentialRiskDetected = true;
      
      // בדיקת התרחקות מהרכב
      _monitorUserDistanceFromCar();
    }
  }
  
  // מעקב אחר התרחקות המשתמש מהרכב
  void _monitorUserDistanceFromCar() {
    // ביטול טיימר קודם אם קיים
    _alertTimer?.cancel();
    
    // הפעלת טיימר חדש שבודק את המרחק מהרכב כל 10 שניות
    _alertTimer = Timer.periodic(Duration(seconds: 10), (_) async {
      if (!_isMonitoring || !_isPotentialRiskDetected) {
        _alertTimer?.cancel();
        return;
      }
      
      // חישוב המרחק מהרכב
      double distance = locationService.getDistanceFromParking();
      
      // טעינת הגדרות המשתמש
      AppSettings settings = await storageService.getAppSettings();
      int maxDistance = settings.maxDistanceFromCar;
      
      print('מרחק נוכחי מהרכב: $distance מטר (מקסימום מוגדר: $maxDistance מטר)');
      
      // בדיקה אם המשתמש התרחק מספיק מהרכב
      if (distance > maxDistance) {
        _handleUserMovedAwayFromCar(distance);
      }
    });
  }
  
  // טיפול במצב שהמשתמש התרחק מהרכב
  Future<void> _handleUserMovedAwayFromCar(double distance) async {
    if (_initialAlertSent && _secondaryAlertSent && _emergencyAlertSent) {
      return; // כל ההתראות כבר נשלחו
    }
    
    // טעינת הגדרות
    AppSettings settings = await storageService.getAppSettings();
    
    // שליחת התראה ראשונית אם עדיין לא נשלחה
    if (!_initialAlertSent) {
      _sendInitialAlert(settings.initialAlertTimeoutSeconds);
      return;
    }
    
    // שליחת התראה משנית אם הראשונית כבר נשלחה אבל המשנית עדיין לא
    if (!_secondaryAlertSent) {
      _sendSecondaryAlert(settings.secondaryAlertTimeoutSeconds);
      return;
    }
    
    // שליחת התראת חירום אם שתי ההתראות הקודמות כבר נשלחו
    if (!_emergencyAlertSent) {
      await _sendEmergencyAlerts();
    }
  }
  
  // שליחת התראה ראשונית
  void _sendInitialAlert(int timeoutSeconds) {
    _initialAlertSent = true;
    
    // עדכון הנסיעה הנוכחית
    if (_currentTrip != null) {
      _currentTrip!.hasAlertSent = true;
    }
    
    print('שולחת התראה ראשונית. זמן המתנה: $timeoutSeconds שניות');
    
    // שליחת התראה למשתמש (using hardcoded strings as service doesn't have BuildContext)
    // TODO: Move strings to a configuration or pass from UI layer
    notificationService.showInitialAlert(
      title: 'Safety Check', // Will use system language
      body: 'Did you forget a child in the car? Please check immediately!',
      timeoutSeconds: timeoutSeconds,
      onResponse: _onInitialAlertResponse,
      onTimeout: () {
        if (_initialAlertSent && !_secondaryAlertSent) {
          _sendSecondaryAlert(30);
        }
      },
    );
    
    // עדכון שזוהה מצב סיכון
    _riskDetectedController.add(null);
  }
  
  // שליחת התראה משנית (חזקה יותר)
  void _sendSecondaryAlert(int timeoutSeconds) {
    _secondaryAlertSent = true;
    
    print('שולחת התראה משנית. זמן המתנה: $timeoutSeconds שניות');
    
    // שליחת התראה קריטית (using hardcoded strings as service doesn't have BuildContext)
    // TODO: Move strings to a configuration or pass from UI layer
    notificationService.showCriticalAlert(
      title: '⚠️ Critical Safety Alert!',
      body: 'Child suspected forgotten in car! Return to check immediately!',
      timeoutSeconds: timeoutSeconds,
      onResponse: _onCriticalAlertResponse,
      onTimeout: () {
        if (_secondaryAlertSent && !_emergencyAlertSent) {
          _sendEmergencyAlerts();
        }
      },
    );
  }
  
  // שליחת התראות חירום
  Future<void> _sendEmergencyAlerts() async {
    _emergencyAlertSent = true;
    
    print('שולחת התראות חירום לאנשי קשר');
    
    try {
      // טעינת אנשי קשר לחירום
      List<Contact> contacts = await storageService.getEmergencyContacts();
      
      if (contacts.isEmpty) {
        print('אין אנשי קשר מוגדרים לחירום');
        return;
      }
      
      // קבלת מיקום הרכב
      String address = 'מיקום לא ידוע';
      if (locationService.parkingPosition != null) {
        address = await locationService.getAddressFromPosition(
          locationService.parkingPosition!
        );
      }
      
      // קבלת פרטי משתמש ורכב
      UserModel? userProfile = await storageService.getUserProfile();
      
      if (userProfile == null) {
        print('לא נמצא פרופיל משתמש');
        return;
      }
      
      // בניית הודעת חירום (using English as default for emergency)
      // TODO: Use proper localization or detect phone language
      String emergencyMessage = 
        'EMERGENCY ALERT: Child may be forgotten in ${userProfile.name}\'s car. ' +
        'Car location: $address. ' +
        'Emergency numbers: Police 911, Emergency 911. ' +
        'Please go to location immediately!';
      
      // שליחת הודעות לכל אנשי הקשר
      for (Contact contact in contacts) {
        await notificationService.sendSmsAlert(
          phoneNumber: contact.phoneNumber,
          message: emergencyMessage,
        );
        
        print('נשלח SMS ל-${contact.name} (${contact.phoneNumber})');
        
        // המתנה קצרה בין שליחת הודעות
        await Future.delayed(Duration(seconds: 1));
      }
      
      // עדכון הנסיעה הנוכחית
      if (_currentTrip != null) {
        _currentTrip!.hasEmergencyAlertSent = true;
      }
    } catch (e) {
      print('שגיאה בשליחת התראות חירום: $e');
    }
  }
  
  // בדיקת מצבי סיכון
  Future<void> _checkForRiskSituation() async {
    if (!_isMonitoring) return;
    
    // אם כבר זוהה מצב סיכון, נמשיך במעקב
    if (_isPotentialRiskDetected) {
      return;
    }
    
    // בדיקה אם הרכב חונה
    bool isParked = locationService.isParked;
    
    if (isParked) {
      // בדיקה אם המשתמש התרחק מהרכב
      double distance = locationService.getDistanceFromParking();
      AppSettings settings = await storageService.getAppSettings();
      
      if (distance > settings.maxDistanceFromCar) {
        // בדיקה אם יש סבירות שילד נשכח ברכב
        bool childLikelyPresent = await _isChildLikelyPresent();
        
        if (childLikelyPresent) {
          print('זוהה מצב סיכון פוטנציאלי - מרחק מהרכב: $distance, סבירות לילד: גבוהה');
          _isPotentialRiskDetected = true;
          _userDepartureTime = DateTime.now();
          
          // התחלת מעקב התרחקות
          _monitorUserDistanceFromCar();
        }
      }
    }
  }
  
  // בדיקה אם יש סבירות שילד נשכח ברכב
  Future<bool> _isChildLikelyPresent() async {
    // טעינת פרופיל משתמש
    UserModel? userProfile = await storageService.getUserProfile();
    
    // אם אין פרופיל משתמש, נחזיר סבירות בינונית (50%)
    if (userProfile == null) {
      return _calculateRiskBasedOnPatterns(0.5);
    }
    
    // בדיקת היום והשעה
    DateTime now = DateTime.now();
    bool isWeekday = now.weekday >= 1 && now.weekday <= 5;
    bool isSchoolHours = now.hour >= 7 && now.hour <= 16;
    
    // חישוב סבירות בסיסית
    double baseProbability = 0.3; // סבירות בסיסית
    
    // אם זה יום חול ושעות לימודים, הסבירות גבוהה יותר
    if (isWeekday && isSchoolHours) {
      baseProbability += 0.3;
    }
    
    // חישוב סופי המבוסס על דפוסים
    return _calculateRiskBasedOnPatterns(baseProbability);
  }
  
  // חישוב סיכון המבוסס על דפוסי נסיעה
  Future<bool> _calculateRiskBasedOnPatterns(double baseProbability) async {
    try {
      // TODO: Implement getRecentTrips method in StorageService
      // For now, use a simple probability calculation
      
      // טעינת פרופיל משתמש לבדיקת העדפות
      UserModel? userProfile = await storageService.getUserProfile();
      
      if (userProfile != null) {
        // אם יש פרופיל משתמש, נוכל להתאים את הסבירות לפי העדפות
        // TODO: Add profile type support when profile model is extended
        // For now, use default thresholds
      }
      
      // ברירת מחדל - סף רגיל
      return baseProbability > 0.5;
    } catch (e) {
      print('שגיאה בחישוב סיכון: $e');
      // במקרה של שגיאה, נחזיר את הסבירות הבסיסית
      return baseProbability > 0.5;
    }
  }
  
  // האם המשתמש חזר לרכב
  bool _hasUserReturnedToCar() {
    if (!_isPotentialRiskDetected || locationService.parkingPosition == null) {
      return false;
    }
    
    // חישוב מרחק נוכחי מהרכב
    double distance = locationService.getDistanceFromParking();
    
    // אם המשתמש קרוב לרכב (פחות מ-10 מטר), נחשב שחזר לרכב
    return distance < 10;
  }
  
  // טיפול בתגובה להתראה ראשונית
  void _onInitialAlertResponse() {
    print('המשתמש הגיב להתראה הראשונית');
    
    // ביטול כל ההתראות והטיימרים
    _alertTimer?.cancel();
    
    // איפוס מצב סיכון
    _isPotentialRiskDetected = false;
    _resetAlertStatus();
    
    // ביטול כל ההתראות
    notificationService.cancelAllAlerts();
  }
  
  // טיפול בתגובה להתראה קריטית
  void _onCriticalAlertResponse() {
    print('המשתמש הגיב להתראה הקריטית');
    
    // ביטול כל ההתראות והטיימרים
    _alertTimer?.cancel();
    
    // איפוס מצב סיכון
    _isPotentialRiskDetected = false;
    _resetAlertStatus();
    
    // ביטול כל ההתראות
    notificationService.cancelAllAlerts();
  }
  
  // בדיקה האם המשתמש חזר לרכב (בדיקה ידנית)
  Future<void> checkUserReturnedToCar() async {
    if (!_isPotentialRiskDetected) return;
    
    double distance = locationService.getDistanceFromParking();
    
    // אם המשתמש קרוב לרכב (פחות מ-15 מטר), נחשב שחזר
    if (distance < 15) {
      print('זוהה חזרה לרכב - מרחק: $distance מטר');
      
      // איפוס מצב סיכון
      _isPotentialRiskDetected = false;
      _resetAlertStatus();
      
      // ביטול כל ההתראות
      await notificationService.cancelAllAlerts();
      
      // הודעה למשתמש (using hardcoded string as service doesn't have BuildContext)
      // TODO: Use proper localization
      await notificationService.showServiceNotification(
        title: '✅ Safety Confirmed',
        content: 'Return to car detected - System returned to normal monitoring',
      );
    }
  }
  
  // הפעלה ידנית של התראה (לבדיקה)
  void manuallyTriggerAlert() {
    _isPotentialRiskDetected = true;
    _userDepartureTime = DateTime.now();
    _sendInitialAlert(30);
  }
  
  // Backward compatibility methods
  void startTrip() {
    startMonitoring();
  }
  
  void endTrip() {
    stopMonitoring();
  }
  
  // ניקוי משאבים
  void dispose() {
    _detectionTimer?.cancel();
    _alertTimer?.cancel();
    _locationSubscription?.cancel();
    _bluetoothSubscription?.cancel();
    _parkingSubscription?.cancel();
    _riskDetectedController.close();
    _monitoringStatusController.close();
  }
}
