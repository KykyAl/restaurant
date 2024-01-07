import 'dart:convert';

import 'package:http/http.dart' as http;

class RestaurantModel {
  String? id;
  String? name;
  String? description;
  String? pictureId;
  String? city;
  double rating;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      pictureId: json['pictureId'],
      city: json['city'],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  static Future<RestaurantModel> fromJsonAsync(http.Client client) async {
    final response =
        await client.get(Uri.parse('https://restaurant-api.dicoding.dev/'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return RestaurantModel(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        pictureId: json['pictureId'],
        city: json['city'],
        rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      );
    } else {
      throw Exception('Failed to load restaurant data');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = id;
    data["name"] = name;
    data["description"] = description;
    data["pictureId"] = pictureId;
    data["city"] = city;
    data["rating"] = rating;

    return data;
  }
}
