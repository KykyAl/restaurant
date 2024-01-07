import 'dart:convert';

class ReviewModel {
  String? name;
  String? review;
  String? date;

  ReviewModel({
    required this.name,
    required this.review,
    required this.date,
  });

  factory ReviewModel.fromRawJson(String str) =>
      ReviewModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
        name: json["name"],
        review: json["review"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "review": review,
        "date": date,
      };
}
