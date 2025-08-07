import 'package:flutter_sms/flutter_sms.dart';
import 'package:permission_handler/permission_handler.dart';

class SmsService {
  Future<bool> requestSmsPermission() async {
    final status = await Permission.sms.request();
    return status == PermissionStatus.granted;
  }

  Future<bool> sendSms(String phoneNumber, String message) async {
    try {
      if (!await requestSmsPermission()) {
        print('SMS permission denied');
        return false;
      }

      String result = await sendSMS(
        message: message,
        recipients: [phoneNumber],
      );
      
      print('SMS sent successfully to $phoneNumber: $result');
      return true;
    } catch (e) {
      print('Failed to send SMS: $e');
      return false;
    }
  }
  
  Future<void> sendEmergencySms(String phoneNumber, String location) async {
    final message = 'התראת בטיחות חירום!\n'
        'ייתכן שנשכח ילד ברכב במיקום: $location\n'
        'אנא בדוק מיד!\n'
        'הודעה נשלחה ממערכת בטיחות הרכב';
    
    await sendSms(phoneNumber, message);
  }
}
