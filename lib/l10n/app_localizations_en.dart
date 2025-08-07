import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  // App Title
  @override
  String get appTitle => 'Car Safety System';

  @override
  String get appSubtitle => 'Child Safety Alert System';

  // Navigation
  @override
  String get home => 'Home';

  @override
  String get profile => 'Profile';

  @override
  String get contacts => 'Contacts';

  @override
  String get settings => 'Settings';

  // Safety Messages
  @override
  String get safetyCheck => 'Safety Check';

  @override
  String get didYouForgetChild => 'Did you forget a child in the car?';

  @override
  String get checkCarNow => 'Please check the car immediately!';

  @override
  String get criticalSafetyAlert => '⚠️ Critical Safety Alert!';

  @override
  String get childSuspectedInCar => 'Child suspected forgotten in car!';

  @override
  String get returnToCarImmediately => 'Return to check immediately!';

  @override
  String get emergencyAlert => 'Emergency Alert';

  @override
  String get childMayBeForgottenInCar => 'Child may be forgotten in car';

  @override
  String get carLocation => 'Car Location';

  @override
  String get emergencyNumbers => 'Emergency numbers: Police 911, Emergency 911';

  @override
  String get pleaseGoToLocationImmediately => 'Please go to location immediately!';

  // Status Messages
  @override
  String get monitoring => 'Monitoring';

  @override
  String get monitoringActive => 'Monitoring Active';

  @override
  String get monitoringInactive => 'Monitoring Inactive';

  @override
  String get connected => 'Connected';

  @override
  String get disconnected => 'Disconnected';

  @override
  String get safetyConfirmed => '✅ Safety Confirmed';

  @override
  String get returnToCarDetected => 'Return to car detected';

  @override
  String get systemReturnedToNormalMonitoring => 'System returned to normal monitoring';

  // Actions
  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get checkCar => 'Check Car';

  @override
  String get returnedToCar => 'Returned to Car';

  @override
  String get allOk => 'All OK';

  @override
  String get startTrip => 'Start Trip';

  @override
  String get endTrip => 'End Trip';

  // Profile Screen
  @override
  String get userProfile => 'User Profile';

  @override
  String get personalInfo => 'Personal Information';

  @override
  String get name => 'Name';

  @override
  String get phone => 'Phone';

  @override
  String get email => 'Email';

  @override
  String get vehicleInfo => 'Vehicle Information';

  @override
  String get carModel => 'Car Model';

  @override
  String get carColor => 'Car Color';

  @override
  String get licensePlate => 'License Plate';

  @override
  String get children => 'Children';

  @override
  String get addChild => 'Add Child';

  @override
  String get childName => 'Child Name';

  @override
  String get childAge => 'Child Age';

  // Contacts Screen
  @override
  String get emergencyContacts => 'Emergency Contacts';

  @override
  String get language => 'Language';

  // Onboarding strings
  @override
  String get onboardingWelcomeTitle => 'Welcome to Car Safety System';

  @override
  String get onboardingWelcomeDescription => 'Our system helps prevent children from being forgotten in cars using advanced technology';

  @override
  String get onboardingDetectionTitle => 'Automatic Detection';

  @override
  String get onboardingDetectionDescription => 'The system automatically detects when you exit the car and checks if someone remains inside';

  @override
  String get onboardingAlertsTitle => 'Smart Alerts';

  @override
  String get onboardingAlertsDescription => 'In case of suspected child forgotten, the system sends escalating alerts and can notify emergency contacts';

  @override
  String get onboardingSetupTitle => 'System Setup';

  @override
  String get onboardingSetupDescription => 'Now we will configure the system and add emergency contacts';

  @override
  String get previous => 'Previous';

  @override
  String get next => 'Next';

  @override
  String get start => 'Start';

  // Additional missing methods
  @override
  String get addContact => 'Add Contact';

  @override
  String get contactName => 'Contact Name';

  @override
  String get contactPhone => 'Contact Phone';

  @override
  String get priority => 'Priority';

  @override
  String get high => 'High';

  @override
  String get medium => 'Medium';

  @override
  String get low => 'Low';

  @override
  String get selectFromContacts => 'Select from Contacts';

  @override
  String get appSettings => 'App Settings';

  @override
  String get hebrew => 'Hebrew';

  @override
  String get english => 'English';

  @override
  String get alerts => 'Alerts';

  @override
  String get enableSoundAlerts => 'Enable Sound Alerts';

  @override
  String get enableVibration => 'Enable Vibration';

  @override
  String get sensitivity => 'Sensitivity';

  @override
  String get normal => 'Normal';

  @override
  String get strict => 'Strict';

  @override
  String get custom => 'Custom';

  @override
  String get distance => 'Distance';

  @override
  String get maxDistanceFromCar => 'Maximum Distance from Car';

  @override
  String get meters => 'meters';

  @override
  String get timeouts => 'Timeouts';

  @override
  String get initialAlertTimeout => 'Initial Alert Timeout';

  @override
  String get secondaryAlertTimeout => 'Secondary Alert Timeout';

  @override
  String get seconds => 'seconds';

  @override
  String get permissions => 'Permissions';

  @override
  String get locationPermission => 'Location Permission';

  @override
  String get bluetoothPermission => 'Bluetooth Permission';

  @override
  String get contactsPermission => 'Contacts Permission';

  @override
  String get notificationsPermission => 'Notifications Permission';

  @override
  String get granted => 'Granted';

  @override
  String get denied => 'Denied';

  @override
  String get requestPermission => 'Request Permission';

  @override
  String get error => 'Error';

  @override
  String get noInternetConnection => 'No Internet Connection';

  @override
  String get locationServiceDisabled => 'Location Service Disabled';

  @override
  String get bluetoothDisabled => 'Bluetooth Disabled';

  @override
  String get permissionDenied => 'Permission Denied';

  @override
  String get unknownError => 'Unknown Error';

  @override
  String get bluetoothService => 'Bluetooth Service';

  @override
  String get scanningForDevices => 'Scanning for Devices';

  @override
  String get connectingToDevice => 'Connecting to Device';

  @override
  String get connectedToDevice => 'Connected to Device';

  @override
  String get disconnectedFromDevice => 'Disconnected from Device';

  @override
  String get bluetoothPermissionRequired => 'Bluetooth Permission Required';

  @override
  String get locationService => 'Location Service';

  @override
  String get parkingDetected => 'Parking Detected';

  @override
  String get currentDistanceFromCar => 'Current Distance from Car';

  @override
  String get maximum => 'Maximum';

  @override
  String get defined => 'defined';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get unknown => 'Unknown';

  @override
  String get loading => 'Loading...';

  @override
  String get done => 'Done';

  @override
  String get back => 'Back';

  @override
  String get skip => 'Skip';

  @override
  String get retry => 'Retry';

  @override
  String get close => 'Close';

  @override
  String get manualAction => 'Manual Action Required';

  @override
  String get pleaseCallNumber => 'Please call';

  // Home Screen
  @override
  String get stopMonitoring => 'Stop Monitoring';

  @override
  String get startMonitoring => 'Start Monitoring';

  @override
  String get systemInfo => 'System Information';

  @override
  String get systemDescription => 'The system monitors your movement and detects situations where you may have forgotten a child in the car. When a risk situation is detected, an alert will be sent to your phone.';

  // Profile Screen
  @override
  String get profileDetails => 'Profile Details';

  @override
  String get configureProfile => 'Configure your profile and your vehicle';

  @override
  String get fullName => 'Full Name';

  @override
  String get enterName => 'Please enter name';

  @override
  String get vehicleDetails => 'Vehicle Details';

  @override
  String get enterCarModel => 'Please enter car model';

  @override
  String get enterCarColor => 'Please enter car color';

  @override
  String get licenseNumber => 'License Number';

  @override
  String get enterLicenseNumber => 'Please enter license number';

  @override
  String get profileType => 'Profile Type';

  @override
  String get normalProfile => 'Normal';

  @override
  String get standardAlerts => 'Standard alerts';

  @override
  String get strictProfile => 'Strict';

  @override
  String get fasterAlerts => 'Faster alerts, more contacts';

  @override
  String get customProfile => 'Custom';

  @override
  String get customSettings => 'Custom Settings';

  @override
  String get customSettingsDescription => 'Additional settings will be added in the next version';

  @override
  String get childProfiles => 'Child Profiles';

  @override
  String get addChildProfile => 'Add Child Profile';

  @override
  String get improveSystemAccuracy => 'Add details about children riding in the car to improve system accuracy';

  @override
  String get noChildProfiles => 'No child profiles. Click + to add';

  @override
  String get age => 'Age';

  @override
  String get enterAge => 'Age';

  @override
  String get saveProfile => 'Save Profile';

  @override
  String get profileSavedSuccessfully => 'Profile saved successfully';

  @override
  String get addChildProfileTitle => 'Add Child Profile';

  // Contacts Screen
  @override
  String get checkPermissions => 'Check permissions';

  @override
  String get loadSavedContacts => 'Load saved contacts';

  @override
  String get loadDeviceContacts => 'Load device contacts if permission granted';

  @override
  String get contactsLoadError => 'Error loading contacts';

  @override
  String get contactsSavedSuccessfully => 'Contacts saved successfully';

  @override
  String get addContactManually => 'Add Contact';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get relationship => 'Relationship';

  @override
  String get relationshipHint => 'Relationship (parent, spouse, etc.)';

  @override
  String get selectContact => 'Select Contact';

  @override
  String get noPhoneNumber => 'No phone number';

  @override
  String get contactHasNoPhone => 'This contact has no phone number';

  @override
  String get setRelationship => 'Set Relationship';

  @override
  String get adding => 'Adding';

  @override
  String get reorderPriority => 'Update priority order';

  @override
  String get dragToReorder => 'Drag contacts to change their priority order';

  @override
  String get noEmergencyContacts => 'No emergency contacts';

  @override
  String get addEmergencyContacts => 'Add contacts who will receive alerts in emergencies';

  @override
  String get relation => 'Relation';

  @override
  String get addContactTooltip => 'Add contact manually';

  // Settings Screen Additional
  @override
  String get aboutApp => 'About App';

  @override
  String get version => 'Version';

  @override
  String get developer => 'Developer';

  @override
  String get contact => 'Contact';

  @override
  String get additionalSettings => 'Additional Settings';
  
  // Settings Screen Complete
  @override
  String get generalSettings => 'General Settings';

  @override
  String get startOnBoot => 'Start on Device Boot';

  @override
  String get startOnBootDescription => 'Automatically start the app when the phone is turned on';

  @override
  String get alertSettings => 'Alert Settings';

  @override
  String get sensorSettings => 'Sensor Settings';

  @override
  String get useBluetooth => 'Use Bluetooth';

  @override
  String get useBluetoothDescription => 'Use Bluetooth connection to car to detect exit from vehicle';

  @override
  String get useGPS => 'Use GPS';

  @override
  String get useGPSDescription => 'Use GPS location to detect vehicle and user movement';

  @override
  String get sensorRequirement => 'At least one sensor (Bluetooth or GPS) must be active for the system to work properly';

  @override
  String get ensurePermissions => 'Ensure all required permissions are enabled';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get readPrivacyPolicy => 'Read the app\'s privacy policy';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get contactSupportDescription => 'Contact the development team';

  @override
  String get permissionsStatus => 'Permissions Status';

  @override
  String get location => 'Location';

  @override
  String get bluetooth => 'Bluetooth';

  @override
  String get notifications => 'Notifications';

  @override
  String get sms => 'Send SMS';

  @override
  String get distanceFromCar => 'Distance from car to trigger alert';

  @override
  String get distanceFromCarDescription => 'Minimum distance from car that will trigger an alert';

  @override
  String get seconds60Plus => 'seconds';

  @override
  String get minutes => 'minutes';

  @override
  String get appVersion => 'App Version';

  @override
  String get settingsSaved => 'Settings saved successfully';

  @override
  String get languageChangeImmediate => 'Language change will be applied to the entire app immediately';

  @override
  String get privacyPolicyContent => 'Privacy Policy for Child Safety Car Alert App:\n\n1. The app collects location data only to identify the car and user location.\n2. Location data is stored on the device only and is not sent to external servers.\n3. Configured contacts are used only for sending emergency alerts.\n4. The app does not collect personal information other than what is manually entered.\n5. In case of emergency, location details will be sent only to the configured contacts.\n\nWe are committed to protecting our users\' privacy and operate in accordance with all relevant privacy protection laws.';

  @override
  String get contactDetails => 'You can contact the support team using the following methods:';

  @override
  String get supportEmail => 'support@carsafety.app';

  @override
  String get supportPhone => 'Support phone: +972-50-123-4567';

  // Permission Dialog Strings
  @override
  String get backgroundLocationPermission => 'Background Location Permission';

  @override
  String get backgroundLocationDescription => 'The app needs to track the vehicle\'s location even when the app is not active. This permission is essential to detect when you are moving away from the car.';

  @override
  String get notificationPermission => 'Notification Permission';

  @override
  String get notificationPermissionDescription => 'The app uses notifications to alert you in case of detecting a risk situation. This permission is essential for the system\'s operation.';

  @override
  String get smsPermission => 'SMS Permission';

  @override
  String get smsPermissionDescription => 'The app sends SMS messages to contacts in emergency cases. This permission is essential for sending emergency alerts.';

  @override
  String get autoStartPermission => 'Auto Start Permission';

  @override
  String get autoStartPermissionInstructions => 'For the app to start automatically when the device boots, you need to enable this in device settings:\n\n1. Open device settings\n2. Search for "Auto start" or "Background apps"\n3. Find the "Car Safety" app\n4. Enable the "Auto start" option';

  @override
  String get understood => 'Understood';
}
