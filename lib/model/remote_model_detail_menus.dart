import 'package:restauran_app/model/remote_model_detail_menu_item.dart';

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
