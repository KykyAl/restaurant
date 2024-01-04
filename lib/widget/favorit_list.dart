import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restauran_app/controller/controler_favorit.dart';
import 'package:restauran_app/helper/navigator_helper.dart';
import 'package:restauran_app/widget/image.dart';

class FavoriteListPage extends StatelessWidget {
  final controller = Get.find<FavoriteListController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final navigatorHelper = NavigatorHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Restaurants'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Obx(() => controller.favoriteRestaurants.isEmpty
            ? Center(
                child: Text('No favorite restaurants yet.'),
              )
            : ListView.builder(
                shrinkWrap: true,
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
                        child: ImgApi(
                          imageUrl:
                              'https://restaurant-api.dicoding.dev/images/large/${restaurant.pictureId}',
                          scaffoldKey: _scaffoldKey,
                        ),
                      ),
                      title: Text(
                        restaurant.name.toString(),
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(restaurant.city),
                          SizedBox(width: 4),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              final confirmed =
                                  await controller.showConfirmationDialogDelete(
                                      context, restaurant.name);
                              if (confirmed != null && confirmed) {
                                await controller
                                    .removeFavoriteRestaurant(restaurant.id);
                                await controller.loadFavoriteRestaurants();
                              }
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        Get.toNamed(navigatorHelper.detailPage,
                            arguments: {'id': restaurant.id});
                      },
                    ),
                  );
                },
              )),
      ),
    );
  }
}
