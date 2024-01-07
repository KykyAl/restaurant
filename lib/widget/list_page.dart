import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restauran_app/controller/controller_page.dart';
import 'package:restauran_app/error/404.dart';
import 'package:restauran_app/helper/navigator_helper.dart';
import 'package:restauran_app/model/remote_model.dart';
import 'package:restauran_app/widget/image.dart';

class ListPage extends GetWidget<RestaurantController> {
  final NavigatorHelper navigatorHelper = NavigatorHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(
          'Restauran Apps',
          style: GoogleFonts.abrilFatface(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        actions: [
          InkWell(
            onTap: () => Get.toNamed(navigatorHelper.searchPage),
            child: Container(
              height: 50,
              width: 50,
              child: const Icon(
                Icons.search,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Container(
            color: Color.fromARGB(230, 34, 33, 33),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(left: 20, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Hitsss',
                        style: GoogleFonts.abrilFatface(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Colors.yellowAccent,
                        ),
                      ),
                      const Icon(
                        Icons.thunderstorm_outlined,
                        color: Colors.blue,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.isTrue) {
                      return Center(child: CircularProgressIndicator());
                    } else if (!controller.isOnline.value) {
                      return Center(
                        child: Text(
                          'Tidak ada koneksi internet',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.yellow),
                        ),
                      );
                    } else if (controller.restaurantList.isEmpty) {
                      return NotFound(
                        codeError: '500',
                        message:
                            'An error occurred: ${controller.isError.value}',
                      );
                    } else {
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              orientation == Orientation.portrait ? 2 : 2,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          childAspectRatio:
                              orientation == Orientation.portrait ? 0.7 : 1.0,
                        ),
                        itemCount: controller.restaurantList.length,
                        itemBuilder: (context, index) {
                          return buildArticleItem(
                            context,
                            controller.restaurantList[index],
                          );
                        },
                      );
                    }
                  }),
                ),
              ],
            ),
          );
        },
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

  Widget buildArticleItem(BuildContext context, RestaurantModel restaurant) {
    return InkWell(
      onTap: () {
        Get.toNamed(navigatorHelper.detailPage,
            arguments: {"id": restaurant.id});
      },
      child: Container(
        margin: EdgeInsets.only(left: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.brown,
        ),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 130,
              child: Stack(
                children: [
                  BlurHash(
                    hash:
                        r'f8C6M$9tcY,FKOR*00%2RPNaaKjZUawdv#K4$Ps:HXELTJ,@XmS2=yxuNGn%IoR*',
                    image:
                        'https://restaurant-api.dicoding.dev/images/large/${restaurant.pictureId}',
                    imageFit: BoxFit.cover,
                  ),
                  Positioned.fill(
                    child: ImgApi(
                      imageUrl:
                          'https://restaurant-api.dicoding.dev/images/large/${restaurant.pictureId}',
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
              height: 5,
              color: Colors.black,
            ),
            Text(
              restaurant.name.toString(),
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              ' ${restaurant.city}',
              style: GoogleFonts.openSans(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: Divider(
                thickness: 1,
                height: 5,
                color: Colors.black,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.yellow, size: 18),
                SizedBox(width: 4),
                Text(
                  '${restaurant.rating}',
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Lihat detail',
                  style: GoogleFonts.openSans(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                Icon(
                  Icons.arrow_circle_right_rounded,
                  size: 40,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
