import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restauran_app/helper/navigator_helper.dart';

class ImgApi extends StatelessWidget {
  final String imageUrl;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final NavigatorHelper _navigatorHelper = NavigatorHelper();
  ImgApi({required this.imageUrl, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: Image.network(
        imageUrl,
        width: double.infinity,
        height: 190.0,
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
              ),
            );
          }
        },
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
          _showErrorDialog(scaffoldKey.currentContext ?? context);
          return Container(
            color: Colors.grey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 40, color: Colors.white),
                  SizedBox(height: 8),
                  Text(
                    'Gagal memuat gambar',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showErrorDialog(BuildContext context) {
    Future.delayed(
      Duration.zero,
      () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Koneksi Internet Terputus'),
              content: Text('Harap periksa koneksi internet Anda.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.offAllNamed(_navigatorHelper.listPage);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
