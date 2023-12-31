import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:restauran_app/data/data_source.dart';
import 'package:restauran_app/helper/navigator_helper.dart';
import 'package:restauran_app/model/remote_model.dart';
import 'package:restauran_app/model/remote_model_detail.dart';
import 'package:restauran_app/model/remote_model_search.dart';

class RestaurantController extends GetxController {
  final NavigatorHelper navigatorHelper = NavigatorHelper();
  final RemoteDatasource restaurantApi = RemoteDatasource();
  final Connectivity _connectivity = Connectivity();
  final client = http.Client();
  RxList<RestaurantModel> restaurantList = <RestaurantModel>[].obs;
  RxString errorMessageDetail = ''.obs;
  RxBool isLoadingSearch = false.obs;
  RxList<RestaurantSearchModel> searchResults = <RestaurantSearchModel>[].obs;
  RxList<RestaurantModel> searchPhoto = <RestaurantModel>[].obs;
  RxList<RestaurantDetailModel> searchDetail = <RestaurantDetailModel>[].obs;
  RxString searchQuery = ''.obs;
  RxList<RestaurantModel> listRestaurant = <RestaurantModel>[].obs;
  RxList<RestaurantModel> listDetailTaskSearch = <RestaurantModel>[].obs;
  Rx<TextEditingController> areaSearchTE = TextEditingController(text: '').obs;
  RxList<RestaurantModel>? restaurants = <RestaurantModel>[].obs;
  RxBool hasInternetConnection = true.obs;
  RxBool connectionStatus = false.obs;
  RxBool showPopup = false.obs;
  Rx<Color> color = Colors.green.obs;
  Rx<IconData> icons = Icons.wifi.obs;
  RxBool isInternetConnected = true.obs;
  var isOnline = true.obs;
  final RxBool isOnlineRx = true.obs;
  RxInt selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    getListOfRestaurants();
  }

  void onItemTapped(int index) {
    if (selectedIndex.value != index) {
      selectedIndex.value = index;
      if (selectedIndex.value == 0) {
        Get.offAllNamed(navigatorHelper.listPage);
      } else if (selectedIndex.value == 1) {
        Get.offAllNamed(navigatorHelper.favoriteList);
      } else if (selectedIndex.value == 2) {
        Get.offAllNamed(navigatorHelper.notif);
      }
    }
  }

  void showNoInternetSnackbar() {
    final snackBar = SnackBar(
      content: Text('No internet connection'),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
  }

  var isLoading = true.obs;
  var isError = false.obs;
  var errorMessage = ''.obs;

  Future<void> getListOfRestaurants() async {
    try {
      isLoading(true);
      var result = await restaurantApi.fetchRestaurantData(client, []);
      restaurantList.assignAll(result);
      isError(false);
    } catch (error) {
      isError(true);
      final errorMessage = 'Koneksi Anda Terputus!!!.';
      showSnackbar(Get.context!, errorMessage);
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
    } else {
      connectionStatus.value = true;
      showPopup.value = false;
      Get.back();
    }
    update();
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
        restaurantList
            .assignAll(await restaurantApi.fetchRestaurantData(client, []));
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
        isDismissible: false,
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
              SizedBox(
                height: 10,
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
              Container(
                  height: 30,
                  width: 170,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color.fromARGB(255, 245, 241, 241)),
                  child: Center(
                    child: Text(
                      "Hidupkan Internetnya dulu",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: Colors.blue,
                      ),
                    ),
                  )),
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

  void showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
