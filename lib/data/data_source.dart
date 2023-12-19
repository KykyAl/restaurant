import 'dart:convert';
import 'dart:developer';

import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:restauran_app/data/remote_model.dart';
import 'package:restauran_app/data/remote_model_detail.dart';
import 'package:restauran_app/data/remote_model_search.dart';

class RemoteDatasource {
  final _BASE_URL = "https://restaurant-api.dicoding.dev/";

  Future<http.Response> listRestorant({RestaurantModel? body}) async {
    try {
      final response = await http.post(
        Uri.parse("$_BASE_URL"),
        body: jsonEncode(body!.toJson()),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<RestaurantModel>> getListOfRestaurants(List<String?> list) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      // Tidak ada koneksi internet, return pesan kesalahan
      print('No internet connection');
      throw Exception('No internet connection');
    }

    try {
      final response = await http.get(Uri.parse('$_BASE_URL/list'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> restaurantsData = data['restaurants'];
        return restaurantsData.map((restaurant) {
          return RestaurantModel.fromJson(restaurant);
        }).toList();
      } else {
        // Gagal mendapatkan data, return pesan kesalahan
        print('Error: ${response.statusCode}');
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Gagal mendapatkan data, return pesan kesalahan
      print('Error: $e');
      throw e;
    }
  }

  Future<RestaurantDetailModel> getRestaurantDetail(String restaurantId) async {
    final url = '$_BASE_URL/detail/$restaurantId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final restaurantData = data['restaurant'];
        return RestaurantDetailModel(
          id: restaurantData['id'],
          name: restaurantData['name'],
          description: restaurantData['description'],
          city: restaurantData['city'],
          address: restaurantData['address'],
          pictureId: restaurantData['pictureId'],
          categories: (restaurantData['categories'] as List<dynamic>)
              .map((category) => Category(name: category['name']))
              .toList(),
          menus: Menus(
            foods: (restaurantData['menus']['foods'] as List<dynamic>)
                .map((food) => MenuItem(name: food['name']))
                .toList(),
            drinks: (restaurantData['menus']['drinks'] as List<dynamic>)
                .map((drink) => MenuItem(name: drink['name']))
                .toList(),
          ),
          rating: restaurantData['rating'].toDouble(),
          customerReviews: (restaurantData['customerReviews'] as List<dynamic>)
              .map((review) => CustomerReview(
                    name: review['name'],
                    review: review['review'],
                    date: review['date'],
                  ))
              .toList(),
        );
      } else {
        throw Exception('No internet connection');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<RestaurantSearchModel>> searchRestaurants(String query) async {
    final response = await http.get(Uri.parse('$_BASE_URL/search?q=$query'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      log("search${data}");
      if (!data['error']) {
        final List<dynamic> restaurantData = data['restaurants'];
        return restaurantData
            .map((json) => RestaurantSearchModel.fromJson(json))
            .toList();
      } else {
        throw Exception('No internet connection');
      }
    } else {
      throw Exception('No internet connection');
    }
  }
}
