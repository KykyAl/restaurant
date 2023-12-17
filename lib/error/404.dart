import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restauran_app/helper/navigator_helper.dart';

class NotFound extends StatelessWidget {
  final String? codeError;
  final String? message;
  NotFound({super.key, this.codeError, this.message});
  final NavigatorHelper _navigatorHelper = NavigatorHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              codeError!,
            ),
            Divider(
              endIndent: 50,
              indent: 50,
              thickness: 2,
            ),
            Column(
              children: [
                Icon(
                  Icons.error_sharp,
                  size: 30,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Silahakan Cek Internet Anda',
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () =>
                          Get.offAndToNamed(_navigatorHelper.listPage),
                      child: Text('Mulai ulang Aplikasi')),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
