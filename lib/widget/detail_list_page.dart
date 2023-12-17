import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restauran_app/data/data_source.dart';
import 'package:restauran_app/data/remote_model_detail.dart';
import 'package:restauran_app/helper/navigator_helper.dart';
import 'package:restauran_app/widget/list_page.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final RemoteDatasource restaurantApi = RemoteDatasource();
  final NavigatorHelper navigatorHelper = NavigatorHelper();
  @override
  Widget build(BuildContext context) {
    final String restaurantId = Get.arguments;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pencarian Restoran',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          backgroundColor: Colors.brown,
        ),
        body: FutureBuilder<RestaurantDetailModel>(
          future: restaurantApi.getRestaurantDetail(restaurantId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final RestaurantDetailModel restaurant = snapshot.data!;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.grey[300],
                      child: ImgApi(
                        imageUrl:
                            'https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId}',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            restaurant.name,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown,
                            ),
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
                            'City: ${restaurant.city}',
                            style: GoogleFonts.openSans(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text('Address: ${restaurant.address}'),
                          SizedBox(height: 16),
                          Text(
                            'Categories: ${restaurant.categories.map((category) => category.name).join(', ')}',
                            style: GoogleFonts.openSans(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Rating: ${restaurant.rating}',
                            style: GoogleFonts.openSans(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown,
                            ),
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: Text('Menu:',
                                style: GoogleFonts.openSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.brown)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('data'),
                          Column(
                            children: restaurant.menus.foods.map((food) {
                              return Card(
                                // Atur atribut-atribut kartu sesuai kebutuhan
                                child: ListTile(
                                  leading: Icon(Icons.food_bank),
                                  title: Text(
                                    food.name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.brown,
                                    ),
                                  ),
                                  // Tambahkan atribut-atribut lainnya seperti subtitle, gambar, dll.
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: restaurant.menus.drinks.map((drink) {
                              return Card(
                                // Atur atribut-atribut kartu sesuai kebutuhan
                                child: ListTile(
                                  title: Text(
                                    drink.name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.brown,
                                    ),
                                  ),
                                  // Tambahkan atribut-atribut lainnya seperti subtitle, gambar, dll.
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Customer Reviews:',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: restaurant.customerReviews.map((review) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  '${review.name}: ${review.review} - ${review.date}',
                                  style: GoogleFonts.openSans(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
