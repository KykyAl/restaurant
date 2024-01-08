import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class ImgApi extends StatelessWidget {
  final String imageUrl;

  ImgApi({
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: FadeInImage.memoryNetwork(
        placeholder: kTransparentImage,
        image: imageUrl,
        width: double.infinity,
        height: 250.0,
        fit: BoxFit.cover,
        imageErrorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey,
          );
        },
      ),
    );
  }
}
