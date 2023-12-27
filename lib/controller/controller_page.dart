import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restauran_app/data/data_source.dart';
import 'package:restauran_app/data/remote_model.dart';
import 'package:restauran_app/data/remote_model_detail.dart';
import 'package:restauran_app/data/remote_model_search.dart';
import 'package:restauran_app/helper/navigator_helper.dart';

class RestaurantController extends GetxController {
  final NavigatorHelper navigatorHelper = NavigatorHelper();
  final RemoteDatasource restaurantApi = RemoteDatasource();
  final Connectivity _connectivity = Connectivity();
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

  final RxBool isOnlineRx = true.obs;

  @override
  void onInit() {
    super.onInit();
    checkConnectionStatus();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    ever(isOnlineRx, (_) {
      if (!isOnlineRx.value) {
        showPopup.value = true;
        dialog();
      }
    });
    getListOfRestaurants();
    performSearch();
  }

  void checkConnectionStatus() async {
    try {
      var response =
          await GetConnect().get('https://restaurant-api.dicoding.dev/list');
      isOnlineRx.value = response.statusCode == 200;
    } catch (e) {
      isOnlineRx.value = false;
    }
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

  void _updateConnectionStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      connectionStatus.value = false;
      if (showPopup.isFalse) {
        showPopup.value = true;
        dialog();
      }
      icons.value = Icons.wifi_1_bar;
      color.value = Colors.red;
    } else {
      connectionStatus.value = true;
      showPopup.value = false;
      Get.back();
    }
  }

  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  void loadData() async {
    try {
      isLoading.value = true;

      isOnline.value = await checkInternetConnectivity();

      if (isOnline.value) {
        restaurantList.assignAll(await restaurantApi.fetchRestaurantData([]));
      }
    } catch (e) {
      print('Error loading data: $e');

      Get.snackbar(
        'Error',
        'Failed to load data. Please check your internet connection.',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
      if (!isLoading.value && isOnline.value) {
        loadData();
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

  void performSearch() async {
    if (searchQuery.isNotEmpty) {
      isLoadingSearch(true);

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
}
