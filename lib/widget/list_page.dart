import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restauran_app/controller/controller.dart';
import 'package:restauran_app/data/data_source.dart';
import 'package:restauran_app/data/remote_model.dart';
import 'package:restauran_app/error/404.dart';
import 'package:restauran_app/helper/navigator_helper.dart';

class ListPage extends StatelessWidget {
  final NavigatorHelper navigatorHelper = NavigatorHelper();
  final controller = Get.find<RestaurantController>();
  final RemoteDatasource restaurantApi = RemoteDatasource();

  ListPage({Key? key}) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown,
          title: const Text(
            'Restauran Apps',
            style: TextStyle(
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
                  child: Icon(
                    Icons.search,
                    size: 30,
                    color: Colors.white,
                  )),
            ),
          ],
        ),
        body: Container(
          color: Color.fromARGB(230, 34, 33, 33),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(left: 20, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Hitsss',
                          style: GoogleFonts.oswald(
                            fontSize: 25,
                            color: Colors.white,
                          )),
                      Icon(Icons.thunderstorm_outlined)
                    ],
                  )),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.isTrue) {
                    return Center(child: CircularProgressIndicator());
                  } else if (controller.isError.isTrue) {
                    return Center(
                      child: Text('Error: ${controller.errorMessage.value}'),
                    );
                  } else if (!controller.isOnline.value) {
                    return Center(
                      child: Text('Tidak ada koneksi internet'),
                    );
                  } else if (controller.restaurantList.isEmpty) {
                    return NotFound(
                      codeError: '404',
                      message: 'Restaurants tidak ditemukan',
                    );
                  } else {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: controller.restaurantList.length,
                      itemBuilder: (context, index) {
                        return _buildArticleItem(
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
        ),
      ),
    );
  }

  Widget _buildArticleItem(BuildContext context, RestaurantModel restaurant) {
    return InkWell(
      onTap: () {
        Get.toNamed(navigatorHelper.detailPage, arguments: restaurant.id);
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
              child: ImgApi(
                imageUrl:
                    'https://restaurant-api.dicoding.dev/images/large/${restaurant.pictureId}',
              ),
            ),
            Divider(
              thickness: 1,
              height: 5,
              color: Colors.black,
            ),
            Text(
              restaurant.name,
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

class ImgApi extends StatelessWidget {
  final String imageUrl;

  const ImgApi({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: Image.network(
        imageUrl,
        width: double.infinity,
        height: 190.0,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Icon(Icons.error),
        ),
      ),
    );
  }
}
