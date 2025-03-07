// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// class localNotification {
//   static final FlutterLocalNotificationsPlugin
//       _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   static Future init() async {
//     // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mimap/ic_launcher');
//     final DarwinInitializationSettings initializationSettingsDarwin =
//         DarwinInitializationSettings(
//             onDidReceiveLocalNotification: ((id, title, body, payload) =>
//                 null));
//     final LinuxInitializationSettings initializationSettingsLinux =
//         LinuxInitializationSettings(defaultActionName: 'Open notification');
//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//             android: initializationSettingsAndroid,
//             iOS: initializationSettingsDarwin,
//             linux: initializationSettingsLinux);
//     _flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onDidReceiveNotificationResponse: ((details) => null));
//   }

//   static Future showSimpleNotification(
//       {required String title,
//       required String body,
//       required String payload}) async {
//     const AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails('your channel id', 'your channel name',
//             channelDescription: 'your channel description',
//             importance: Importance.max,
//             priority: Priority.high,
//             ticker: 'ticker');
//     const NotificationDetails notificationDetails =
//         NotificationDetails(android: androidNotificationDetails);
//     await _flutterLocalNotificationsPlugin
//         .show(0, title, body, notificationDetails, payload: payload);
//   }



//  static Future showScheduledNotification({
//     required String title,
//     required String body,
//     required String channelId,
//     required String channelName,
//     required int hour,
//     required int minute,
//   }) async {
//     tz.initializeTimeZones();

//     final tz.TZDateTime scheduledTime = tz.TZDateTime(
//       tz.getLocation('Asia/Kolkata'),
//       DateTime.now().year,
//       DateTime.now().month,
//       DateTime.now().day,
//       hour, // Hour
//       minute, // Minute
//     );

//     await _flutterLocalNotificationsPlugin.zonedSchedule(
//       0,
//       title,
//       body,
//       scheduledTime,
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           "1",
//           "Vansham",
//           channelDescription: 'Channel Description',
//         ),
//       ),
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.time,
//     );
//   }

//   static void scheduleNotifications() {
//     // Schedule multiple notifications at different times
//     showScheduledNotification(
//       title: 'Notification 1',
//       body: 'This is the first notification',
//       channelId: '1',
//       channelName: 'Channel 1',
//       hour: 22,
//       minute: 43,
//     );

//     showScheduledNotification(
//       title: 'Notification 2',
//       body: 'This is the second notification',
//       channelId: '2',
//       channelName: 'Channel 2',
//       hour: 22,
//       minute: 47,
//     );

//     showScheduledNotification(
//       title: 'Notification 3',
//       body: 'This is the third notification',
//       channelId: '3',
//       channelName: 'Channel 3',
//       hour: 22,
//       minute: 50,
//     );

//     showScheduledNotification(
//       title: 'Notification 4',
//       body: 'This is the fourth notification',
//       channelId: '4',
//       channelName: 'Channel 4',
//       hour: 22, // 11 PM
//       minute: 55,
//     );
//   }

// }

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('flutter_logo');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(
        id, title, body, await notificationDetails());
  }

   // Define the time for the daily notification at 10:35 PM
    final tz.TZDateTime scheduledTime = tz.TZDateTime(
      tz.getLocation('Asia/Kolkata'), // Replace 'your_timezone' with your desired timezone
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      22, // 10 PM
      35, // 35 minutes
    );
  Future scheduleNotification(
      {
        int id = 0,
      String? title,
      String? body,
      String? payLoad,
      required DateTime scheduledNotificationDateTime}) async {
    return notificationsPlugin.zonedSchedule(
        1,
        "Vansham",
        "Hello",
        scheduledTime,
        await notificationDetails(),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}