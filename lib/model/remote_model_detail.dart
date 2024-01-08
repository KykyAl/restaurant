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

class Category {
  final String name;

  Category({required this.name});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'],
    );
  }
}

class Menus {
  final List<MenuItem> foods;
  final List<MenuItem> drinks;

  Menus({required this.foods, required this.drinks});

  Map<String, dynamic> toJson() {
    return {
      'foods': foods.map((food) => food.toJson()).toList(),
      'drinks': drinks.map((drink) => drink.toJson()).toList(),
    };
  }

  factory Menus.fromJson(Map<String, dynamic> json) {
    return Menus(
      foods: (json['foods'] as List<dynamic>)
          .map((food) => MenuItem.fromJson(food))
          .toList(),
      drinks: (json['drinks'] as List<dynamic>)
          .map((drink) => MenuItem.fromJson(drink))
          .toList(),
    );
  }
}

class MenuItem {
  final String name;

  MenuItem({required this.name});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      name: json['name'],
    );
  }
}

class CustomerReview {
  final String name;
  final String review;
  final String date;

  CustomerReview({
    required this.name,
    required this.review,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'review': review,
      'date': date,
    };
  }

  factory CustomerReview.fromJson(Map<String, dynamic> json) {
    return CustomerReview(
      name: json['name'],
      review: json['review'],
      date: json['date'],
    );
  }
}
