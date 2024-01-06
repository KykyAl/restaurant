import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restauran_app/controller/controller_detail.dart';
import 'package:restauran_app/controller/controller_page.dart';
import 'package:restauran_app/controller/controller_search.dart';

void main() {
  setUp(() {
    WidgetsFlutterBinding.ensureInitialized();
  });
  test('seharusnya mengambil dan mengandung restoran baru dalam daftar',
      () async {
    var restaurantController = RestaurantController();
    var testRestaurantName = 'Melting Pot';

    await restaurantController.getListOfRestaurants();

    print('Daftar Restoran: ${restaurantController.restaurantList}');

    var result = restaurantController.restaurantList
        .any((restaurant) => restaurant.name == testRestaurantName);

    print('Hasil Uji: $result');

    expect(result, true);
  });
  test('should perform search and contain new restaurant in the list',
      () async {
    var searchController = RestaurantSearchController();
    var testRestaurantName = 'Kafe';

    searchController.searchQuery.value = testRestaurantName;

    print(
        'Carii Restoran Sebelum Pencarian: ${searchController.searchResults}');

    await searchController.performSearch();

    var result = searchController.searchResults
        .any((restaurant) => restaurant.name == testRestaurantName);

    expect(result, false);
  });

  test('should fetch restaurant detail and contain specific information',
      () async {
    var detailController = RestaurantDetailController();
    var testRestaurantId = 'fnfn8mytkpmkfw1e867';

    await detailController.fetchRestaurantDetail(testRestaurantId);
    var result = detailController.restaurantDetail
        .any((element) => element.id == testRestaurantId);
    expect(result, true);
  });
}
