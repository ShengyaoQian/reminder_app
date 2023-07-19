import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:reminder_app/main.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService =
  NotificationService._internal();
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  factory NotificationService() {
    return _notificationService;
  }


  NotificationService._internal();


  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');

    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: null);
    tz.initializeTimeZones();  //  <----
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }


  Future selectNotification(String? payload) async {
    // haven't decided..
  }

  Future<void> requestIOSPermissions() async {
    bool? permission = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  NotificationDetails platformChannelSpecifics() {
    const AndroidNotificationDetails _androidNotificationDetails =
    AndroidNotificationDetails(
      'channel ID',
      'channel name',
      playSound: true,
      priority: Priority.high,
      importance: Importance.high,
    );
    const IOSNotificationDetails _iosNotificationDetails = IOSNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        badgeNumber: 1,
        attachments: [],
        subtitle: "",
        threadIdentifier: ""
    );
    return NotificationDetails(
        android: _androidNotificationDetails,
        iOS: _iosNotificationDetails);
  }

  Future<void> scheduleNotifications(int id, String body, int durationNumber, String unit) async {
    Duration duration = Duration(seconds: 0);
    switch(unit) {
      case "Months":
        duration = Duration(days: 30 * durationNumber);
        break;
      case "Days":
        duration = Duration(days: durationNumber);
        break;
      case "Hours":
        duration = Duration(hours: durationNumber);
        break;
      case "Minutes":
        duration = Duration(minutes: durationNumber);
    };
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        "You have a task due..",
        body,
        tz.TZDateTime.now(tz.local).add(duration),
        platformChannelSpecifics(),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> cancelNotifications(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}