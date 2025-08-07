import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

import 'app_localizations_he.dart';
import 'app_localizations_en.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('he'),
    Locale('en'),
  ];

  // App Title
  String get appTitle;
  String get appSubtitle;

  // Navigation
  String get home;
  String get profile;
  String get contacts;
  String get settings;

  // Safety Messages
  String get safetyCheck;
  String get didYouForgetChild;
  String get checkCarNow;
  String get criticalSafetyAlert;
  String get childSuspectedInCar;
  String get returnToCarImmediately;
  String get emergencyAlert;
  String get childMayBeForgottenInCar;
  String get carLocation;
  String get emergencyNumbers;
  String get pleaseGoToLocationImmediately;

  // Status Messages
  String get monitoring;
  String get monitoringActive;
  String get monitoringInactive;
  String get connected;
  String get disconnected;
  String get safetyConfirmed;
  String get returnToCarDetected;
  String get systemReturnedToNormalMonitoring;

  // Actions
  String get ok;
  String get cancel;
  String get save;
  String get delete;
  String get edit;
  String get add;
  String get checkCar;
  String get returnedToCar;
  String get allOk;
  String get startTrip;
  String get endTrip;

  // Profile Screen
  String get userProfile;
  String get personalInfo;
  String get name;
  String get phone;
  String get email;
  String get vehicleInfo;
  String get carModel;
  String get carColor;
  String get licensePlate;
  String get children;
  String get addChild;
  String get childName;
  String get childAge;

  // Contacts Screen
  String get emergencyContacts;
  String get addContact;
  String get contactName;
  String get contactPhone;
  String get priority;
  String get high;
  String get medium;
  String get low;
  String get selectFromContacts;

  // Settings Screen
  String get appSettings;
  String get language;
  String get hebrew;
  String get english;
  String get alerts;
  String get enableSoundAlerts;
  String get enableVibration;
  String get sensitivity;
  String get normal;
  String get strict;
  String get custom;
  String get distance;
  String get maxDistanceFromCar;
  String get meters;
  String get timeouts;
  String get initialAlertTimeout;
  String get secondaryAlertTimeout;
  String get seconds;
  String get permissions;
  String get locationPermission;
  String get bluetoothPermission;
  String get contactsPermission;
  String get notificationsPermission;
  String get granted;
  String get denied;
  String get requestPermission;

  // Error Messages
  String get error;
  String get noInternetConnection;
  String get locationServiceDisabled;
  String get bluetoothDisabled;
  String get permissionDenied;
  String get unknownError;

  // Bluetooth
  String get bluetoothService;
  String get scanningForDevices;
  String get connectingToDevice;
  String get connectedToDevice;
  String get disconnectedFromDevice;
  String get bluetoothPermissionRequired;

  // Location
  String get locationService;
  String get parkingDetected;
  String get currentDistanceFromCar;
  String get maximum;
  String get defined;

  // General
  String get yes;
  String get no;
  String get unknown;
  String get loading;
  String get done;
  String get next;
  String get back;
  String get skip;
  String get retry;
  String get close;
  String get manualAction;
  String get pleaseCallNumber;

  // Onboarding strings
  String get onboardingWelcomeTitle;
  String get onboardingWelcomeDescription;
  String get onboardingDetectionTitle;
  String get onboardingDetectionDescription;
  String get onboardingAlertsTitle;
  String get onboardingAlertsDescription;
  String get onboardingSetupTitle;
  String get onboardingSetupDescription;
  String get previous;
  String get start;

  // Home Screen
  String get stopMonitoring;
  String get startMonitoring;
  String get systemInfo;
  String get systemDescription;

  // Profile Screen
  String get profileDetails;
  String get configureProfile;
  String get fullName;
  String get enterName;
  String get vehicleDetails;
  String get enterCarModel;
  String get enterCarColor;
  String get licenseNumber;
  String get enterLicenseNumber;
  String get profileType;
  String get normalProfile;
  String get standardAlerts;
  String get strictProfile;
  String get fasterAlerts;
  String get customProfile;
  String get customSettings;
  String get customSettingsDescription;
  String get childProfiles;
  String get addChildProfile;
  String get improveSystemAccuracy;
  String get noChildProfiles;
  String get age;
  String get enterAge;
  String get saveProfile;
  String get profileSavedSuccessfully;
  String get addChildProfileTitle;

  // Contacts Screen
  String get checkPermissions;
  String get loadSavedContacts;
  String get loadDeviceContacts;
  String get contactsLoadError;
  String get contactsSavedSuccessfully;
  String get addContactManually;
  String get phoneNumber;
  String get relationship;
  String get relationshipHint;
  String get selectContact;
  String get noPhoneNumber;
  String get contactHasNoPhone;
  String get setRelationship;
  String get adding;
  String get reorderPriority;
  String get dragToReorder;
  String get noEmergencyContacts;
  String get addEmergencyContacts;
  String get relation;
  String get addContactTooltip;

  // Settings Screen Additional
  String get aboutApp;
  String get version;
  String get developer;
  String get contact;
  String get additionalSettings;
  
  // Settings Screen Complete
  String get generalSettings;
  String get startOnBoot;
  String get startOnBootDescription;
  String get alertSettings;
  String get sensorSettings;
  String get useBluetooth;
  String get useBluetoothDescription;
  String get useGPS;
  String get useGPSDescription;
  String get sensorRequirement;
  String get ensurePermissions;
  String get privacyPolicy;
  String get readPrivacyPolicy;
  String get contactSupport;
  String get contactSupportDescription;
  String get permissionsStatus;
  String get location;
  String get bluetooth;
  String get notifications;
  String get sms;
  String get distanceFromCar;
  String get distanceFromCarDescription;
  String get seconds60Plus;
  String get minutes;
  String get appVersion;
  String get settingsSaved;
  String get languageChangeImmediate;
  String get privacyPolicyContent;
  String get contactDetails;
  String get supportEmail;
  String get supportPhone;

  // Permission Dialog Strings
  String get backgroundLocationPermission;
  String get backgroundLocationDescription;
  String get notificationPermission;
  String get notificationPermissionDescription;
  String get smsPermission;
  String get smsPermissionDescription;
  String get autoStartPermission;
  String get autoStartPermissionInstructions;
  String get understood;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'he'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'he': return AppLocalizationsHe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue on GitHub with a '
    'reproducible sample app and the gen-l10n configuration that was used.'
  );
}
