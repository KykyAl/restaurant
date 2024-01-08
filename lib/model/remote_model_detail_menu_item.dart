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
