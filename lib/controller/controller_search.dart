import 'dart:developer';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restauran_app/data/data_source.dart';
import 'package:restauran_app/data/remote_model.dart';
import 'package:restauran_app/data/remote_model_detail.dart';
import 'package:restauran_app/data/remote_model_search.dart';
import 'package:restauran_app/helper/navigator_helper.dart';

class RestaurantSearchController extends GetxController {
  final NavigatorHelper navigatorHelper = NavigatorHelper();
  final RemoteDatasource restaurantApi = RemoteDatasource();
  RxString errorMessageDetail = ''.obs;
  RxBool isLoadingSearch = false.obs;
  RxList<RestaurantSearchModel> searchResults = <RestaurantSearchModel>[].obs;
  RxList<RestaurantModel> searchFoto = <RestaurantModel>[].obs;
  RxList<RestaurantDetailModel> searchDetail = <RestaurantDetailModel>[].obs;
  RxString searchQuery = ''.obs;
  RxList<RestaurantModel> listRestaurant = <RestaurantModel>[].obs;
  RxList<RestaurantModel> listDetailTaskSearch = <RestaurantModel>[].obs;
  Rx<TextEditingController> areaSearchTE = TextEditingController(text: '').obs;
  RxList<RestaurantModel>? restaurants = <RestaurantModel>[].obs;
  RxBool hasInternetConnection = true.obs;
  RxBool connectionStatus = false.obs;
  RxBool showPopup = false.obs;
  Rx<int> responseTime = 0.obs;
  Rx<Color> color = Colors.green.obs;
  Rx<IconData> icons = Icons.wifi.obs;
  RxBool isInternetConnected = true.obs;

  var isOnline = true.obs;

  @override
  void onInit() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      isOnline.value = (result != ConnectivityResult.none);
    });
    getListOfRestaurants();
    performSearch();
    super.onInit();
  }

  RxList<RestaurantModel> restaurantList = <RestaurantModel>[].obs;
  var isLoading = true.obs;
  var isError = false.obs;
  var errorMessage = ''.obs;

  void getListOfRestaurants() async {
    try {
      isLoading(true);
      var result = await restaurantApi.fetchRestaurantData([]);
      restaurantList.assignAll(result);
      isError(false);
    } catch (error) {
      isError(true);
    } finally {
      isLoading(false);
    }
  }

  void performSearch() async {
    if (searchQuery.isNotEmpty) {
      isLoadingSearch(true);

      try {
        // Mendapatkan hasil pencarian
        final results =
            await restaurantApi.searchRestaurants(searchQuery.value);

        // Mendapatkan data restoran berdasarkan ID
        final fotoResults = await restaurantApi
            .fetchRestaurantData(results.map((r) => r.id).toList());
        log('FOTO RESULT: ${fotoResults}');

        // Mendapatkan detail restoran
        final List<String?> restaurantIds = results.map((e) => e.id).toList();
        final List<RestaurantDetailModel> details = [];

        for (final restaurantId in restaurantIds) {
          final detail = await restaurantApi.getRestaurantDetail(restaurantId!);
          details.add(detail);
        }

        searchResults.assignAll(results);
        searchFoto.assignAll(fotoResults);
        log('FOTO RESULT: ${searchFoto}');
        searchDetail.assignAll(details);
      } catch (e) {
        print('Error searching restaurants: $e');
      } finally {
        isLoadingSearch(false);
      }
    }
  }
}
