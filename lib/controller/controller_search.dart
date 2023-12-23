import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restauran_app/data/data_source.dart';
import 'package:restauran_app/data/remote_model.dart';
import 'package:restauran_app/data/remote_model_detail.dart';
import 'package:restauran_app/data/remote_model_search.dart';

class RestaurantSearchController extends GetxController {
  final RemoteDatasource restaurantApi = RemoteDatasource();

  RxBool isLoadingSearch = false.obs;
  RxList<RestaurantSearchModel> searchResults = <RestaurantSearchModel>[].obs;
  RxList<RestaurantModel> searchFoto = <RestaurantModel>[].obs;
  RxList<RestaurantDetailModel> searchDetail = <RestaurantDetailModel>[].obs;
  RxString searchQuery = ''.obs;
  var isError = false.obs;
  RxBool isInternetConnected = true.obs;
  RxBool isLoading = true.obs;

  void performSearch() async {
    if (searchQuery.isNotEmpty) {
      isLoadingSearch.value = true;
      try {
        final results =
            await restaurantApi.searchRestaurants(searchQuery.value);
        final fotoResults = await restaurantApi
            .fetchRestaurantData(results.map((r) => r.id).toList());
        final List<String?> restaurantIds = results.map((e) => e.id).toList();
        final List<RestaurantDetailModel> details = [];

        for (final restaurantId in restaurantIds) {
          final detail = await restaurantApi.getRestaurantDetail(restaurantId!);
          details.add(detail);
        }

        searchResults.assignAll(results);
        searchFoto.assignAll(fotoResults);
        searchDetail.assignAll(details);
      } catch (e) {
        print('Error searching restaurants: $e');
      } finally {
        isLoadingSearch(false);
      }
    }
  }

  dialog() {
    try {
      return showModalBottomSheet(
        useRootNavigator: false,
        enableDrag: false,
        context: Get.context!,
        builder: (context) => Container(
          height: 300,
          padding: EdgeInsets.all(30),
          color: Colors.white,
          child: Column(
            children: [
              Icon(
                Icons.wifi_off_rounded,
                size: 30,
              ),
              Text(
                "Mohon maaf anda sedang tidak terhubung dengan internet",
                textAlign: TextAlign.center,
              ),
              Divider(),
              Expanded(
                child: SizedBox(
                  height: 20,
                ),
              ),
              ElevatedButton(
                onPressed: () => Get.back(),
                child: Text("Get Back"),
              ),
              Expanded(
                child: SizedBox(
                  height: 20,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    Icons.cloud_off_rounded,
                  ),
                  Expanded(
                    child: SizedBox(child: Divider()),
                  ),
                  RotatedBox(
                    quarterTurns: -2,
                    child: Icon(
                      Icons.arrow_back_ios_new_sharp,
                      size: 15,
                    ),
                  ),
                  Icon(
                    Icons.phone_iphone_rounded,
                  )
                ],
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
}
