import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restauran_app/data/data_source.dart';
import 'package:restauran_app/data/remote_model.dart';
import 'package:restauran_app/data/remote_model_detail.dart';
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
  var isOnline = true.obs;

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

  RxList<RestaurantModel> restaurantList = <RestaurantModel>[].obs;
  var isLoading = true.obs;
  var isError = false.obs;
  var errorMessage = ''.obs;

  void getListOfRestaurants() async {
    try {
      isLoading(true);
      var result = await restaurantApi.getListOfRestaurants([]);
      restaurantList.assignAll(result);
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
    }
  }

  Future<void> searchArea() async {
    await Future.delayed(Duration.zero);
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
