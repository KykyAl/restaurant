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
  Rx<String> idUsers = ''.obs;
  Rx<String> name = ''.obs;
  Rx<String> desc = ''.obs;
  Rx<String> pictureId = ''.obs;
  Rx<String> city = ''.obs;
  Rx<double> rating = 0.0.obs;
  RxList<RestaurantModel> listRestaurant = <RestaurantModel>[].obs;
  RxList<RestaurantModel> listDetailTaskSearch = <RestaurantModel>[].obs;
  Rx<TextEditingController> areaSearchTE = TextEditingController(text: '').obs;
  final RemoteDatasource restaurantApi = RemoteDatasource();
  RxList<RestaurantModel>? restaurants = <RestaurantModel>[].obs;
  RxBool hasInternetConnection = true.obs;
  final Connectivity _connectivity = Connectivity();
  RxBool connectionStatus = false.obs;
  RxBool showPopup = false.obs;
  Rx<int> responseTime = 0.obs;
  Rx<Color> color = Colors.green.obs;
  Rx<IconData> icons = Icons.wifi.obs;
  RxBool isOnline = true.obs;

  @override
  void onInit() {
    getListOfRestaurants();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      isOnline.value = (result != ConnectivityResult.none);
    });
    _fetchRestaurants();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.onInit();
  }

    final RxBool loading = false.obs;
  final RxList<RestaurantSearchModel> searchResults = <RestaurantSearchModel>[].obs;
  final RxList<RestaurantModel> searchFoto = <RestaurantModel>[].obs;
  final RxList<RestaurantDetailModel> searchDetail = <RestaurantDetailModel>[].obs;

  Future<void> performSearch(String query) async {
    if (query.isNotEmpty) {
      loading.value = true;

      try {
        final results = await restaurantApi.searchRestaurants(query);
        final fotoResults =
            await restaurantApi.getListOfRestaurants(results.map((r) => r.id).toList());
        final List<String?> restaurantIds = results.map((e) => e.id).toList();
        final List<RestaurantDetailModel> details = [];

        for (final restaurantId in restaurantIds) {
          final detail = await restaurantApi.getRestaurantDetail(restaurantId!);
          details.add(detail);
        }

        searchResults.assignAll(results);
        searchFoto.assignAll(fotoResults);
        searchDetail.assignAll(details);

        loading.value = false;
      } catch (e) {
        print('Error searching restaurants: $e');
        loading.value = false;
      }
    }
  }


  RxList<RestaurantModel> restaurantList = <RestaurantModel>[].obs;
  var isLoading = true.obs;
  var isError = false.obs;
  var errorMessage = ''.obs;

Future<void> getListOfRestaurants() async {
    try {
      isLoading(true);
      var fetchedRestaurants = await restaurantApi.getListOfRestaurants([]);
      restaurantList.assignAll(fetchedRestaurants);
    } catch (error) {
      isError(true);
      errorMessage('Error: $error');
    } finally {
      isLoading(false);
    }
  }

  Rx<RestaurantDetailModel?> restaurantDetail =
      Rx<RestaurantDetailModel?>(null);
  RxBool isLoadingDetail = true.obs;
  RxBool isErrorDetail = false.obs;
  RxString errorMessageDetail = ''.obs;

  Future<void> fetchRestaurantDetail(String restaurantId) async {
    try {
      isLoadingDetail(true);
      var result = await restaurantApi.getRestaurantDetail(restaurantId);
      restaurantDetail.value = result;
    } catch (error) {
      isErrorDetail(true);
      errorMessageDetail('Error: $error');
    } finally {
      isLoadingDetail(false);
    }
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      connectionStatus.value = false;
      if (showPopup.isFalse) {
        showPopup.value = true;
        _showNoInternetError();
      }
      icons.value = Icons.wifi_1_bar;
    } else {
      connectionStatus.value = true;
      showPopup.value = false;
    }
  }

  _showNoInternetError() {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Koneksi Terputus'),
          content: Text('Silahakan cek internet anda'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

   Future<void> _fetchRestaurants() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      hasInternetConnection.value = false;
      return;
    }

    try {
      final List<RestaurantModel> fetchedRestaurants =
          await restaurantApi.getListOfRestaurants([]);
      restaurants = fetchedRestaurants.obs;
    } catch (e) {
      print('Error fetching restaurants: $e');
      Get.snackbar('Error', 'Failed to fetch restaurants. Please try again.');
    }
  }

  Future<void> searchArea() async {
    List<RestaurantModel> listSearch = [];

    listSearch = listRestaurant
        .where((e) =>
            e.name
                .toLowerCase()
                .contains(areaSearchTE.value.text.toLowerCase()) ||
            e.city
                .toLowerCase()
                .contains(areaSearchTE.value.text.toLowerCase()))
        .toList();
    listDetailTaskSearch.value = listSearch;
  }
}