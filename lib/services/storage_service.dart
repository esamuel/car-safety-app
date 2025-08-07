import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/contact_model.dart';
import '../models/profile_model.dart';
import '../models/settings_model.dart';
import '../models/user_model.dart';
import '../models/trip_model.dart';

class StorageService {
  SharedPreferences? _prefs;
  
  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }
  
  // Trip Management
  Future<void> saveTrip(Trip trip) async {
    final trips = await getTrips();
    trips.add(trip);
    
    final tripsJson = trips.map((trip) => trip.toJson()).toList();
    await _prefs!.setString('trips', jsonEncode(tripsJson));
  }
  
  Future<List<Trip>> getTrips() async {
    final tripsString = _prefs!.getString('trips');
    if (tripsString == null) return [];
    
    final tripsJson = jsonDecode(tripsString) as List;
    return tripsJson.map((json) => Trip.fromJson(json)).toList();
  }
  
  Future<void> deleteTrip(String tripId) async {
    final trips = await getTrips();
    trips.removeWhere((trip) => trip.id == tripId);
    
    final tripsJson = trips.map((trip) => trip.toJson()).toList();
    await _prefs!.setString('trips', jsonEncode(tripsJson));
  }
  
  // Emergency Contacts Management
  Future<void> saveEmergencyContacts(List<Contact> contacts) async {
    final contactsJson = contacts.map((contact) => contact.toJson()).toList();
    await _prefs!.setString('emergency_contacts', jsonEncode(contactsJson));
  }
  
  Future<List<Contact>> getEmergencyContacts() async {
    final contactsJson = _prefs!.getString('emergency_contacts');
    if (contactsJson == null) return [];
    
    final List<dynamic> contactsList = jsonDecode(contactsJson);
    return contactsList.map((json) => Contact.fromJson(json)).toList();
  }

  // App Settings Management
  Future<void> saveAppSettings(AppSettings settings) async {
    final jsonString = jsonEncode(settings.toJson());
    await _prefs!.setString('app_settings', jsonString);
  }

  Future<AppSettings> getAppSettings() async {
    final jsonString = _prefs!.getString('app_settings');
    
    if (jsonString == null) {
      // אם אין הגדרות שמורות, החזר הגדרות ברירת מחדל
      return AppSettings();
    }
    
    final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
    return AppSettings.fromJson(jsonMap);
  }

  Future<void> addEmergencyContact(Contact contact) async {
    final contacts = await getEmergencyContacts();
    contacts.add(contact);
    await saveEmergencyContacts(contacts);
  }
  
  Future<void> removeEmergencyContact(String contactId) async {
    final contacts = await getEmergencyContacts();
    contacts.removeWhere((contact) => contact.id == contactId);
    await saveEmergencyContacts(contacts);
  }
  
  // User Profile Management
  Future<void> saveUserProfile(UserModel user) async {
    await _prefs!.setString('user_profile', jsonEncode(user.toJson()));
  }
  
  Future<UserModel?> getUserProfile() async {
    final userString = _prefs!.getString('user_profile');
    if (userString == null) return null;
    
    final userJson = jsonDecode(userString);
    return UserModel.fromJson(userJson);
  }
  
  // Settings Management
  Future<void> saveSetting(String key, dynamic value) async {
    if (value is String) {
      await _prefs!.setString('setting_$key', value);
    } else if (value is int) {
      await _prefs!.setInt('setting_$key', value);
    } else if (value is double) {
      await _prefs!.setDouble('setting_$key', value);
    } else if (value is bool) {
      await _prefs!.setBool('setting_$key', value);
    }
  }
  
  T? getSetting<T>(String key, T defaultValue) {
    final settingKey = 'setting_$key';
    
    if (T == String) {
      return _prefs!.getString(settingKey) as T? ?? defaultValue;
    } else if (T == int) {
      return _prefs!.getInt(settingKey) as T? ?? defaultValue;
    } else if (T == double) {
      return _prefs!.getDouble(settingKey) as T? ?? defaultValue;
    } else if (T == bool) {
      return _prefs!.getBool(settingKey) as T? ?? defaultValue;
    }
    
    return defaultValue;
  }
  
  // App State Management
  Future<void> setFirstLaunch(bool isFirstLaunch) async {
    await _prefs!.setBool('is_first_launch', isFirstLaunch);
  }
  
  bool isFirstLaunch() {
    return _prefs!.getBool('is_first_launch') ?? true;
  }
  
  Future<void> setOnboardingCompleted(bool completed) async {
    await _prefs!.setBool('onboarding_completed', completed);
  }
  
  bool isOnboardingCompleted() {
    return _prefs!.getBool('onboarding_completed') ?? false;
  }
  
  // Profile-related methods (using UserProfile model)
  Future<void> saveDetailedUserProfile(UserProfile profile) async {
    final jsonString = jsonEncode(profile.toJson());
    await _prefs!.setString('detailed_user_profile', jsonString);
  }

  Future<UserProfile> getDetailedUserProfile() async {
    final jsonString = _prefs!.getString('detailed_user_profile');
    
    if (jsonString == null) {
      throw Exception('No detailed user profile found');
    }
    
    final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
    return UserProfile.fromJson(jsonMap);
  }
  
  // Clear all data
  Future<void> clearAllData() async {
    await _prefs!.clear();
  }
}
