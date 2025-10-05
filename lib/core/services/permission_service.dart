// import 'package:permission_handler/permission_handler.dart';

// class PermissionService {
//   static Future<void> requestAllPermissions() async {
//     // نوتیف
//     var notifStatus = await Permission.notification.status;
//     if (!notifStatus.isGranted) {
//       await Permission.notification.request();
//     }

//     // آلارم دقیق
//     var alarmStatus = await Permission.scheduleExactAlarm.status;
//     if (!alarmStatus.isGranted) {
//       await Permission.scheduleExactAlarm.request();
//     }

//     // می‌تونی بقیه دسترسی‌ها رو هم اینجا اضافه کنی
//   }
// }
