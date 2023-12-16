import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restauran_app/data/data_source.dart';
import 'package:restauran_app/data/remote_model.dart';
import 'package:restauran_app/data/remote_model_search.dart';
import 'package:restauran_app/helper/navigator_helper.dart';
import 'package:restauran_app/list_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final RemoteDatasource restaurantApi = RemoteDatasource();
  final NavigatorHelper navigatorHelper = NavigatorHelper();

  List<RestaurantSearchModel> _searchResults = [];
  List<RestaurantModel> _searcFoto = [];

  void _performSearch() async {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      try {
        final results = await restaurantApi.searchRestaurants(query);
        final fotoResults = await restaurantApi
            .getListOfRestaurants(results.map((r) => r.id).toList());

        setState(() {
          _searchResults = results;
          _searcFoto = fotoResults;
        });
      } catch (e) {
        // Tangani kesalahan, misalnya tampilkan snackbar atau pesan error
        print('Error searching restaurants: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cari Restoran',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Cari',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _performSearch,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            _buildSearchResults(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Text('Tidak ditemukan hasil.');
    } else {
      return Expanded(
        child: ListView.builder(
          itemCount: _searchResults.length,
          itemBuilder: (context, index) {
            final restaurantFoto = _searcFoto[index];
            final restaurantList = _searchResults[index];
            log('list ${restaurantList.toJson()}');
            return ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
              leading: SizedBox(
                width: 56.0,
                child: ImgApi(
                  imageUrl:
                      'https://restaurant-api.dicoding.dev/images/medium/${restaurantFoto.pictureId}',
                ),
              ),
              title: Text(restaurantList.name.toString()),
              subtitle: Text(restaurantList.city.toString()),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star,
                      color: Colors.yellow,
                      size: 18), // Ganti dengan ikon yang sesuai
                  SizedBox(width: 4),
                  Text(
                    '${restaurantList.rating}',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              onTap: () {
                Get.toNamed(navigatorHelper.detailPage,
                    arguments: restaurantList.id.toString());
              },
            );
          },
        ),
      );
    }
  }
}
