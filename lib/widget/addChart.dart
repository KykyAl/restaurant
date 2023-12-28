class ShoppingCart {
  List<CartItem> items = [];
}

class CartItem {
  String name;
  double price;

  CartItem({required this.name, required this.price});
}
