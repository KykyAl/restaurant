import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restauran_app/model/remote_model.dart';

void main() {
  group('Pemrosesan JSON pada RestaurantModel', () {
    test('Seharusnya memparsing JSON dengan benar dengan isFavorite boolean',
        () async {
      final Map<String, dynamic> json = {
        'id': '1',
        'name': 'Resto Test',
        'address': '123 Main St',
        'city': 'Test City',
        'pictureId': 'test_picture_id',
        'rating': 4.5,
        'isFavorite': true,
      };

      final client = MockClient((request) async {
        return http.Response(jsonEncode(json), 200);
      });

      final RestaurantModel restaurant =
          await RestaurantModel.fromJsonAsync(client);

      expect(restaurant.id, '1');
      expect(restaurant.name, 'Resto Test');
      expect(restaurant.city, 'Test City');
      expect(restaurant.pictureId, 'test_picture_id');
      expect(restaurant.rating, 4.5);
    });

    test('Seharusnya memparsing JSON dengan benar dengan isFavorite null',
        () async {
      final Map<String, dynamic> json = {
        'id': '2',
        'name': 'sebagian Resto',
        'address': '456 ',
        'city': 'sebagian City',
        'pictureId': 'sebagian_picture_id',
        'rating': 3.8,
        'isFavorite': null,
      };

      final client = MockClient((request) async {
        return http.Response(jsonEncode(json), 200);
      });

      final RestaurantModel restaurant =
          await RestaurantModel.fromJsonAsync(client);

      expect(restaurant.id, '2');
      expect(restaurant.name, 'sebagian Resto');
      expect(restaurant.city, 'sebagian City');
      expect(restaurant.pictureId, 'sebagian_picture_id');
      expect(restaurant.rating, 3.8);
    });
  });
}
