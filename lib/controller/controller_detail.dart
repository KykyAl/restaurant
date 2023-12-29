import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restauran_app/data/data_source.dart';
import 'package:restauran_app/data/remote_model.dart';
import 'package:restauran_app/data/remote_model_detail.dart';
import 'package:restauran_app/helper/navigator_helper.dart';
import 'package:restauran_app/widget/addChart.dart';

class RestaurantDetailController extends GetxController {
  final NavigatorHelper navigatorHelper = NavigatorHelper();
  final RemoteDatasource restaurantApi = RemoteDatasource();
  final RxBool isDialogVisible = false.obs;
  Rx<RestaurantDetailModel?> restaurantDetail =
      Rx<RestaurantDetailModel?>(null);
  RxBool isLoadingDetail = true.obs;
  RxBool isErrorDetail = false.obs;
  RxString errorMessageDetail = ''.obs;
  RxBool hasInternetConnection = true.obs;
  RxBool connectionStatus = false.obs;
  RxBool showPopup = false.obs;
  Rx<int> responseTime = 0.obs;
  Rx<Color> color = Colors.green.obs;
  Rx<IconData> icons = Icons.wifi.obs;
  RxList<RestaurantModel> restaurantList = <RestaurantModel>[].obs;

  var isLoading = true.obs;
  var isError = false.obs;
  var isOnline = true.obs;

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

  Future<void> fetchRestaurantDetail(String restaurantId) async {
    try {
      isLoadingDetail(true);
      var result = await restaurantApi.getRestaurantDetail(restaurantId);
      restaurantDetail.value = result;
    } catch (error) {
      isErrorDetail(true);
      final errorMessage = 'Koneksi Anda Terpustus!!!.';
      showSnackbar(Get.context!, errorMessage);
    } finally {
      isLoadingDetail(false);
    }
  }

  void showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void addToCart(BuildContext context, food) {
    ShoppingCart().items.add(CartItem(name: food.name, price: 1.0));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${food.name} added to the cart'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
