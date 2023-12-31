import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restauran_app/model/remote_model.dart';
import 'package:restauran_app/model/remote_model_detail.dart';
import 'package:restauran_app/model/remote_model_detail_category.dart';
import 'package:restauran_app/model/remote_model_detail_customeriview.dart';
import 'package:restauran_app/model/remote_model_detail_menu_item.dart';
import 'package:restauran_app/model/remote_model_detail_menus.dart';
import 'package:restauran_app/model/remote_model_search.dart';

class RemoteDatasource {
  final _BASE_URL = "https://restaurant-api.dicoding.dev/";

  Future<List<RestaurantModel>> fetchRestaurantData(
      http.Client client, List<String?> list) async {
    try {
      final response = await client.get(Uri.parse('$_BASE_URL/list'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> restaurantsData = data['restaurants'];
        return restaurantsData.map((restaurant) {
          return RestaurantModel.fromJson(restaurant);
        }).toList();
      } else {
        throw Exception(
            'Failed to load restaurant data: ${response.statusCode}');
      }
    } catch (e) {
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
            customerReviews:
                (restaurantData['customerReviews'] as List<dynamic>)
                    .map((review) => CustomerReview(
                          name: review['name'],
                          review: review['review'],
                          date: review['date'],
                        ))
                    .toList(),
            isFavorite: false);
      } else {
        throw Exception('pembaruan data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<RestaurantSearchModel>> searchRestaurants(String query) async {
    final response = await http.get(Uri.parse('$_BASE_URL/search?q=$query'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
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
