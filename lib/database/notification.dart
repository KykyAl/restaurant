import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:restauran_app/controller/controller_page.dart';
import 'package:restauran_app/helper/navigator_helper.dart';
import 'package:restauran_app/model/remote_model.dart';
import 'package:restauran_app/model/remote_notif.dart';
import 'package:restauran_app/widget/setting.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final NavigatorHelper navigatorHelper = NavigatorHelper();
  RxList<RestaurantModel> listRestaurant = <RestaurantModel>[].obs;

  Future<void> initialize() async {
    tz.initializeTimeZones();
    final String timeZoneName = 'Asia/Jakarta';
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: _onSelectNotification,
    );
  }

  RestaurantNotifModel buildRandomRestaurant() {
    final controller = Get.find<RestaurantController>();
    final random = Random();
    final randomIndex = random.nextInt(controller.restaurantList.length);
    final randomRestaurant = controller.restaurantList[randomIndex];
    print('Random${randomRestaurant}');
    // Anda dapat mengembalikan objek RestaurantNotifModel langsung
    return RestaurantNotifModel(
        name: randomRestaurant.name,
        city: randomRestaurant.city,
        description: randomRestaurant.description,
        pictureId: randomRestaurant.pictureId,
        rating: randomRestaurant.rating);
  }

  Future<void> _onSelectNotification(String? payload) async {
    final RestaurantNotifModel randomRestaurant = buildRandomRestaurant();
    final int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'dailyReminderChannel',
      'Daily Reminder',
      importance: Importance.high,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('alarm'),
    );
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      notificationId,
      'Restoran Harian: ${randomRestaurant.name}',
      'Cek restoran acak hari ini!',
      platformChannelSpecifics,
      payload: payload,
    );

    Get.off(() => SettingPage(
          notificationTitle: 'Restoran Harian: ${randomRestaurant.name}',
          notificationMessage: '${randomRestaurant.city}',
          pictureId: randomRestaurant.pictureId,
          rating: randomRestaurant.rating,
        ));

    // Batalkan notifikasi setelah diklik
    await flutterLocalNotificationsPlugin.cancel(notificationId);
  }

  Future<void> showDailyRestaurantNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Daily Restaurant Reminder',
      'Jangan lupa cek restoran acak hari ini!',
      _nextInstance(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'dailyReminderChannel',
          'Daily Reminder',
          importance: Importance.high,
          priority: Priority.high,
          sound: RawResourceAndroidNotificationSound('alarm'),
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextInstance() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute + 1,
    );

    if (now.isAfter(scheduledDate)) {
      scheduledDate = scheduledDate.add(const Duration(minutes: 1));
    }

    return scheduledDate;
  }

  // Di dalam NotificationService
  Future<void> cancelScheduledNotification() async {
    // Panggil metode cancelScheduledNotification dari FlutterLocalNotificationsPlugin
    await flutterLocalNotificationsPlugin.cancel(0);
  }
}
