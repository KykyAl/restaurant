class RestaurantDataBase {
  String? name;
  String? id;
  String? address;
  String? city;
  String? pictureId;
  double? rating;

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
        rating: (json['rating'] as num?)
            ?.toDouble(), // Konversi rating menjadi double
        pictureId: json['pictureId'].toString());
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'address': address, 'pictureId': pictureId};
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'address': address, 'pictureId': pictureId};
  }
}
