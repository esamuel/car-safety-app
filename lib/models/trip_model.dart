import 'package:geolocator/geolocator.dart';

class Trip {
  final String id;
  final DateTime startTime;
  final Position? startLocation;
  DateTime? endTime;
  Position? endLocation;
  Position? parkingLocation;
  bool hasChildDetected;
  bool hasAlertSent;
  bool hasEmergencyAlertSent;
  
  Trip({
    String? id,
    required this.startTime,
    this.startLocation,
    this.endTime,
    this.endLocation,
    this.parkingLocation,
    this.hasChildDetected = false,
    this.hasAlertSent = false,
    this.hasEmergencyAlertSent = false,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();
  
  // המרה למפת JSON לאחסון
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'startLatitude': startLocation?.latitude,
      'startLongitude': startLocation?.longitude,
      'endTime': endTime?.toIso8601String(),
      'endLatitude': endLocation?.latitude,
      'endLongitude': endLocation?.longitude,
      'parkingLatitude': parkingLocation?.latitude,
      'parkingLongitude': parkingLocation?.longitude,
      'hasChildDetected': hasChildDetected,
      'hasAlertSent': hasAlertSent,
      'hasEmergencyAlertSent': hasEmergencyAlertSent,
    };
  }
  
  // יצירת אובייקט ממפת JSON
  factory Trip.fromJson(Map<String, dynamic> json) {
    Position? startPos;
    if (json['startLatitude'] != null && json['startLongitude'] != null) {
      startPos = Position(
        latitude: json['startLatitude'],
        longitude: json['startLongitude'],
        timestamp: DateTime.parse(json['startTime']),
        accuracy: 0,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0,
      );
    }
    
    Position? endPos;
    if (json['endLatitude'] != null && json['endLongitude'] != null) {
      endPos = Position(
        latitude: json['endLatitude'],
        longitude: json['endLongitude'],
        timestamp: json['endTime'] != null 
            ? DateTime.parse(json['endTime']) 
            : DateTime.now(),
        accuracy: 0,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0,
      );
    }
    
    Position? parkingPos;
    if (json['parkingLatitude'] != null && json['parkingLongitude'] != null) {
      parkingPos = Position(
        latitude: json['parkingLatitude'],
        longitude: json['parkingLongitude'],
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0,
      );
    }
    
    return Trip(
      id: json['id'],
      startTime: DateTime.parse(json['startTime']),
      startLocation: startPos,
      endTime: json['endTime'] != null 
          ? DateTime.parse(json['endTime']) 
          : null,
      endLocation: endPos,
      parkingLocation: parkingPos,
      hasChildDetected: json['hasChildDetected'] ?? false,
      hasAlertSent: json['hasAlertSent'] ?? false,
      hasEmergencyAlertSent: json['hasEmergencyAlertSent'] ?? false,
    );
  }
}
