import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restauran_app/controller/controller_notif.dart';
import 'package:restauran_app/controller/controller_page.dart';

class SettingPage extends StatelessWidget {
  final SettingController settingController = Get.find<SettingController>();
  final RestaurantController controller = Get.find<RestaurantController>();
  final String notificationTitle;
  final String notificationMessage;

  SettingPage({
    required this.notificationTitle,
    required this.notificationMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Notification Title: $notificationTitle',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Notification Message: $notificationMessage',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Panggil metode untuk mematikan notifikasi harian
                  settingController.cancelScheduledReminder();
                },
                child: Text('Notikasi Harian'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() => Switch(
                        value: settingController.isReminderEnabled.value,
                        onChanged: (value) {
                          settingController.toggleReminder();
                        },
                      )),
                  SizedBox(width: 10),
                  Obx(() => Text(
                        settingController.isReminderEnabled.value
                            ? 'Notifikasi Hidup'
                            : 'Notifikasi Mati',
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
