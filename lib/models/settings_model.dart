class AppSettings {
  bool startOnBoot;
  bool useBluetooth;
  bool useGPS;
  bool enableSoundAlerts;
  bool enableVibration;
  int initialAlertTimeoutSeconds;
  int secondaryAlertTimeoutSeconds;
  int maxDistanceFromCar; // במטרים
  
  AppSettings({
    this.startOnBoot = false,
    this.useBluetooth = true,
    this.useGPS = true,
    this.enableSoundAlerts = true,
    this.enableVibration = true,
    this.initialAlertTimeoutSeconds = 30,
    this.secondaryAlertTimeoutSeconds = 60,
    this.maxDistanceFromCar = 50,
  });
  
  // המרה למפת JSON לאחסון
  Map<String, dynamic> toJson() {
    return {
      'startOnBoot': startOnBoot,
      'useBluetooth': useBluetooth,
      'useGPS': useGPS,
      'enableSoundAlerts': enableSoundAlerts,
      'enableVibration': enableVibration,
      'initialAlertTimeoutSeconds': initialAlertTimeoutSeconds,
      'secondaryAlertTimeoutSeconds': secondaryAlertTimeoutSeconds,
      'maxDistanceFromCar': maxDistanceFromCar,
    };
  }
  
  // יצירת אובייקט ממפת JSON
  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      startOnBoot: json['startOnBoot'] ?? false,
      useBluetooth: json['useBluetooth'] ?? true,
      useGPS: json['useGPS'] ?? true,
      enableSoundAlerts: json['enableSoundAlerts'] ?? true,
      enableVibration: json['enableVibration'] ?? true,
      initialAlertTimeoutSeconds: json['initialAlertTimeoutSeconds'] ?? 30,
      secondaryAlertTimeoutSeconds: json['secondaryAlertTimeoutSeconds'] ?? 60,
      maxDistanceFromCar: json['maxDistanceFromCar'] ?? 50,
    );
  }
}
