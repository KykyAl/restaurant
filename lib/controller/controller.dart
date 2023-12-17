import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restauran_app/data/data_source.dart';
import 'package:restauran_app/data/remote_model.dart';
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

  var restaurants = <RestaurantModel>[].obs;
  var isLoading = true.obs;
  var isError = false.obs;

  Future<void> fetchRestaurants(context) async {
    try {
      isLoading(true);
      // Ganti dengan panggilan ke Future yang sesuai
      List<RestaurantModel> data = await restaurantApi.getListOfRestaurants(context, [])  ;
      restaurants.assignAll(data);
    } catch (error) {
      isError(true);
      print('Error fetching restaurants: $error');
    } finally {
      isLoading(false);
    }
  }


  // Future<void> getListRestaurant() async {
  //   final body = RestaurantModel(
  //       id: idUsers.value,
  //       name: name.value,
  //       description: desc.value,
  //       pictureId: pictureId.value,
  //       city: city.value,
  //       rating: rating.value);
  //   final response = await listRestorant(body: body);
  //   final responseDecode = jsonDecode(response.body);
  //   log('response ${responseDecode}');
  // }

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
