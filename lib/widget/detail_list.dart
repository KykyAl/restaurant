import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restauran_app/controller/controler_favorit.dart';
import 'package:restauran_app/controller/controller_detail.dart';
import 'package:restauran_app/error/404.dart';
import 'package:restauran_app/helper/navigator_helper.dart';
import 'package:restauran_app/widget/image.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final NavigatorHelper navigatorHelper = NavigatorHelper();
  final controller = Get.find<RestaurantDetailController>();
  final favoriteController = Get.find<FavoriteListController>();

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;

    final restaurantId = arguments != null ? arguments['id'] : null;

    if (restaurantId != null) {
      controller.fetchRestaurantDetail(restaurantId);
    } else {
      print('Error: No valid ID found in arguments');
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Restoran',
          style: GoogleFonts.abrilFatface(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.brown,
      ),
      body: Obx(
        () {
          if (controller.isLoadingDetail.isTrue) {
            return Center(child: CircularProgressIndicator());
          } else if (controller.isError.isTrue) {
            return NotFound(
              codeError: '500',
              message:
                  'An error occurred: ${controller.errorMessageDetail.value}',
            );
          } else {
            if (controller.restaurantDetail.isNotEmpty) {
              final restaurant = controller.restaurantDetail[0];

              return CustomScrollView(
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
                                'https://restaurant-api.dicoding.dev/images/large/${restaurant.pictureId}',
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
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Row(
                            children: [
                              Text(
                                restaurant.name,
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.brown,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await favoriteController
                                      .setRestaurantDetail(restaurant);
                                  await favoriteController
                                      .loadFavoriteRestaurants();
                                },
                                icon: Obx(() {
                                  final isFavorite = favoriteController
                                      .favoriteRestaurants
                                      .any((favRestaurant) =>
                                          favRestaurant.id == restaurant.id);

                                  return Icon(
                                    isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isFavorite ? Colors.red : null,
                                  );
                                }),
                              ),
                              Text('Suka')
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            restaurant.description,
                            style: GoogleFonts.openSans(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Kota : ${restaurant.city}',
                            style: GoogleFonts.openSans(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text('Alamat : ${restaurant.address}'),
                          SizedBox(height: 11),
                          Row(
                            children: [
                              Text(
                                'Kategori :',
                                style: GoogleFonts.openSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.brown,
                                ),
                              ),
                              Text(
                                ' ${restaurant.categories.map((category) => category.name).join(', ')}',
                              ),
                              SizedBox(width: 5),
                              Row(
                                children: List.generate(
                                  restaurant.rating.floor(),
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
                              Text('${restaurant.rating}'),
                            ],
                          ),
                          SizedBox(height: 25),
                          Center(
                            child: Container(
                              width: 65,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.brown,
                              ),
                              child: Center(
                                child: Text('Menu',
                                    style: GoogleFonts.openSans(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.restaurant,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                'Makanan',
                                style: GoogleFonts.openSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.brown,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20, left: 20),
                            child: Divider(
                              thickness: 1,
                            ),
                          ),
                          Column(
                            children: restaurant.menus.foods.map((food) {
                              return Card(
                                child: ListTile(
                                  leading: Icon(
                                    Icons.food_bank_rounded,
                                    color: Colors.red,
                                  ),
                                  title: Text(
                                    food.name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.brown,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.local_drink,
                                color: Colors.blue,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                'Minuman',
                                style: GoogleFonts.openSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.brown,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20, left: 20),
                            child: Divider(
                              thickness: 1,
                            ),
                          ),
                          Column(
                            children: restaurant.menus.drinks.map((drink) {
                              return Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.local_drink_rounded,
                                      color: Colors.blue[100],
                                    ),
                                    title: Text(
                                      drink.name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.brown,
                                      ),
                                    ),
                                  ));
                            }).toList(),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.comment_sharp),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Komentar',
                                style: GoogleFonts.openSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.brown,
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20, left: 20),
                            child: Divider(
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(10.0),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          var review = restaurant.customerReviews[index];
                          return Card(
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 4),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.comment,
                                    size: 15.0,
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${review.name}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.brown,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Text(
                                        '${review.review}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    ' ${review.date}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        childCount: restaurant.customerReviews.length,
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return NotFound(
                codeError: '404',
                message: 'Restaurant not found.',
              );
            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(navigatorHelper.favoriteList,
              arguments: {"id": restaurantId});
        },
        child: Icon(Icons.favorite),
      ),
    );
  }
}
