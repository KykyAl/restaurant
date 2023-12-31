import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restauran_app/data/data_source.dart';
import 'package:restauran_app/database/db_helper.dart';
import 'package:restauran_app/helper/navigator_helper.dart';
import 'package:restauran_app/model/remote_model_detail.dart';

class RestaurantDetailController extends GetxController {
  final NavigatorHelper navigatorHelper = NavigatorHelper();
  final RemoteDatasource restaurantApi = RemoteDatasource();

  final RxBool isDialogVisible = false.obs;
  RxList<RestaurantDetailModel> restaurantDetail =
      <RestaurantDetailModel>[].obs;
  RxBool isLoadingDetail = true.obs;
  RxBool isErrorDetail = false.obs;
  RxString errorMessageDetail = ''.obs;
  RxBool hasInternetConnection = true.obs;
  RxBool connectionStatus = false.obs;
  RxBool showPopup = false.obs;
  Rx<int> responseTime = 0.obs;
  Rx<Color> color = Colors.green.obs;
  Rx<IconData> icons = Icons.wifi.obs;
  static final DatabaseHelper dbHelper = DatabaseHelper();
  var isError = false.obs;

  Future<RestaurantDetailModel?> fetchRestaurantDetail(
      String restaurantId) async {
    try {
      isLoadingDetail(true);
      var result = await restaurantApi.getRestaurantDetail(restaurantId);
      restaurantDetail.assign(result);
      return result;
    } catch (error) {
      isErrorDetail(true);
      final errorMessage = 'Koneksi Anda Terputus!!!.';
      showSnackbar(Get.context!, errorMessage);
      return null;
    } finally {
      isLoadingDetail(false);
    }
  }

  void showSnackbar(BuildContext context, String message) {
    Future.delayed(
      Duration.zero,
      () {
        final snackBar = SnackBar(
          content: Text(message),
          duration: Duration(seconds: 3),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
    );
  }
}
