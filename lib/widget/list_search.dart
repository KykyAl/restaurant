import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restauran_app/data/data_source.dart';
import 'package:restauran_app/data/remote_model.dart';
import 'package:restauran_app/data/remote_model_detail.dart';
import 'package:restauran_app/data/remote_model_search.dart';
import 'package:restauran_app/helper/navigator_helper.dart';
import 'package:restauran_app/main.dart';
import 'package:restauran_app/widget/list_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final RemoteDatasource restaurantApi = RemoteDatasource();
  final NavigatorHelper navigatorHelper = NavigatorHelper();

  bool _isLoading = false;

  List<RestaurantSearchModel> _searchResults = [];
  List<RestaurantModel> _searchFoto = [];
  List<RestaurantDetailModel> _searchDetail = [];

 void _performSearch(String query) async {
  if (query.isNotEmpty) {
    setState(() {
      _isLoading = true; 
    });

    try {
      final results = await restaurantApi.searchRestaurants(query);
      final fotoResults =
          await restaurantApi.getListOfRestaurants ( context,results.map((r) => r.id).toList());
      final List<String?> restaurantIds = results.map((e) => e.id).toList();
      final List<RestaurantDetailModel> details = [];

      for (final restaurantId in restaurantIds) {
        final detail = await restaurantApi.getRestaurantDetail(restaurantId!);
        details.add(detail);
      }

      setState(() {
        _searchResults = results;
        _searchFoto = fotoResults;
        _searchDetail = details;
        _isLoading = false; 
      });
    } catch (e) {
      print('Error searching restaurants: $e');
      setState(() {
        _isLoading = false; 
      });
    }
  }
}
  


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: const Text('Pencarian',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            backgroundColor: Colors.brown,
          ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
               TextField(
        controller: _searchController,
        onChanged: (query) {
          _performSearch(query);
        },
        decoration: InputDecoration(
          labelText: 'Cari',
        ),
      ),
      SizedBox(height: 16.0),
       _buildSearchResults(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
   if (_isLoading) {
    // Show a loading indicator while performing the search
    return Center(
      child: CircularProgressIndicator(),
    );
  } else if (_searchResults.isEmpty) {
   return Text(
      'Tidak ditemukan hasil.',
      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
    );
  } else {
    return Expanded(
      child: ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final restaurantFoto = _searchFoto[index];
          final restaurantList = _searchResults[index];
          final restauranDetail = _searchDetail[index];


          return Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
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
                      'https://restaurant-api.dicoding.dev/images/medium/${restaurantFoto.pictureId}',
                ),
              ),
              title: Text(
                restaurantList.name.toString(),
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column( crossAxisAlignment: CrossAxisAlignment.start,
                children: [ 
                  Text( 'Kategori : ${
                    restauranDetail.categories.map((category) => category.name).join(', ')}',
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                  SizedBox(height: 8,),
                  
                      Text('Menu: ${restauranDetail.menus.foods.map((food) => food.name).join(', ')}'),
      
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
                  arguments: restaurantList.id.toString(),
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
