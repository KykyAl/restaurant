import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restauran_app/controller/controller_search.dart';
import 'package:restauran_app/data/data_source.dart';
import 'package:restauran_app/helper/navigator_helper.dart';
import 'package:restauran_app/widget/list_page.dart';

class SearchPage extends GetView<RestaurantSearchController> {
  final RemoteDatasource restaurantApi = RemoteDatasource();
  final NavigatorHelper navigatorHelper = NavigatorHelper();
  final searchController = Get.find<RestaurantSearchController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false, // Atau true, sesuai kebutuhan

        appBar: AppBar(
          title: Text(
            'Pencarian',
            style: GoogleFonts.abrilFatface(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.brown,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: TextField(
                    onChanged: (query) {
                      searchController.searchQuery.value = query;
                      searchController.performSearch();
                    },
                    style: TextStyle(fontSize: 14.0),
                    decoration: InputDecoration(
                      labelText: 'Cari....',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.05,
                        vertical: MediaQuery.of(context).size.height * 0.02,
                      ),
                    ),
                  )),
              SizedBox(height: 10.0),
              Obx(() => _buildSearchResults(searchController)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults(RestaurantSearchController searchController) {
    if (!searchController.isInternetConnected.value) {
      return Center(
        child: Text('Tidak ada koneksi internet'),
      );
    } else if (searchController.isLoadingSearch.value) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      final searchResults = searchController.searchResults;
      if (searchResults.isEmpty) {
        return Center(
          child: Text('Tidak ditemukan'),
        );
      }

      return Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: searchController.searchResults.length,
          itemBuilder: (context, index) {
            // final restaurantFoto = searchController.searchFoto[index];
            final restaurantList = searchController.searchResults[index];
            final restauranDetail = searchController.searchDetail[index];
            return Container(
              margin: EdgeInsets.symmetric(
                vertical: 8.0,
              ),
              padding: EdgeInsets.all(16.0),
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
                leading: SizedBox(
                  width: 86.0,
                  child: ImgApi(
                    imageUrl:
                        'https://restaurant-api.dicoding.dev/images/large/${restauranDetail.pictureId}',
                  ),
                ),
                title: Text(
                  restaurantList.name.toString(),
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kategori : ${restauranDetail.categories.map((category) => category.name).join(', ')}',
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                        'Menu: ${restauranDetail.menus.foods.map((food) => food.name).join(', ')}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 18,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '${restaurantList.rating}',
                      style: GoogleFonts.poppins(fontSize: 15),
                    ),
                  ],
                ),
                onTap: () {
                  Get.toNamed(
                    navigatorHelper.detailPage,
                    arguments: {"id": restaurantList.id},
                  );
                },
              ),
            );
          },
        ),
      );
    }
  }
}
