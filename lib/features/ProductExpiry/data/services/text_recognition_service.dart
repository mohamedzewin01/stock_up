// lib/features/DateScanner/data/services/text_recognition_service.dart

import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class TextRecognitionService {
  final TextRecognizer _textRecognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );

  // معالجة الصورة من الكاميرا واستخراج النص
  Future<String?> recognizeTextFromImage(CameraImage image) async {
    try {
      final inputImage = _convertCameraImage(image);
      if (inputImage == null) return null;

      final RecognizedText recognizedText = await _textRecognizer.processImage(
        inputImage,
      );

      if (recognizedText.text.isEmpty) return null;

      return recognizedText.text;
    } catch (e) {
      debugPrint('Error recognizing text: $e');
      return null;
    }
  }

  // تحويل CameraImage إلى InputImage (النسخة المُحدّثة)
  InputImage? _convertCameraImage(CameraImage image) {
    try {
      // تجميع bytes من جميع الـ planes
      final WriteBuffer allBytes = WriteBuffer();
      for (final Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      // حجم الصورة
      final Size imageSize = Size(
        image.width.toDouble(),
        image.height.toDouble(),
      );

      // تحديد الدوران (rotation)
      const InputImageRotation imageRotation = InputImageRotation.rotation0deg;

      // تحديد تنسيق الصورة
      final InputImageFormat inputImageFormat =
          InputImageFormatValue.fromRawValue(image.format.raw) ??
          InputImageFormat.nv21;

      // ✅ استخدام InputImageMetadata (API الصحيح)
      final metadata = InputImageMetadata(
        size: imageSize,
        rotation: imageRotation,
        format: inputImageFormat,
        bytesPerRow: image.planes[0].bytesPerRow,
      );

      // إنشاء InputImage
      return InputImage.fromBytes(bytes: bytes, metadata: metadata);
    } catch (e) {
      debugPrint('Error converting camera image: $e');
      return null;
    }
  }

  // تنظيف الموارد
  void dispose() {
    _textRecognizer.close();
  }
}
