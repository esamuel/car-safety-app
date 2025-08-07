// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/contacts_screen.dart';
import 'screens/settings_screen.dart';
import 'services/location_service.dart';
import 'services/bluetooth_service.dart';
import 'services/notification_service.dart';
import 'services/detection_service.dart';
import 'services/storage_service.dart';
import 'services/background_service.dart';
import 'services/locale_service.dart';
import 'l10n/app_localizations.dart';

void main() async {
  // וידוא שכל מנגנוני Flutter מאותחלים
  WidgetsFlutterBinding.ensureInitialized();
  
  // אתחול שירות הרקע
  await BackgroundService.initializeService();
  
  // אתחול שירותים
  final storageService = StorageService();
  await storageService.init();
  
  final notificationService = NotificationService();
  await notificationService.init();
  
  final locationService = LocationService();
  await locationService.init();
  
  final bluetoothService = BluetoothService();
  await bluetoothService.init();
  
  final localeService = LocaleService();
  await localeService.init();
  
  // בדיקה אם האפליקציה הופעלה מהתראה
  await _checkIfLaunchedFromNotification(notificationService);
  
  // הפעלת האפליקציה
  runApp(
    MultiProvider(
      providers: [
        // ספקי שירותים
        Provider<StorageService>(create: (_) => storageService),
        Provider<NotificationService>(create: (_) => notificationService),
        Provider<LocationService>(create: (_) => locationService),
        Provider<BluetoothService>(create: (_) => bluetoothService),
        ChangeNotifierProvider<LocaleService>(create: (_) => localeService),
        
        // שירות הזיהוי (תלוי בשירותים אחרים)
        Provider<DetectionService>(
          create: (context) {
            final detectionService = DetectionService(
              locationService: context.read<LocationService>(),
              bluetoothService: context.read<BluetoothService>(),
              notificationService: context.read<NotificationService>(),
              storageService: context.read<StorageService>(),
            );
            
            // אתחול שירות הזיהוי
            detectionService.init();
            
            return detectionService;
          },
          dispose: (_, service) => service.dispose(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

// בדיקה אם האפליקציה הופעלה מהתראה
Future<void> _checkIfLaunchedFromNotification(NotificationService notificationService) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = 
      FlutterLocalNotificationsPlugin();
  
  final notificationAppLaunchDetails = 
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  
  if (notificationAppLaunchDetails != null && 
      notificationAppLaunchDetails.didNotificationLaunchApp) {
    // האפליקציה הופעלה מהתראה - כאן ניתן להוסיף לוגיקה ספציפית
    print('האפליקציה הופעלה מהתראה: ${notificationAppLaunchDetails.notificationResponse?.payload}');
    
    // אם ההתראה קשורה לילד שנשכח ברכב, נוכל להציג מסך ספציפי
    if (notificationAppLaunchDetails.notificationResponse?.payload == 'critical_alert') {
      // נשמור מידע שנפתח ממצב חירום
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('opened_from_critical_alert', true);
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleService>(
      builder: (context, localeService, child) {
        return MaterialApp(
          title: 'Car Safety System',
          debugShowCheckedModeBanner: false,

          theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: localeService.isHebrew ? 'Heebo' : null,
            textTheme: TextTheme(
              displayLarge: TextStyle(
                fontFamily: localeService.isHebrew ? 'Heebo' : null,
                fontWeight: FontWeight.bold,
              ),
              displayMedium: TextStyle(
                fontFamily: localeService.isHebrew ? 'Heebo' : null,
                fontWeight: FontWeight.bold,
              ),
              displaySmall: TextStyle(
                fontFamily: localeService.isHebrew ? 'Heebo' : null,
                fontWeight: FontWeight.bold,
              ),
              headlineLarge: TextStyle(
                fontFamily: localeService.isHebrew ? 'Heebo' : null,
                fontWeight: FontWeight.bold,
              ),
              headlineMedium: TextStyle(
                fontFamily: localeService.isHebrew ? 'Heebo' : null,
                fontWeight: FontWeight.bold,
              ),
              headlineSmall: TextStyle(
                fontFamily: localeService.isHebrew ? 'Heebo' : null,
                fontWeight: FontWeight.bold,
              ),
              titleLarge: TextStyle(
                fontFamily: localeService.isHebrew ? 'Heebo' : null,
                fontWeight: FontWeight.bold,
              ),
              titleMedium: TextStyle(
                fontFamily: localeService.isHebrew ? 'Heebo' : null,
              ),
              titleSmall: TextStyle(
                fontFamily: localeService.isHebrew ? 'Heebo' : null,
              ),
              bodyLarge: TextStyle(
                fontFamily: localeService.isHebrew ? 'Heebo' : null,
              ),
              bodyMedium: TextStyle(
                fontFamily: localeService.isHebrew ? 'Heebo' : null,
              ),
              bodySmall: TextStyle(
                fontFamily: localeService.isHebrew ? 'Heebo' : null,
              ),
              labelLarge: TextStyle(
                fontFamily: localeService.isHebrew ? 'Heebo' : null,
                fontWeight: FontWeight.bold,
              ),
            ),
            appBarTheme: AppBarTheme(
              centerTitle: true,
              elevation: 2,
            ),
          ),
          locale: localeService.currentLocale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          // Dynamic text direction based on current locale
          builder: (context, child) {
            return Directionality(
              textDirection: localeService.textDirection,
              child: child!,
            );
          },
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/home': (context) => HomeScreen(),
            '/profile': (context) => ProfileScreen(),
            '/contacts': (context) => ContactsScreen(),
            '/settings': (context) => SettingsScreen(),
          },
        );
      },
    );
  }
}
