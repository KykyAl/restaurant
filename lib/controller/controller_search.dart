import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:restauran_app/data/data_source.dart';
import 'package:restauran_app/error/404.dart';
import 'package:restauran_app/helper/navigator_helper.dart';
import 'package:restauran_app/model/remote_model.dart';
import 'package:restauran_app/model/remote_model_detail.dart';
import 'package:restauran_app/model/remote_model_search.dart';

class RestaurantSearchController extends GetxController {
  final NavigatorHelper navigatorHelper = NavigatorHelper();
  final RemoteDatasource restaurantApi = RemoteDatasource();
  final Connectivity _connectivity = Connectivity();

  RxList<RestaurantModel> restaurantList = <RestaurantModel>[].obs;
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
  final client = http.Client();
  var isOnline = true.obs;

  @override
  void onInit() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      isOnline.value = (result != ConnectivityResult.none);
    });
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    performSearch();
    super.onInit();
  }

  var isLoading = true.obs;
  var isError = false.obs;
  var errorMessage = ''.obs;

  void _updateConnectionStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      connectionStatus.value = false;
      if (showPopup.isFalse) {
        showPopup.value = true;
        NotFound(
          codeError: '500',
          message: 'Koneksi Terputus: ${isError.value}',
        );
      }
      icons.value = Icons.wifi_1_bar;
      color.value = Colors.red;
    } else {
      connectionStatus.value = true;
      showPopup.value = false;
    }
    update();
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
                child: Text("Get search"),
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

  Future<void> performSearch() async {
    if (searchQuery.isNotEmpty) {
      isLoadingSearch(true);

      try {
        final results =
            await restaurantApi.searchRestaurants(searchQuery.value);

        if (results.isNotEmpty) {
          final fotoResults = await restaurantApi.fetchRestaurantData(
            client,
            results.map((r) => r.id).toList(),
          );

          final List<String?> restaurantIds = results.map((e) => e.id).toList();
          final List<RestaurantDetailModel> details = [];

          for (final restaurantId in restaurantIds) {
            final detail = await restaurantApi
                .getRestaurantDetail(restaurantId.toString());
            details.add(detail);
          }

          searchResults.assignAll(results);
          searchFoto.assignAll(fotoResults);
          searchDetail.assignAll(details);

          final searchResultsList = searchResults;
          if (searchResultsList.isEmpty) {
            print('Tidak ditemukan');
          }
        } else {
          print('No search results found.');
        }
      } catch (e) {
        print('Error saat pencarian: $e');
      } finally {
        isLoadingSearch(false);
      }
    }
  }

  void showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 5),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void dispose() {
    client.close();
    super.dispose();
  }
}
