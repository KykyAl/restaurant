class RestaurantSearchModel {
  String? id;
  String? name;
  String? description;
  String? pictureId;
  String? city;
  double? rating;
  RestaurantSearchModel({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    this.rating = 0.0,
  });

  RestaurantSearchModel.fromJson(dynamic json) {
    id = json["id"];
    name = json["name"];
    description = json["description"];
    pictureId = json["pictureId"];
    city = json["city"];
    rating = (json["rating"] ?? 0.0).toDouble();
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
