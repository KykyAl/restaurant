import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restauran_app/database/db_helper.dart';
import 'package:restauran_app/model/remote_model_db.dart';
import 'package:restauran_app/model/remote_model_detail.dart';

class FavoriteListController extends GetxController {
  RxList<RestaurantDataBase> favoriteRestaurants = <RestaurantDataBase>[].obs;
  Rx<RestaurantDetailModel?> restaurantDetail =
      Rx<RestaurantDetailModel?>(null);

  @override
  void onInit() {
    super.onInit();
    loadFavoriteRestaurants();
  }

  refreshFavoriteStatus(String restaurantId) async {
    final isFavoriteNow =
        await DatabaseHelper.isRestaurantInFavorites(restaurantId);
    restaurantDetail.value?.isFavorite = isFavoriteNow;
  }

  Future<void> loadFavoriteRestaurants() async {
    await DatabaseHelper.database();
    final favorites = await DatabaseHelper.getFavoriteRestaurants();

    favoriteRestaurants.assignAll(
      favorites.map((map) => RestaurantDataBase.fromJson(map)),
    );
    print("Favorite restaurants: $favoriteRestaurants");
  }

  Future<bool?> _showConfirmationDialog(BuildContext context,
      String restaurantName, bool isCurrentlyFavorite) async {
    return showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Toggle Favorite'),
          content: Text(
            isCurrentlyFavorite
                ? 'Remove $restaurantName from favorites?'
                : 'Add $restaurantName to favorites?',
            style: TextStyle(color: Colors.green),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(isCurrentlyFavorite ? 'Remove' : 'Add'),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _showRemoveConfirmationDialog(
      BuildContext context, String restaurantName) async {
    return showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove Restaurant'),
          content: Text(
            'Are you sure you want to remove $restaurantName from favorites?',
            style: TextStyle(color: Colors.red),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  Future<void> toggleFavorite(String restaurantId) async {
    final restaurant = restaurantDetail.value;
    if (restaurant != null) {
      final isCurrentlyFavorite =
          await DatabaseHelper.isRestaurantInFavorites(restaurantId);

      if (isCurrentlyFavorite) {
        final confirmed = await _showRemoveConfirmationDialog(
            Get.overlayContext!, restaurant.name);

        if (confirmed != null && confirmed) {
          await DatabaseHelper.deleteFavoriteRestaurant(restaurantId);
          refreshFavoriteStatus(restaurantId);
        }
      } else {
        final confirmed = await _showConfirmationDialog(
            Get.overlayContext!, restaurant.name, isCurrentlyFavorite);

        if (confirmed != null && confirmed) {
          await DatabaseHelper.addFavoriteRestaurant(
            id: restaurant.id,
            name: restaurant.name,
            address: restaurant.address,
            city: restaurant.city,
            description: restaurant.description,
            pictureId: restaurant.pictureId,
            rating: restaurant.rating,
          );
          restaurant.isFavorite = true;
          refreshFavoriteStatus(restaurantId);
        }
      }
    }
  }

  Future<void> setRestaurantDetail(RestaurantDetailModel restaurant) async {
    restaurantDetail.value = restaurant;
    await toggleFavorite(restaurant.id);
  }

  Future<void> removeFavoriteRestaurant(String restaurantId) async {
    try {
      await DatabaseHelper.deleteFavoriteRestaurant(restaurantId);
      refreshFavoriteStatus(restaurantId);
    } catch (e) {
      print('Error removing restaurant from favorites: $e');
    }
  }

  Future<bool?> showConfirmationDialogDelete(
      BuildContext context, String restaurantName) async {
    return showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove Restaurant'),
          content: Text(
              'Are you sure you want to remove $restaurantName from favorites?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Remove'),
            ),
          ],
        );
      },
    );
  }
}
