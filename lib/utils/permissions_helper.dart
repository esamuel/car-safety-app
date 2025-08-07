import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../l10n/app_localizations.dart';

class PermissionsHelper {
  // בקשת הרשאת מיקום
  static Future<bool> requestLocationPermissions(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    var status = await Permission.location.status;
    var backgroundStatus = await Permission.locationAlways.status;
    
    if (!status.isGranted) {
      status = await Permission.location.request();
    }
    
    if (status.isGranted && !backgroundStatus.isGranted) {
      // הסבר למשתמש למה צריך הרשאת מיקום ברקע
      await _showPermissionRationaleDialog(
        context,
        l10n.backgroundLocationPermission,
        l10n.backgroundLocationDescription,
      );
      
      backgroundStatus = await Permission.locationAlways.request();
    }
    
    return status.isGranted && backgroundStatus.isGranted;
  }
  
  // בקשת הרשאת Bluetooth
  static Future<bool> requestBluetoothPermissions(BuildContext context) async {
    // במכשירים חדשים, יש הרשאות ספציפיות ל-Bluetooth
    var scanStatus = await Permission.bluetoothScan.status;
    var connectStatus = await Permission.bluetoothConnect.status;
    
    if (!scanStatus.isGranted) {
      scanStatus = await Permission.bluetoothScan.request();
    }
    
    if (!connectStatus.isGranted) {
      connectStatus = await Permission.bluetoothConnect.request();
    }
    
    return scanStatus.isGranted && connectStatus.isGranted;
  }
  
  // בקשת הרשאת התראות
  static Future<bool> requestNotificationPermission(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    var status = await Permission.notification.status;
    
    if (!status.isGranted) {
      // הסבר למשתמש למה צריך הרשאת התראות
      await _showPermissionRationaleDialog(
        context,
        l10n.notificationPermission,
        l10n.notificationPermissionDescription,
      );
      
      status = await Permission.notification.request();
    }
    
    return status.isGranted;
  }
  
  // בקשת הרשאת SMS
  static Future<bool> requestSmsPermission(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    var status = await Permission.sms.status;
    
    if (!status.isGranted) {
      // הסבר למשתמש למה צריך הרשאת SMS
      await _showPermissionRationaleDialog(
        context,
        l10n.smsPermission,
        l10n.smsPermissionDescription,
      );
      
      status = await Permission.sms.request();
    }
    
    return status.isGranted;
  }
  
  // בקשת הרשאת הפעלה אוטומטית (רלוונטי בעיקר למכשירי אנדרואיד מסוימים)
  static Future<void> requestAutoStartPermission(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    // מציג הנחיות למשתמש כיצד להפעיל הרשאה זו בהגדרות המכשיר
    // (לא ניתן לבקש הרשאה זו באופן פרוגרמטי בכל המכשירים)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.autoStartPermission),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.autoStartPermissionInstructions),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.understood),
          ),
        ],
      ),
    );
  }
  
  // הצגת הסבר למשתמש לפני בקשת הרשאה
  static Future<void> _showPermissionRationaleDialog(
    BuildContext context,
    String title,
    String message,
  ) async {
    final l10n = AppLocalizations.of(context);
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.understood),
          ),
        ],
      ),
    );
  }
}
