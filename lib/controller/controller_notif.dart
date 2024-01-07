import 'package:get/get.dart';
import 'package:restauran_app/controller/controller_page.dart';
import 'package:restauran_app/database/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingController extends GetxController {
  final NotificationService notificationService = NotificationService();
  final controller = Get.find<RestaurantController>();
  var isReminderEnabled = false.obs;

  @override
  void onInit() {
    loadReminderStatus();
    super.onInit();
  }

  // Di dalam SettingController
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
    await prefs.setBool('isReminderEnabled', false);
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
