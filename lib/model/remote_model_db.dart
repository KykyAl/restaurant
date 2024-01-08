import 'package:get/get.dart';

class RestaurantDataBase {
  final String id;
  final String name;
  final String address;
  final String city;
  final int pictureId;
  final double rating;
  RxBool isFavorite;

  RestaurantDataBase({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.rating,
    required this.pictureId,
    required this.isFavorite,
  });

  factory RestaurantDataBase.fromJson(Map<String, dynamic> json) {
    return RestaurantDataBase(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      pictureId: json['pictureId'],
      rating: json['rating']?.toDouble() ?? 0.0,
      isFavorite: (json['isFavorite'] as bool?)?.obs ?? false.obs,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'pictureId': pictureId,
      'isFavorite': isFavorite.value,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'pictureId': pictureId,
      'isFavorite': isFavorite.value,
    };
  }
}
