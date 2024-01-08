class RestaurantNotifModel {
  final String id;
  final String name;
  final String city;
  final String description;
  final String pictureId;
  final double rating;

  RestaurantNotifModel({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });
}
