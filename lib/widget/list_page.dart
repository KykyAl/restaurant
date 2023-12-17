import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restauran_app/controller/controller.dart';
import 'package:restauran_app/data/data_source.dart';
import 'package:restauran_app/data/remote_model.dart';
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
            'Nongki',
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
                child: const Text(
                  ' Tempat TerHits',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<RestaurantModel>>(
                  future: restaurantApi.getListOfRestaurants(context,[]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                     return SnackBar(
  content: Container( 
    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    decoration: BoxDecoration(
      color: Colors.grey[800], // Choose a suitable background color
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: Row(
      children: [
        Icon(
          Icons.error_outline,
          color: Colors.red,
          size: 28.0,
        ),
        SizedBox(width: 12.0),
        Expanded(
          child: Text(
            'Oops! No internet connection. Please check your network.',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  ),
);

                    } else {
                      // Tampilkan data restoran
                      final List<RestaurantModel> restaurants = snapshot.data!;
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          childAspectRatio:
                              0.7, // Sesuaikan dengan preferensi Anda
                        ),
                        itemCount: restaurants.length,
                        itemBuilder: (context, index) {
                          return _buildArticleItem(context, restaurants[index]);
                        },
                      );
                    }
                  },
                ),
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
                    'https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId}',
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
                color: Colors.white, // Sesuaikan dengan warna yang diinginkan
              ),
            ),
            Text(
              'Khas ${restaurant.city}',
              style: GoogleFonts.openSans(
                fontSize: 14,
                color: Colors.white, // Sesuaikan dengan warna yang diinginkan
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
                    color:
                        Colors.white, // Sesuaikan dengan warna yang diinginkan
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
                    color:
                        Colors.white, // Sesuaikan dengan warna yang diinginkan
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
//  ListTile(
//         contentPadding:
//             const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//         leading: SizedBox(
//           width: 56.0,
//           child:
//         title: Text(restaurant.name),
//         subtitle: Text(restaurant.city),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Icons.star,
//                 color: Colors.yellow,
//                 size: 18), // Ganti dengan ikon yang sesuai
//             SizedBox(width: 4),
//             Text(
//               '${restaurant.rating}',
//               style: TextStyle(fontSize: 16),
//             )
//           ],
//         ),
//         onTap: () {
//         },
//       ),
//     );

class ImgApi extends StatelessWidget {
  final String imageUrl;

  const ImgApi({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          BorderRadius.circular(5.0), // Sesuaikan dengan preferensi Anda

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
