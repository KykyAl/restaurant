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

  // Inside RestaurantDataBase class

  factory RestaurantDataBase.fromJson(Map<String, dynamic> json) {
    return RestaurantDataBase(
      id: json['id'].toString(), // Convert id to String
      name: json['name'] ?? '', // Use empty string if name is null
      address: json['address'] ?? '', // Use empty string if address is null
      city: json['city'] ?? '', // Use empty string if city is null
      pictureId: json['pictureId'], // Use empty string if pictureId is null
      rating: json['rating']?.toDouble() ??
          0.0, // Convert rating to double or use 0.0 if null
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
