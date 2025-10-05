import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;

class ImageMetadata {
  static Future<double> getImageAspectRatio({
    String? path,
    Uint8List? rawBytes,
    String? extension,
  }) async {
    assert(
      path != null || rawBytes != null,
      'Either path or rawBytes must be provided',
    );
    assert(
      !(path != null && rawBytes != null),
      'Only one of path or rawBytes must be provided',
    );
    assert(
      !(rawBytes != null && extension == null),
      'Extension must be provided when rawBytes is provided',
    );

    try {
      final imageBytes = rawBytes ?? await File(path!).readAsBytes();
      final extn = (extension ?? path?.split('.').last)?.toLowerCase();
      final img.Image? image = switch (extn) {
        'jpg' || 'jpeg' => img.decodeJpg(imageBytes),
        'png' => img.decodePng(imageBytes),
        'gif' => img.decodeGif(imageBytes),
        'webp' => img.decodeWebP(imageBytes),
        'bmp' => img.decodeBmp(imageBytes),
        _ => img.decodeImage(imageBytes), // fallback
      };

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
      return await FlutterImageCompress.compressWithFile(path, quality: 80);
    } catch (e) {
      throw Exception('Failed to compress image: $e');
    }
  }
}
