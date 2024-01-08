import 'package:restauran_app/model/remote_model_detail_category.dart';
import 'package:restauran_app/model/remote_model_detail_customeriview.dart';
import 'package:restauran_app/model/remote_model_detail_menus.dart';

class RestaurantDetailModel {
  final String id;
  final String name;
  final String description;
  final String city;
  final String address;
  final String pictureId;
  final List<Category> categories;
  final Menus menus;
  final double rating;
  final List<CustomerReview> customerReviews;
  bool isFavorite;

  RestaurantDetailModel({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.categories,
    required this.menus,
    required this.rating,
    required this.customerReviews,
    required this.isFavorite,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'city': city,
      'address': address,
      'pictureId': pictureId,
      'categories': categories.map((category) => category.toJson()).toList(),
      'menus': menus.toJson(),
      'rating': rating,
      'customerReviews':
          customerReviews.map((review) => review.toJson()).toList(),
      'isFavorite': isFavorite, // Tambahkan isFavorite ke JSON
    };
  }

  factory RestaurantDetailModel.fromJson(Map<String, dynamic> json) {
    return RestaurantDetailModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      city: json['city'],
      address: json['address'],
      pictureId: json['pictureId'],
      categories: (json['categories'] as List<dynamic>)
          .map((category) => Category.fromJson(category))
          .toList(),
      menus: Menus.fromJson(json['menus']),
      rating: json['rating'],
      customerReviews: (json['customerReviews'] as List<dynamic>)
          .map((review) => CustomerReview.fromJson(review))
          .toList(),
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }
}
