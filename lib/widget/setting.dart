import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restauran_app/controller/controller_notif.dart';
import 'package:restauran_app/controller/controller_page.dart';
import 'package:restauran_app/widget/image.dart';

class SettingPage extends StatelessWidget {
  final SettingController settingController = Get.find<SettingController>();
  final RestaurantController controller = Get.find<RestaurantController>();

  final String notificationTitle;
  final String notificationMessage;
  // final String description;
  final String pictureId;
  final double rating;

  SettingPage({
    required this.notificationTitle,
    required this.notificationMessage,
    // required this.description,
    required this.pictureId,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              height: 280,
              color: Colors.grey[300],
              child: Stack(
                children: [
                  BlurHash(
                    hash:
                        r'f8C6M$9tcY,FKOR*00%2RPNaaKjZUawdv#K4$Ps:HXELTJ,@XmS2=yxuNGn%IoR*',
                    image:
                        'https://restaurant-api.dicoding.dev/images/large/${pictureId}',
                  ),
                  Positioned.fill(
                    child: ImgApi(
                      imageUrl:
                          'https://restaurant-api.dicoding.dev/images/large/${pictureId}',
                    ),
                  ),
                ],
              ),
            ),
          ),
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
                SizedBox(
                  height: 5,
                ),
                SizedBox(height: 11),
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
              ]),
            ),
          ),
        ],
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
