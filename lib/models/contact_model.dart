class Contact {
  final String id;
  final String name;
  final String phoneNumber;
  final String? email;
  final String relation;
  final ContactType type;
  final bool isEmergencyContact;
  final int priority;
  
  Contact({
    String? id,
    required this.name,
    required this.phoneNumber,
    this.email,
    this.relation = '',
    this.type = ContactType.family,
    this.isEmergencyContact = false,
    this.priority = 1,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();
  
  // המרה למפת JSON לאחסון
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'type': type.toString(),
      'isEmergencyContact': isEmergencyContact,
      'relation': relation,
      'priority': priority,
    };
  }
  
  // יצירת אובייקט ממפת JSON
  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      relation: json['relation'] ?? '',
      type: ContactType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => ContactType.emergency,
      ),
      isEmergencyContact: json['isEmergencyContact'] ?? false,
      priority: json['priority'] ?? 1,
    );
  }
  
  // יצירת עותק עם שינויים
  Contact copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? email,
    ContactType? type,
    bool? isEmergencyContact,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      type: type ?? this.type,
      isEmergencyContact: isEmergencyContact ?? this.isEmergencyContact,
    );
  }
}

enum ContactType {
  family,
  friend,
  colleague,
  emergency,
  other,
}
