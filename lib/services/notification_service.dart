import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_sms/flutter_sms.dart'; // Temporarily disabled
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/settings_model.dart';

class NotificationService {
  // מופע מרכזי להתראות מקומיות
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = 
      FlutterLocalNotificationsPlugin();
  
  // ערוצי התראות
  static const String _regularChannelId = 'car_safety_regular_channel';
  static const String _criticalChannelId = 'car_safety_critical_channel';
  
  // מזהי התראות
  static const int _initialAlertId = 1;
  static const int _criticalAlertId = 2;
  static const int _serviceNotificationId = 3;
  
  // טיימרים להתראות
  Timer? _initialAlertTimer;
  Timer? _criticalAlertTimer;
  
  // הגדרות
  bool _enableSoundAlerts = true;
  bool _enableVibration = true;
  
  // אתחול השירות
  Future<void> init() async {
    // טעינת הגדרות
    await _loadSettings();
    
    // אתחול התראות מקומיות
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_notification');
    
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
    
    // הגדרת ערוצי התראה באנדרואיד
    await _setupNotificationChannels();
  }
  
  // טעינת הגדרות
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _enableSoundAlerts = prefs.getBool('setting_enable_sound') ?? true;
      _enableVibration = prefs.getBool('setting_enable_vibration') ?? true;
    } catch (e) {
      print('שגיאה בטעינת הגדרות התראות: $e');
    }
  }
  
  // הגדרת ערוצי התראה לאנדרואיד
  Future<void> _setupNotificationChannels() async {
    // ערוץ התראות רגילות
    const AndroidNotificationChannel regularChannel = AndroidNotificationChannel(
      _regularChannelId,
      'התראות רגילות',
      description: 'התראות בטיחות רגילות',
      importance: Importance.high,
    );
    
    // ערוץ התראות קריטיות
    const AndroidNotificationChannel criticalChannel = AndroidNotificationChannel(
      _criticalChannelId,
      'התראות חירום',
      description: 'התראות בטיחות קריטיות',
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound('critical_alert'),
    );
    
    // יצירת הערוצים
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(regularChannel);
    
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(criticalChannel);
  }
  
  // טיפול בהקשה על התראה
  void _onNotificationTapped(NotificationResponse response) {
    print('התראה נלחצה: ${response.payload}');
  }
  
  // הצגת התראה ראשונית
  Future<void> showInitialAlert({
    required String title,
    required String body,
    required int timeoutSeconds,
    required VoidCallback onResponse,
    required VoidCallback onTimeout,
  }) async {
    // ביטול טיימרים קודמים
    _initialAlertTimer?.cancel();
    
    // נגינת צליל התראה אם מופעל (placeholder)
    if (_enableSoundAlerts) {
      print('נגינת צליל התראה');
    }
    
    // הפעלת רטט אם מופעל (placeholder)
    if (_enableVibration) {
      print('הפעלת רטט');
    }
    
    // הגדרת פעולות
    List<AndroidNotificationAction> actions = [
      AndroidNotificationAction(
        'ok_action',
        'הכל בסדר',
        showsUserInterface: true,
      ),
      AndroidNotificationAction(
        'check_action',
        'בדוק את הרכב',
        showsUserInterface: true,
      ),
    ];
    
    // הגדרת פרטי התראה לאנדרואיד
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      _regularChannelId,
      'התראות רגילות',
      channelDescription: 'התראות בטיחות רגילות',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'התראת בטיחות',
      category: AndroidNotificationCategory.alarm,
      fullScreenIntent: true,
      actions: actions,
    );
    
    // הגדרת פרטי התראה ל-iOS
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'alert.mp3',
      categoryIdentifier: 'car_safety',
    );
    
    // הגדרת פרטי התראה כלליים
    NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    // הצגת ההתראה
    await _flutterLocalNotificationsPlugin.show(
      _initialAlertId,
      title,
      body,
      details,
      payload: 'initial_alert',
    );
    
    print('הוצגה התראה ראשונית: $title');
    
    // הגדרת טיימר לפעולת timeout
    _initialAlertTimer = Timer(Duration(seconds: timeoutSeconds), () {
      onTimeout();
    });
  }
  
  // הצגת התראה קריטית
  Future<void> showCriticalAlert({
    required String title,
    required String body,
    required int timeoutSeconds,
    required VoidCallback onResponse,
    required VoidCallback onTimeout,
  }) async {
    // ביטול טיימרים קודמים
    _criticalAlertTimer?.cancel();
    
    // הפעלת התראה קולית ווויזואלית משמעותית (placeholder)
    if (_enableSoundAlerts) {
      print('נגינת צליל התראה קריטי');
    }
    
    // הפעלת רטט מתמשך (placeholder)
    if (_enableVibration) {
      print('הפעלת רטט מתמשך');
    }
    
    // הגדרת פעולות
    List<AndroidNotificationAction> actions = [
      AndroidNotificationAction(
        'respond_action',
        'חזרתי לרכב',
        showsUserInterface: true,
      ),
    ];
    
    // הגדרת פרטי התראה לאנדרואיד
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      _criticalChannelId,
      'התראות חירום',
      channelDescription: 'התראות בטיחות קריטיות',
      importance: Importance.max,
      priority: Priority.max,
      ticker: 'התראת חירום!',
      category: AndroidNotificationCategory.alarm,
      fullScreenIntent: true,
      ongoing: true,
      autoCancel: false,
      color: Colors.red,
      colorized: true,
      actions: actions,
    );
    
    // הגדרת פרטי התראה ל-iOS
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'critical_alert.mp3',
      interruptionLevel: InterruptionLevel.critical,
    );
    
    // הגדרת פרטי התראה כלליים
    NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    // הצגת ההתראה
    await _flutterLocalNotificationsPlugin.show(
      _criticalAlertId,
      title,
      body,
      details,
      payload: 'critical_alert',
    );
    
    print('הוצגה התראה קריטית: $title');
    
    // הגדרת טיימר לפעולת timeout
    _criticalAlertTimer = Timer(Duration(seconds: timeoutSeconds), () {
      print('עצירת צליל והפסקת רטט');
      onTimeout();
    });
  }
  
  // שליחת הודעת SMS (מצב סימולציה/fallback)
  Future<void> sendSmsAlert({
    required String phoneNumber,
    required String message,
  }) async {
    try {
      // אפשרות 1: פתיחת אפליקציית SMS המקומית
      final Uri smsUri = Uri(
        scheme: 'sms',
        path: phoneNumber,
        queryParameters: {'body': message},
      );
      
      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
        print('נפתחה אפליקציית SMS למספר $phoneNumber');
      } else {
        // אפשרות 2: פתיחת אפליקציית טלפון לחיוג
        final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);
        if (await canLaunchUrl(telUri)) {
          await launchUrl(telUri);
          print('נפתחה אפליקציית טלפון למספר $phoneNumber');
        } else {
          print('לא ניתן לפתוח אפליקציית SMS או טלפון');
        }
      }
    } catch (e) {
      print('שגיאה בשליחת SMS: $e');
      // במקרה של שגיאה, לפחות נציג התראה למשתמש
      await showServiceNotification(
        title: '⚠️ דרושה פעולה ידנית',
        content: 'אנא התקשר ל-$phoneNumber: $message',
      );
    }
  }
  
  // ביטול כל ההתראות
  Future<void> cancelAllAlerts() async {
    _initialAlertTimer?.cancel();
    _criticalAlertTimer?.cancel();
    print('הפסקת כל הצלילים והרטט');
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
  
  // ביטול התראה ספציפית
  Future<void> cancelAlert(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }
  
  // הצגת התראת שירות (לשירות רקע)
  Future<void> showServiceNotification({
    required String title,
    required String content,
  }) async {
    // הגדרת פרטי התראה לאנדרואיד
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      _regularChannelId,
      'התראות שירות',
      channelDescription: 'התראות מצב שירות',
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      autoCancel: false,
    );
    
    // הגדרת פרטי התראה כלליים
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );
    
    // הצגת ההתראה
    await _flutterLocalNotificationsPlugin.show(
      _serviceNotificationId,
      title,
      content,
      details,
      payload: 'service_notification',
    );
  }
  
  // עדכון הגדרות
  Future<void> updateSettings(AppSettings settings) async {
    _enableSoundAlerts = settings.enableSoundAlerts;
    _enableVibration = settings.enableVibration;
  }
  
  // ניקוי משאבים
  void dispose() {
    _initialAlertTimer?.cancel();
    _criticalAlertTimer?.cancel();
    print('ניקוי משאבי NotificationService');
  }
}
