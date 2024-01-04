import 'package:flutter/material.dart';

class ImgApi extends StatelessWidget {
  final String imageUrl;

  ImgApi({
    required this.imageUrl,
  });

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
          return Container(
            color: Colors.grey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Hapus dialog kesalahan
                  // Icon(Icons.error, size: 40, color: Colors.white),
                  // SizedBox(height: 8),
                  // Text(
                  //   'Gagal memuat Gambar ',
                  //   style: TextStyle(color: Colors.white),
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ... (kode ImgApi yang sebelumnya)
}
