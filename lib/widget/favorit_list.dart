import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restauran_app/controller/controler_favorit.dart';
import 'package:restauran_app/helper/navigator_helper.dart';
import 'package:restauran_app/widget/image.dart';

class FavoriteListPage extends StatelessWidget {
  final controller = Get.find<FavoriteListController>();

  final navigatorHelper = NavigatorHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Favorite Restaurants',
              style: GoogleFonts.abrilFatface(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.brown,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Obx(() => controller.favoriteRestaurants.isEmpty
            ? Center(
                child: Text('Tidak Ada Restauran Di Favoritkan.'),
              )
            : ListView.builder(
                itemCount: controller.favoriteRestaurants.length,
                itemBuilder: (context, index) {
                  final restaurant = controller.favoriteRestaurants[index];
                  return Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 8.0,
                    ),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListTile(
                        leading: Container(
                            width: 88,
                            child: Stack(
                              children: [
                                BlurHash(
                                  hash:
                                      r'f8C6M$9tcY,FKOR*00%2RPNaaKjZUawdv#K4$Ps:HXELTJ,@XmS2=yxuNGn%IoR*',
                                  image:
                                      'https://restaurant-api.dicoding.dev/images/large/${restaurant.pictureId}',
                                ),
                                Positioned.fill(
                                  child: ImgApi(
                                    imageUrl:
                                        'https://restaurant-api.dicoding.dev/images/large/${restaurant.pictureId}',
                                  ),
                                ),
                              ],
                            )),
                        title: Text(
                          restaurant.name.toString().toString(),
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(restaurant.city.toString()),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 18,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '${restaurant.rating}',
                                  style: GoogleFonts.poppins(fontSize: 15),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                final confirmed = await controller
                                    .showConfirmationDialogDelete(
                                        context, restaurant.name.toString());
                                if (confirmed != null && confirmed) {
                                  await controller.removeFavoriteRestaurant(
                                      restaurant.id.toString());
                                  await controller.loadFavoriteRestaurants();
                                }
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          Get.toNamed(
                            navigatorHelper.detailPage,
                            arguments: {"id": restaurant.id},
                          );
                        }),
                  );
                },
              )),
      ),
    );
  }
}
