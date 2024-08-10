import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;

class ImageMetadata {
  static Future<double> getImageAspectRatio(
      {String? path, Uint8List? rawBytes, String? extension}) async {
    if (path == null && rawBytes == null) {
      throw Exception('Path or rawBytes must be provided');
    }
    if (path != null && rawBytes != null) {
      throw Exception('Only one of path or rawBytes must be provided');
    }
    if (rawBytes != null && extension == null) {
      throw Exception('Extension must be provided when rawBytes is provided');
    }

    try {
      final Uint8List imageBytes =
          rawBytes ?? (await File(path!).readAsBytes());
      final image = img.decodeImage(imageBytes);

      if (image == null) {
        throw Exception('Unable to decode image');
      }
      return image.width / image.height;
    } catch (e) {
      throw Exception('Failed to get image aspect ratio: $e');
    }
  }

  static Future<Uint8List?> compressImage(String path) async {
    try {
      return await FlutterImageCompress.compressWithFile(
        path,
        quality: 80,
      );
    } catch (e) {
      throw Exception('Failed to compress image: $e');
    }
  }
}
