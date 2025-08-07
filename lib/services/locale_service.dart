import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleService extends ChangeNotifier {
  static const String _localeKey = 'selected_locale';
  Locale _currentLocale = const Locale('he', 'IL'); // Default to Hebrew

  Locale get currentLocale => _currentLocale;
  
  // Get text direction based on current locale
  TextDirection get textDirection => 
      _currentLocale.languageCode == 'he' ? TextDirection.rtl : TextDirection.ltr;

  // Check if current language is Hebrew
  bool get isHebrew => _currentLocale.languageCode == 'he';

  // Check if current language is English
  bool get isEnglish => _currentLocale.languageCode == 'en';

  // Initialize locale service
  Future<void> init() async {
    await loadSavedLocale();
  }

  // Load saved locale from preferences
  Future<void> loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_localeKey) ?? 'he';
      
      if (languageCode == 'he') {
        _currentLocale = const Locale('he', 'IL');
      } else {
        _currentLocale = const Locale('en', 'US');
      }
      
      notifyListeners();
    } catch (e) {
      print('Error loading saved locale: $e');
      _currentLocale = const Locale('he', 'IL'); // Fallback to Hebrew
    }
  }

  // Change language and save to preferences
  Future<void> changeLanguage(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, languageCode);
      
      if (languageCode == 'he') {
        _currentLocale = const Locale('he', 'IL');
      } else {
        _currentLocale = const Locale('en', 'US');
      }
      
      notifyListeners();
    } catch (e) {
      print('Error saving locale: $e');
    }
  }

  // Toggle between Hebrew and English
  Future<void> toggleLanguage() async {
    final newLanguage = _currentLocale.languageCode == 'he' ? 'en' : 'he';
    await changeLanguage(newLanguage);
  }

  // Get supported locales
  static List<Locale> get supportedLocales => [
    const Locale('he', 'IL'),
    const Locale('en', 'US'),
  ];

  // Get language name for display
  String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'he':
        return 'עברית';
      case 'en':
        return 'English';
      default:
        return languageCode;
    }
  }

  // Get localized language name for display in current language
  String getLocalizedLanguageName(String languageCode) {
    if (_currentLocale.languageCode == 'he') {
      switch (languageCode) {
        case 'he':
          return 'עברית';
        case 'en':
          return 'אנגלית';
        default:
          return languageCode;
      }
    } else {
      switch (languageCode) {
        case 'he':
          return 'Hebrew';
        case 'en':
          return 'English';
        default:
          return languageCode;
      }
    }
  }
}
