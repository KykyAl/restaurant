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

    // Set string pencarian ke dalam controller
    searchController.searchQuery.value = testRestaurantName;

    print(
        'Carii Restoran Sebelum Pencarian: ${searchController.searchResults}');

    await searchController.performSearch();

    // Periksa apakah ada restoran dengan nama yang diharapkan
    var result = searchController.searchResults
        .any((restaurant) => restaurant.name == testRestaurantName);

    expect(result, false);
  });

  test('should fetch restaurant detail and contain specific information',
      () async {
    var detailController = RestaurantDetailController();
    var testRestaurantId = 'Melting Pot';

    await detailController.fetchRestaurantDetail(testRestaurantId);
    final restaurant = detailController.restaurantDetail[0];
    var result = restaurant.id == testRestaurantId;

    expect(result, true);
  });
}
