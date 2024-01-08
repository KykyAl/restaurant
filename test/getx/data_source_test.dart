import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restauran_app/data/data_source.dart';
import 'package:restauran_app/model/remote_model.dart';

void main() {
  group('RemoteDatasource', () {
    test(
        'ambil RestaurantData harusnya mengurai JSON dengan benar tanpa internet',
        () async {
      final Map<String, dynamic> jsonResponse = {
        'restaurants': [
          {
            'id': '1',
            'name': 'Resto Test',
            'address': '123 Main St',
            'city': 'Test City',
            'pictureId': 'test_picture_id',
            'rating': 4.5,
            'isFavorite': true,
          },
          {
            'id': '2',
            'name': 'sebagian Resto',
            'address': '456 ',
            'city': 'sebagian City',
            'pictureId': 'sebagian_picture_id',
            'rating': 3.8,
            'isFavorite': null,
          },
        ]
      };

      final client = MockClient((request) async {
        return http.Response(jsonEncode(jsonResponse), 200);
      });

      final remoteDatasource = RemoteDatasource();
      final List<RestaurantModel> restaurants =
          await remoteDatasource.fetchRestaurantData(client, []);

      expect(restaurants.length, 2);

      expect(restaurants[0].id, '1');
      expect(restaurants[0].name, 'Resto Test');
      expect(restaurants[0].city, 'Test City');
      expect(restaurants[0].pictureId, 'test_picture_id');
      expect(restaurants[0].rating, 4.5);

      expect(restaurants[1].id, '2');
      expect(restaurants[1].name, 'sebagian Resto');
      expect(restaurants[1].city, 'sebagian City');
      expect(restaurants[1].pictureId, 'sebagian_picture_id');
      expect(restaurants[1].rating, 3.8);
    });
  });
}
