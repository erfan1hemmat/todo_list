// // core/services/reminder_service.dart
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:flutter/material.dart';
// import 'package:todo_list/features/todos/domain/entities/todo.dart';

// class ReminderService {
//   static Future<void> init() async {
//     await AwesomeNotifications().initialize(
//       null,
//       [
//         NotificationChannel(
//           channelKey: 'todo_channel',
//           channelName: 'یادآورها',
//           channelDescription: 'نوتیفیکیشن‌های مربوط به کارها',
//           defaultColor: Colors.teal,
//           importance: NotificationImportance.High,
//           channelShowBadge: true,
//           playSound: true,
//           enableVibration: true,
//         )
//       ],
//       debug: true,
//     );

//     // گرفتن اجازه از کاربر
//     final isAllowed = await AwesomeNotifications().isNotificationAllowed();
//     if (!isAllowed) {
//       await AwesomeNotifications().requestPermissionToSendNotifications();
//     }
//   }

//   static Future<void> scheduleReminder(Todo todo) async {
//     if (todo.reminderTime == null) return;

//     final scheduledDate = todo.reminderTime!;
//     if (scheduledDate.isBefore(DateTime.now())) {
//       debugPrint("⛔ تاریخ یادآور گذشته است: $scheduledDate");
//       return;
//     }

//     await AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id: todo.id.hashCode,
//         channelKey: 'todo_channel',
//         title: "یادآور: ${todo.title}",
//         body: todo.description ?? "یادآور تنظیم شده",
//         notificationLayout: NotificationLayout.Default,
//       ),
//       schedule: NotificationCalendar(
//         year: scheduledDate.year,
//         month: scheduledDate.month,
//         day: scheduledDate.day,
//         hour: scheduledDate.hour,
//         minute: scheduledDate.minute,
//         second: 0,
//         millisecond: 0,
//         repeats: false, // می‌تونی بزنی true برای تکرار
//       ),
//     );
//   }

//   static Future<void> cancelReminder(String id) async {
//     await AwesomeNotifications().cancel(id.hashCode);
//   }

//   static Future<void> cancelAllReminders() async {
//     await AwesomeNotifications().cancelAll();
//   }
// }
