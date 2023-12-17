import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restauran_app/data/data_source.dart';
import 'package:restauran_app/data/remote_model_detail.dart';
import 'package:restauran_app/error/404.dart';
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
              return NotFound(
                codeError: '500',
                message: 'An error occurred: ${snapshot.error}',
              );
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
                                  ' ${restaurant.categories.map((category) => category.name).join(', ')}'),
                              SizedBox(width: 5),
                              Text('${restaurant.rating}'),
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                              )
                            ],
                          ),
                          SizedBox(height: 20),
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
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.restaurant),
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
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.local_drink),
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
                              // Icon(Icons.plate)
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
                          Center(
                            child: Text(
                              'Customer Reviews:',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown,
                              ),
                            ),
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                            ),
                            itemCount: restaurant.customerReviews.length,
                            itemBuilder: (context, index) {
                              var review = restaurant.customerReviews[index];
                              return Card(
                                elevation: 3,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.comment),
                                      Text(
                                        '${review.name}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.brown,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '${review.review}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Date: ${review.date}',
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
