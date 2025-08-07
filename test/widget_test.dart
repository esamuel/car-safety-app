// Basic app launch test for Car Safety App

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:car_safety_app/main.dart';
import 'package:car_safety_app/services/storage_service.dart';
import 'package:car_safety_app/services/location_service.dart';
import 'package:car_safety_app/services/bluetooth_service.dart';
import 'package:car_safety_app/services/notification_service.dart';

void main() {
  testWidgets('App launches without crashing', (WidgetTester tester) async {
    // Create mock services for testing
    final storageService = StorageService();
    final notificationService = NotificationService();
    final locationService = LocationService();
    final bluetoothService = BluetoothService();

    // Build our app with providers
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<StorageService>(create: (_) => storageService),
          Provider<NotificationService>(create: (_) => notificationService),
          Provider<LocationService>(create: (_) => locationService),
          Provider<BluetoothService>(create: (_) => bluetoothService),
        ],
        child: MyApp(),
      ),
    );

    // Wait for splash screen
    await tester.pump();
    
    // Verify splash screen elements are present
    expect(find.text('מערכת בטיחות לרכב'), findsOneWidget);
    expect(find.text('מניעת שכחת ילדים ברכב'), findsOneWidget);
  });
}
