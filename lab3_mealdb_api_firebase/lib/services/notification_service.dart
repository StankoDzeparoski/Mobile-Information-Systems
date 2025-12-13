import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../screens/mealDetails.dart';
import '../services/api.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<void> init() async {
    tz.initializeTimeZones();

    tz.setLocalLocation(tz.getLocation('Europe/Skopje'));

    debugPrint('Local timezone set to: ${tz.local.name}');

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) async {
        try {
          final api = ApiService();
          final meal = await api.randomMeal();
          if (meal != null) {
            navigatorKey.currentState?.push(
              MaterialPageRoute(builder: (_) => MealDetailScreen(meal: meal)),
            );
          }
        } catch (e) {
          debugPrint('Notification tap error: $e');
        }
      },
    );

    debugPrint('NotificationService initialized successfully');
  }

  static Future<void> scheduleDailyRecipe({
    int hour = 10,
    int minute = 0,
  }) async {
    final now = tz.TZDateTime.now(tz.local);

    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    debugPrint('Daily notification scheduled for: $scheduledDate');

    await _plugin.zonedSchedule(
      0,
      'Recipe of the day',
      'Open the app to see today\'s random recipe!',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_recipe',
          'Daily Recipe',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> showTestNow() async {
    await _plugin.show(
      999,
      'Test Notification',
      'Notifications Work',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_now',
          'Immediate Test',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );

    debugPrint('Immediate test notification shown');
  }

  static Future<void> scheduleInOneMinute() async {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = now.add(const Duration(minutes: 1));

    debugPrint('NOW (local): $now');
    debugPrint('SCHEDULED (local): $scheduledDate');

    await _plugin.zonedSchedule(
      2000,
      'Scheduled test',
      'This should appear 1 minute after launch',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'schedule_test',
          'Schedule Test',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    debugPrint('Exact alarm scheduled');
  }
}
