class UserModel {
  final String id;
  final String name;
  final String? email;
  final String? phoneNumber;
  final DateTime createdAt;
  final DateTime? lastActiveAt;
  final UserPreferences preferences;
  
  UserModel({
    String? id,
    required this.name,
    this.email,
    this.phoneNumber,
    DateTime? createdAt,
    this.lastActiveAt,
    UserPreferences? preferences,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
       createdAt = createdAt ?? DateTime.now(),
       preferences = preferences ?? UserPreferences();
  
  // המרה למפת JSON לאחסון
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt.toIso8601String(),
      'lastActiveAt': lastActiveAt?.toIso8601String(),
      'preferences': preferences.toJson(),
    };
  }
  
  // יצירת אובייקט ממפת JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      createdAt: DateTime.parse(json['createdAt']),
      lastActiveAt: json['lastActiveAt'] != null 
          ? DateTime.parse(json['lastActiveAt']) 
          : null,
      preferences: json['preferences'] != null 
          ? UserPreferences.fromJson(json['preferences'])
          : UserPreferences(),
    );
  }
  
  // יצירת עותק עם שינויים
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    DateTime? createdAt,
    DateTime? lastActiveAt,
    UserPreferences? preferences,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      preferences: preferences ?? this.preferences,
    );
  }
}

class UserPreferences {
  final bool enableNotifications;
  final bool enableSmsAlerts;
  final int alertDelayMinutes;
  final bool enableBluetoothDetection;
  final bool enableLocationTracking;
  final String language;
  
  UserPreferences({
    this.enableNotifications = true,
    this.enableSmsAlerts = true,
    this.alertDelayMinutes = 2,
    this.enableBluetoothDetection = true,
    this.enableLocationTracking = true,
    this.language = 'he',
  });
  
  Map<String, dynamic> toJson() {
    return {
      'enableNotifications': enableNotifications,
      'enableSmsAlerts': enableSmsAlerts,
      'alertDelayMinutes': alertDelayMinutes,
      'enableBluetoothDetection': enableBluetoothDetection,
      'enableLocationTracking': enableLocationTracking,
      'language': language,
    };
  }
  
  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      enableNotifications: json['enableNotifications'] ?? true,
      enableSmsAlerts: json['enableSmsAlerts'] ?? true,
      alertDelayMinutes: json['alertDelayMinutes'] ?? 2,
      enableBluetoothDetection: json['enableBluetoothDetection'] ?? true,
      enableLocationTracking: json['enableLocationTracking'] ?? true,
      language: json['language'] ?? 'he',
    );
  }
  
  UserPreferences copyWith({
    bool? enableNotifications,
    bool? enableSmsAlerts,
    int? alertDelayMinutes,
    bool? enableBluetoothDetection,
    bool? enableLocationTracking,
    String? language,
  }) {
    return UserPreferences(
      enableNotifications: enableNotifications ?? this.enableNotifications,
      enableSmsAlerts: enableSmsAlerts ?? this.enableSmsAlerts,
      alertDelayMinutes: alertDelayMinutes ?? this.alertDelayMinutes,
      enableBluetoothDetection: enableBluetoothDetection ?? this.enableBluetoothDetection,
      enableLocationTracking: enableLocationTracking ?? this.enableLocationTracking,
      language: language ?? this.language,
    );
  }
}
