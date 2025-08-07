import 'app_localizations.dart';

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  // App Title
  @override
  String get appTitle => 'מערכת בטיחות לרכב';

  @override
  String get appSubtitle => 'מניעת שכחת ילדים ברכב';

  // Navigation
  @override
  String get home => 'בית';

  @override
  String get profile => 'פרופיל';

  @override
  String get contacts => 'אנשי קשר';

  @override
  String get settings => 'הגדרות';

  // Safety Messages
  @override
  String get safetyCheck => 'בדיקת בטיחות';

  @override
  String get didYouForgetChild => 'האם שכחת ילד ברכב?';

  @override
  String get checkCarNow => 'אנא בדוק את הרכב מיד!';

  @override
  String get criticalSafetyAlert => '⚠️ התראת בטיחות חירום!';

  @override
  String get childSuspectedInCar => 'יש חשד שילד נשכח ברכב!';

  @override
  String get returnToCarImmediately => 'חזור מיד לבדוק!';

  @override
  String get emergencyAlert => 'התראת חירום';

  @override
  String get childMayBeForgottenInCar => 'ייתכן שנשכח ילד ברכב';

  @override
  String get carLocation => 'כתובת הרכב';

  @override
  String get emergencyNumbers => 'מספרי חירום: משטרה 100, מד"א 101';

  @override
  String get pleaseGoToLocationImmediately => 'נא לפנות מיד למיקום!';

  // Status Messages
  @override
  String get monitoring => 'ניטור';

  @override
  String get monitoringActive => 'ניטור פעיל';

  @override
  String get monitoringInactive => 'ניטור לא פעיל';

  @override
  String get connected => 'מחובר';

  @override
  String get disconnected => 'מנותק';

  @override
  String get safetyConfirmed => '✅ בטיחות מאושרת';

  @override
  String get returnToCarDetected => 'זוהתה חזרה לרכב';

  @override
  String get systemReturnedToNormalMonitoring => 'המערכת חזרה למצב ניטור רגיל';

  // Actions
  @override
  String get ok => 'אישור';

  @override
  String get cancel => 'ביטול';

  @override
  String get save => 'שמירה';

  @override
  String get delete => 'מחיקה';

  @override
  String get edit => 'עריכה';

  @override
  String get add => 'הוספה';

  @override
  String get checkCar => 'בדוק את הרכב';

  @override
  String get returnedToCar => 'חזרתי לרכב';

  @override
  String get allOk => 'הכל בסדר';

  @override
  String get startTrip => 'התחלת נסיעה';

  @override
  String get endTrip => 'סיום נסיעה';

  // Profile Screen
  @override
  String get userProfile => 'פרופיל משתמש';

  @override
  String get personalInfo => 'מידע אישי';

  @override
  String get name => 'שם';

  @override
  String get phone => 'טלפון';

  @override
  String get email => 'דוא"ל';

  @override
  String get vehicleInfo => 'מידע רכב';

  @override
  String get carModel => 'דגם רכב';

  @override
  String get carColor => 'צבע רכב';

  @override
  String get licensePlate => 'מספר רכב';

  @override
  String get children => 'ילדים';

  @override
  String get addChild => 'הוספת ילד';

  @override
  String get childName => 'שם הילד';

  @override
  String get childAge => 'גיל הילד';

  // Contacts Screen
  @override
  String get emergencyContacts => 'אנשי קשר לחירום';

  @override
  String get language => 'שפה';

  // Onboarding strings
  @override
  String get onboardingWelcomeTitle => 'ברוכים הבאים למערכת בטיחות הרכב';

  @override
  String get onboardingWelcomeDescription => 'המערכת שלנו עוזרת למנוע שכחת ילדים ברכב באמצעות טכנולוגיה מתקדמת';

  @override
  String get onboardingDetectionTitle => 'זיהוי אוטומטי';

  @override
  String get onboardingDetectionDescription => 'המערכת מזהה באופן אוטומטי כאשר אתם יוצאים מהרכב ובודקת אם נשאר מישהו בפנים';

  @override
  String get onboardingAlertsTitle => 'התראות חכמות';

  @override
  String get onboardingAlertsDescription => 'במקרה של חשד לשכחת ילד, המערכת שולחת התראות מדורגות ויכולה להתריע לאנשי קשר';

  @override
  String get onboardingSetupTitle => 'הגדרת המערכת';

  @override
  String get onboardingSetupDescription => 'כעת נגדיר את המערכת ונוסיף אנשי קשר לחירום';

  @override
  String get previous => 'הקודם';

  @override
  String get next => 'הבא';

  @override
  String get start => 'התחל';

  // Additional missing methods
  @override
  String get addContact => 'הוספת איש קשר';

  @override
  String get contactName => 'שם איש הקשר';

  @override
  String get contactPhone => 'טלפון איש הקשר';

  @override
  String get priority => 'עדיפות';

  @override
  String get high => 'גבוהה';

  @override
  String get medium => 'בינונית';

  @override
  String get low => 'נמוכה';

  @override
  String get selectFromContacts => 'בחירה מרשימת אנשי קשר';

  @override
  String get appSettings => 'הגדרות אפליקציה';

  @override
  String get hebrew => 'עברית';

  @override
  String get english => 'אנגלית';

  @override
  String get alerts => 'התראות';

  @override
  String get enableSoundAlerts => 'הפעלת התראות קוליות';

  @override
  String get enableVibration => 'הפעלת רטט';

  @override
  String get sensitivity => 'רגישות';

  @override
  String get normal => 'רגיל';

  @override
  String get strict => 'מחמיר';

  @override
  String get custom => 'מותאם';

  @override
  String get distance => 'מרחק';

  @override
  String get maxDistanceFromCar => 'מרחק מקסימלי מהרכב';

  @override
  String get meters => 'מטרים';

  @override
  String get timeouts => 'זמני המתנה';

  @override
  String get initialAlertTimeout => 'זמן המתנה להתראה ראשונית';

  @override
  String get secondaryAlertTimeout => 'זמן המתנה להתראה משנית';

  @override
  String get seconds => 'שניות';

  @override
  String get permissions => 'הרשאות';

  @override
  String get locationPermission => 'הרשאת מיקום';

  @override
  String get bluetoothPermission => 'הרשאת בלוטות';

  @override
  String get contactsPermission => 'הרשאת אנשי קשר';

  @override
  String get notificationsPermission => 'הרשאת התראות';

  @override
  String get granted => 'ניתנה';

  @override
  String get denied => 'נדחתה';

  @override
  String get requestPermission => 'בקשת הרשאה';

  @override
  String get error => 'שגיאה';

  @override
  String get noInternetConnection => 'אין חיבור לאינטרנט';

  @override
  String get locationServiceDisabled => 'שירותי המיקום מבוטלים';

  @override
  String get bluetoothDisabled => 'הבלוטות מבוטל';

  @override
  String get permissionDenied => 'הרשאה נדחתה';

  @override
  String get unknownError => 'שגיאה לא ידועה';

  @override
  String get bluetoothService => 'שירות בלוטות';

  @override
  String get scanningForDevices => 'סריקת מכשירים';

  @override
  String get connectingToDevice => 'מתחבר למכשיר';

  @override
  String get connectedToDevice => 'מחובר למכשיר';

  @override
  String get disconnectedFromDevice => 'מנותק ממכשיר';

  @override
  String get bluetoothPermissionRequired => 'נדרשת הרשאת בלוטות';

  @override
  String get locationService => 'שירות מיקום';

  @override
  String get parkingDetected => 'זוהתה חניה';

  @override
  String get currentDistanceFromCar => 'מרחק נוכחי מהרכב';

  @override
  String get maximum => 'מקסימום';

  @override
  String get defined => 'מוגדר';

  @override
  String get yes => 'כן';

  @override
  String get no => 'לא';

  @override
  String get unknown => 'לא ידוע';

  @override
  String get loading => 'טוען...';

  @override
  String get done => 'סיום';

  @override
  String get back => 'חזרה';

  @override
  String get skip => 'דלג';

  @override
  String get retry => 'נסה שוב';

  @override
  String get close => 'סגירה';

  @override
  String get manualAction => 'דרושה פעולה ידנית';

  @override
  String get pleaseCallNumber => 'אנא התקשר ל';

  // Home Screen
  @override
  String get stopMonitoring => 'הפסק ניטור';

  @override
  String get startMonitoring => 'התחל ניטור';

  @override
  String get systemInfo => 'מידע על המערכת';

  @override
  String get systemDescription => 'המערכת מנטרת את תנועתך ומזהה מצבים שבהם ייתכן כי שכחת ילד ברכב. בעת זיהוי מצב סיכון, תישלח התראה לטלפון שלך.';

  // Profile Screen
  @override
  String get profileDetails => 'פרטי פרופיל';

  @override
  String get configureProfile => 'הגדר את הפרופיל שלך ואת רכבך';

  @override
  String get fullName => 'שם מלא';

  @override
  String get enterName => 'נא להזין שם';

  @override
  String get vehicleDetails => 'פרטי רכב';

  @override
  String get enterCarModel => 'נא להזין דגם רכב';

  @override
  String get enterCarColor => 'נא להזין צבע רכב';

  @override
  String get licenseNumber => 'מספר רישוי';

  @override
  String get enterLicenseNumber => 'נא להזין מספר רישוי';

  @override
  String get profileType => 'סוג פרופיל';

  @override
  String get normalProfile => 'רגיל';

  @override
  String get standardAlerts => 'התראות סטנדרטיות';

  @override
  String get strictProfile => 'מחמיר';

  @override
  String get fasterAlerts => 'התראות מהירות יותר, יותר אנשי קשר';

  @override
  String get customProfile => 'מותאם אישית';

  @override
  String get customSettings => 'הגדרות מותאמות אישית';

  @override
  String get customSettingsDescription => 'הגדרות נוספות יתווספו בגרסה הבאה';

  @override
  String get childProfiles => 'פרופילי ילדים';

  @override
  String get addChildProfile => 'הוסף פרופיל ילד';

  @override
  String get improveSystemAccuracy => 'הוסף פרטים על הילדים שנוסעים ברכב כדי לשפר את דיוק המערכת';

  @override
  String get noChildProfiles => 'אין פרופילי ילדים. לחץ על + להוספה';

  @override
  String get age => 'גיל';

  @override
  String get enterAge => 'גיל';

  @override
  String get saveProfile => 'שמור פרופיל';

  @override
  String get profileSavedSuccessfully => 'הפרופיל נשמר בהצלחה';

  @override
  String get addChildProfileTitle => 'הוסף פרופיל ילד';

  // Contacts Screen
  @override
  String get checkPermissions => 'בדוק הרשאות';

  @override
  String get loadSavedContacts => 'טען אנשי קשר שמורים';

  @override
  String get loadDeviceContacts => 'טען אנשי קשר מהמכשיר אם יש הרשאה';

  @override
  String get contactsLoadError => 'שגיאה בטעינת אנשי קשר';

  @override
  String get contactsSavedSuccessfully => 'אנשי קשר נשמרו בהצלחה';

  @override
  String get addContactManually => 'הוסף איש קשר';

  @override
  String get phoneNumber => 'מספר טלפון';

  @override
  String get relationship => 'קרבה';

  @override
  String get relationshipHint => 'קרבה (הורה, בן/בת זוג, וכו\')';

  @override
  String get selectContact => 'בחר איש קשר';

  @override
  String get noPhoneNumber => 'אין מספר טלפון';

  @override
  String get contactHasNoPhone => 'לאיש קשר זה אין מספר טלפון';

  @override
  String get setRelationship => 'הגדר קרבה';

  @override
  String get adding => 'הוספת';

  @override
  String get reorderPriority => 'עדכון סדר עדיפויות';

  @override
  String get dragToReorder => 'גרור את אנשי הקשר כדי לשנות את סדר העדיפות שלהם';

  @override
  String get noEmergencyContacts => 'אין אנשי קשר לחירום';

  @override
  String get addEmergencyContacts => 'הוסף אנשי קשר שיקבלו התראה במקרה חירום';

  @override
  String get relation => 'קרבה';

  @override
  String get addContactTooltip => 'הוסף איש קשר ידנית';

  // Settings Screen Additional
  @override
  String get aboutApp => 'אודות האפליקציה';

  @override
  String get version => 'גרסה';

  @override
  String get developer => 'מפתח';

  @override
  String get contact => 'יצירת קשר';

  @override
  String get additionalSettings => 'הגדרות נוספות';
  
  // Settings Screen Complete
  @override
  String get generalSettings => 'הגדרות כלליות';

  @override
  String get startOnBoot => 'הפעל בעת הדלקת המכשיר';

  @override
  String get startOnBootDescription => 'הפעל את האפליקציה אוטומטית בעת הדלקת הטלפון';

  @override
  String get alertSettings => 'הגדרות התראות';

  @override
  String get sensorSettings => 'הגדרות חיישנים';

  @override
  String get useBluetooth => 'השתמש ב-Bluetooth';

  @override
  String get useBluetoothDescription => 'השתמש בחיבור Bluetooth לרכב לזיהוי יציאה מהרכב';

  @override
  String get useGPS => 'השתמש ב-GPS';

  @override
  String get useGPSDescription => 'השתמש במיקום GPS לזיהוי תנועת הרכב והמשתמש';

  @override
  String get sensorRequirement => 'לפחות אחד מהחיישנים (Bluetooth או GPS) חייב להיות פעיל כדי שהמערכת תעבוד כראוי';

  @override
  String get ensurePermissions => 'ודא שכל ההרשאות הנדרשות מאופשרות';

  @override
  String get privacyPolicy => 'מדיניות פריטיות';

  @override
  String get readPrivacyPolicy => 'קרא את מדיניות הפריטיות של האפליקציה';

  @override
  String get contactSupport => 'צור קשר';

  @override
  String get contactSupportDescription => 'צור קשר עם צוות הפיתוח';

  @override
  String get permissionsStatus => 'סטטוס הרשאות';

  @override
  String get location => 'מיקום';

  @override
  String get bluetooth => 'Bluetooth';

  @override
  String get notifications => 'התראות';

  @override
  String get sms => 'שליחת SMS';

  @override
  String get distanceFromCar => 'מרחק מהרכב להפעלת התראה';

  @override
  String get distanceFromCarDescription => 'המרחק המינימלי מהרכב שיגרום להפעלת התראה';

  @override
  String get seconds60Plus => 'שניות';

  @override
  String get minutes => 'דקות';

  @override
  String get appVersion => 'גרסת אפליקציה';

  @override
  String get settingsSaved => 'ההגדרות נשמרו בהצלחה';

  @override
  String get languageChangeImmediate => 'שינוי השפה יחול על כל האפליקציה מיידית';

  @override
  String get privacyPolicyContent => 'מדיניות הפריטיות של אפליקציית מניעת שכחת ילדים ברכב:\n\n1. האפליקציה אוספת נתוני מיקום רק כדי לזהות את מיקום הרכב והמשתמש.\n2. נתוני המיקום נשמרים במכשיר בלבד ואינם נשלחים לשרתים חיצוניים.\n3. אנשי הקשר שהוגדרו משמשים רק לשליחת התראות חירום.\n4. האפליקציה אינה אוספת מידע אישי מלבד זה שהוזן ידנית.\n5. במקרה חירום, פרטי המיקום יישלחו לאנשי הקשר שהוגדרו בלבד.\n\nאנו מחויבים להגנה על פרטיות המשתמשים שלנו ופועלים בהתאם לכל חוקי הגנת הפריטיות הרלוונטיים.';

  @override
  String get contactDetails => 'ניתן ליצור קשר עם צוות התמיכה באמצעים הבאים:';

  @override
  String get supportEmail => 'support@carsafety.app';

  @override
  String get supportPhone => 'טלפון תמיכה: +972-50-123-4567';

  // Permission Dialog Strings
  @override
  String get backgroundLocationPermission => 'הרשאת מיקום ברקע';

  @override
  String get backgroundLocationDescription => 'האפליקציה צריכה לעקוב אחר מיקום הרכב גם כאשר האפליקציה לא פעילה. הרשאה זו חיונית כדי לזהות מתי אתה מתרחק מהרכב.';

  @override
  String get notificationPermission => 'הרשאת התראות';

  @override
  String get notificationPermissionDescription => 'האפליקציה משתמשת בהתראות כדי ליידע אותך במקרה של זיהוי מצב סיכון. הרשאה זו חיונית לפעולת המערכת.';

  @override
  String get smsPermission => 'הרשאת שליחת SMS';

  @override
  String get smsPermissionDescription => 'האפליקציה שולחת הודעות SMS לאנשי קשר במקרה חירום. הרשאה זו חיונית לשליחת התראות חירום.';

  @override
  String get autoStartPermission => 'הפעלה אוטומטית';

  @override
  String get autoStartPermissionInstructions => 'כדי שהאפליקציה תופעל אוטומטית בעת הפעלת המכשיר, יש לאפשר זאת בהגדרות המכשיר:\n\n1. פתח את הגדרות המכשיר\n2. חפש "הפעלה אוטומטית" או "אפליקציות ברקע"\n3. מצא את אפליקציית "מניעת שכחת ילדים ברכב"\n4. הפעל את האפשרות "הפעלה אוטומטית"';

  @override
  String get understood => 'הבנתי';
}
