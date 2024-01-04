class RestaurantDataBase {
  final String name;
  final String id;
  final String address;
  final String city;
  final double rating;
  final int pictureId;

  RestaurantDataBase({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.rating,
    required this.pictureId,
  });

  factory RestaurantDataBase.fromJson(Map<String, dynamic> json) {
    return RestaurantDataBase(
        id: json['id'],
        name: json['name'],
        address: json['address'],
        city: json['city'],
        rating: json['rating'],
        pictureId: json['pictureId']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
    };
  }
}
