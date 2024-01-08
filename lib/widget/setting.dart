import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restauran_app/controller/controller_notif.dart';
import 'package:restauran_app/controller/controller_page.dart';
import 'package:restauran_app/helper/navigator_helper.dart';

class SettingPage extends StatelessWidget {
  final SettingController settingController = Get.find<SettingController>();
  final RestaurantController controller = Get.find<RestaurantController>();
  final NavigatorHelper navigatorHelper = NavigatorHelper();
  final String notificationTitle;
  final String notificationMessage;
  final String city;
  final double rating;
  final String id;

  SettingPage({
    required this.id,
    required this.notificationTitle,
    required this.notificationMessage,
    required this.city,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daily',
          style: GoogleFonts.abrilFatface(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.brown,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notificationTitle,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'Kota : ${notificationMessage}',
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
                SizedBox(height: 11),
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Rating :',
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                        SizedBox(width: 5),
                        Row(
                          children: List.generate(
                            rating.floor(),
                            (index) => Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: 18,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('${rating}'),
                      ],
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Get.offAllNamed(navigatorHelper.root);
                                  },
                                  child: Text('Daily Notification'),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Obx(() => Switch(
                                          value: settingController
                                              .isReminderEnabled.value,
                                          onChanged: (value) {
                                            settingController.toggleReminder();
                                          },
                                        )),
                                    SizedBox(width: 10),
                                    Obx(() => Text(
                                          settingController
                                                  .isReminderEnabled.value
                                              ? 'Notifikasi Hidup'
                                              : 'Notifikasi Mati',
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          backgroundColor: Color.fromARGB(230, 34, 33, 33),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Menu',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorite',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Setting',
            ),
          ],
          currentIndex: controller.selectedIndex.value,
          selectedItemColor: Colors.brown,
          onTap: (index) => controller.onItemTapped(index),
        ),
      ),
    );
  }
}
