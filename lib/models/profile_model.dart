class UserProfile {
  String name;
  String carModel;
  String carColor;
  String licensePlate;
  String profileType; // 'רגיל', 'מחמיר', 'מותאם אישית'
  List<ChildProfile> childProfiles;
  
  // הגדרות נוספות לפרופיל מותאם אישית
  int initialAlertTimeoutSeconds;
  int secondaryAlertTimeoutSeconds;
  int maxDistanceFromCar; // במטרים
  
  UserProfile({
    required this.name,
    required this.carModel,
    required this.carColor,
    required this.licensePlate,
    required this.profileType,
    required this.childProfiles,
    this.initialAlertTimeoutSeconds = 30, // ברירת מחדל
    this.secondaryAlertTimeoutSeconds = 60, // ברירת מחדל
    this.maxDistanceFromCar = 50, // ברירת מחדל
  });
  
  // המרה למפת JSON לאחסון
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'carModel': carModel,
      'carColor': carColor,
      'licensePlate': licensePlate,
      'profileType': profileType,
      'childProfiles': childProfiles.map((child) => child.toJson()).toList(),
      'initialAlertTimeoutSeconds': initialAlertTimeoutSeconds,
      'secondaryAlertTimeoutSeconds': secondaryAlertTimeoutSeconds,
      'maxDistanceFromCar': maxDistanceFromCar,
    };
  }
  
  // יצירת אובייקט ממפת JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? '',
      carModel: json['carModel'] ?? '',
      carColor: json['carColor'] ?? '',
      licensePlate: json['licensePlate'] ?? '',
      profileType: json['profileType'] ?? 'רגיל',
      childProfiles: (json['childProfiles'] as List? ?? [])
          .map((child) => ChildProfile.fromJson(child))
          .toList(),
      initialAlertTimeoutSeconds: json['initialAlertTimeoutSeconds'] ?? 30,
      secondaryAlertTimeoutSeconds: json['secondaryAlertTimeoutSeconds'] ?? 60,
      maxDistanceFromCar: json['maxDistanceFromCar'] ?? 50,
    );
  }
}

class ChildProfile {
  String name;
  int age;
  
  ChildProfile({
    required this.name,
    required this.age,
  });
  
  // המרה למפת JSON לאחסון
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
    };
  }
  
  // יצירת אובייקט ממפת JSON
  factory ChildProfile.fromJson(Map<String, dynamic> json) {
    return ChildProfile(
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
    );
  }
}
