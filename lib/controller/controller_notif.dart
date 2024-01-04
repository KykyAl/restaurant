import 'package:get/get.dart';
import 'package:restauran_app/controller/controller_page.dart';
import 'package:restauran_app/database/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingController extends GetxController {
  final NotificationService notificationService = NotificationService();
  final controller = Get.find<RestaurantController>();
  var isReminderEnabled = false.obs; // Set default status ke false

  @override
  void onInit() {
    loadReminderStatus(); // Panggil metode untuk mengatur status notifikasi awal
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
    // Simpan status notifikasi ke Shared Preferences
    await saveReminderStatus(isReminderEnabled.value);
  }

  void scheduleDailyReminder() {
    notificationService.showDailyRestaurantNotification();
  }

  void cancelScheduledReminder() {
    // Logika mematikan notifikasi harian di sini
    notificationService.cancelScheduledNotification();
    // Simpan status notifikasi ke Shared Preferences
    saveReminderStatus(isReminderEnabled.value);
  }

  // Metode untuk menyimpan status notifikasi ke Shared Preferences
  Future<void> saveReminderStatus(bool isReminderEnabled) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isReminderEnabled', isReminderEnabled);
  }

  // Di dalam SettingController
  Future<void> loadReminderStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? storedStatus = prefs.getBool('isReminderEnabled');

    if (storedStatus != null) {
      isReminderEnabled.value = storedStatus;
    } else {
      // Jika status notifikasi belum diatur sebelumnya,
      // set nilai default (mati) dan simpan ke Shared Preferences
      isReminderEnabled.value = false;
      await saveReminderStatus(isReminderEnabled.value);
    }
    print('Loaded Reminder Status: $isReminderEnabled');
  }
}
