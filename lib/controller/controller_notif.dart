import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restauran_app/controller/controller_page.dart';
import 'package:restauran_app/database/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingController extends GetxController {
  final NotificationService notificationService = NotificationService();
  final controller = Get.find<RestaurantController>();
  var isReminderEnabled = false.obs;
  RxBool hasInternetConnection = true.obs;
  RxBool connectionStatus = false.obs;
  RxBool showPopup = false.obs;
  Rx<int> responseTime = 0.obs;
  Rx<Color> color = Colors.green.obs;
  Rx<IconData> icons = Icons.wifi.obs;
  RxBool isInternetConnected = true.obs;
  var isOnline = true.obs;
  @override
  void onInit() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      isOnline.value = (result != ConnectivityResult.none);
    });
    loadReminderStatus();

    super.onInit();
  }

  void toggleReminder() async {
    isReminderEnabled.value = !isReminderEnabled.value;
    if (isReminderEnabled.value) {
      scheduleDailyReminder();
    } else {
      cancelScheduledReminder();
    }
    await saveReminderStatus(isReminderEnabled.value);
  }

  void scheduleDailyReminder() {
    notificationService.showDailyRestaurantNotification();
  }

  void cancelScheduledReminder() {
    notificationService.cancelScheduledNotification();
    saveReminderStatus(isReminderEnabled.value);
  }

  Future<void> saveReminderStatus(bool isReminderEnabled) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isReminderEnabled', isReminderEnabled);
  }

  Future<void> loadReminderStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? storedStatus = prefs.getBool('isReminderEnabled');

    if (storedStatus != null) {
      isReminderEnabled.value = storedStatus;
    } else {
      isReminderEnabled.value = false;
      await saveReminderStatus(isReminderEnabled.value);
    }
  }
}
