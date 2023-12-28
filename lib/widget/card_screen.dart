import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restauran_app/controller/controller_detail.dart';
import 'package:restauran_app/data/data_source.dart';
import 'package:restauran_app/error/404.dart';
import 'package:restauran_app/helper/navigator_helper.dart';
import 'package:restauran_app/widget/addChart.dart';

class CartScreen extends StatelessWidget {
  final RemoteDatasource restauranApi = RemoteDatasource();
  final NavigatorHelper navigatorHelper = NavigatorHelper();
  final controller = Get.find<RestaurantDetailController>();

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;

    // Check if arguments is not null and contains the key 'id'
    if (arguments != null && arguments.containsKey('id')) {
      final restaurantId = arguments['id'];
      controller.fetchRestaurantDetail(restaurantId);
    } else {
      // Handle the case when 'id' is not present or arguments is null
      print('Error: No valid ID found in arguments');
      // You might want to show an error message or navigate to an error screen
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: GetBuilder<RestaurantDetailController>(
        builder: (controller) {
          // Use controller variables here
          if (controller.isLoadingDetail.isTrue) {
            return Center(child: CircularProgressIndicator());
          } else if (controller.isError.isTrue) {
            return NotFound(
              codeError: '500',
              message:
                  'An error occurred: ${controller.errorMessageDetail.value}',
            );
          } else if (controller.restaurantDetail.value == null) {
            return NotFound(
              codeError: '500',
              message:
                  'An error occurred: ${controller.errorMessageDetail.value}',
            );
          } else {
            return Container(
              height: 400,
              child: ListView.builder(
                itemCount: ShoppingCart().items.length,
                itemBuilder: (context, index) {
                  var item = ShoppingCart().items[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
                  );
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Checkout'),
              content: Text('Thank you for your purchase!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
