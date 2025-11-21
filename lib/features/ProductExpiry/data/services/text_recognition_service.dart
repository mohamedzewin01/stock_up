// // lib/features/DateScanner/data/services/text_recognition_service.dart
//
// import 'dart:ui';
//
// import 'package:camera/camera.dart';
// import 'package:flutter/foundation.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
//
// class TextRecognitionService {
//   final TextRecognizer _textRecognizer = TextRecognizer(
//     script: TextRecognitionScript.latin,
//   );
//
//   // معالجة الصورة من الكاميرا واستخراج النص
//   Future<String?> recognizeTextFromImage(CameraImage image) async {
//     try {
//       final inputImage = _convertCameraImage(image);
//       if (inputImage == null) return null;
//
//       final RecognizedText recognizedText = await _textRecognizer.processImage(
//         inputImage,
//       );
//
//       if (recognizedText.text.isEmpty) return null;
//
//       return recognizedText.text;
//     } catch (e) {
//       debugPrint('Error recognizing text: $e');
//       return null;
//     }
//   }
//
//   // تحويل CameraImage إلى InputImage (النسخة المُحدّثة)
//   InputImage? _convertCameraImage(CameraImage image) {
//     try {
//       // تجميع bytes من جميع الـ planes
//       final WriteBuffer allBytes = WriteBuffer();
//       for (final Plane plane in image.planes) {
//         allBytes.putUint8List(plane.bytes);
//       }
//       final bytes = allBytes.done().buffer.asUint8List();
//
//       // حجم الصورة
//       final Size imageSize = Size(
//         image.width.toDouble(),
//         image.height.toDouble(),
//       );
//
//       // تحديد الدوران (rotation)
//       const InputImageRotation imageRotation = InputImageRotation.rotation0deg;
//
//       // تحديد تنسيق الصورة
//       final InputImageFormat inputImageFormat =
//           InputImageFormatValue.fromRawValue(image.format.raw) ??
//           InputImageFormat.nv21;
//
//       // ✅ استخدام InputImageMetadata (API الصحيح)
//       final metadata = InputImageMetadata(
//         size: imageSize,
//         rotation: imageRotation,
//         format: inputImageFormat,
//         bytesPerRow: image.planes[0].bytesPerRow,
//       );
//
//       // إنشاء InputImage
//       return InputImage.fromBytes(bytes: bytes, metadata: metadata);
//     } catch (e) {
//       debugPrint('Error converting camera image: $e');
//       return null;
//     }
//   }
//
//   // تنظيف الموارد
//   void dispose() {
//     _textRecognizer.close();
//   }
// }
// lib/features/ProductExpiry/data/services/text_recognition_service.dart

import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class TextRecognitionService {
  // ✅ استخدام معالجين: واحد للاتينية وواحد للعربية
  final TextRecognizer _latinRecognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );

  final TextRecognizer _arabicRecognizer = TextRecognizer(
    script: TextRecognitionScript.devanagiri, // يدعم النصوص غير اللاتينية
  );

  // معالجة الصورة من الكاميرا واستخراج النص
  Future<String?> recognizeTextFromImage(CameraImage image) async {
    try {
      final inputImage = _convertCameraImage(image);
      if (inputImage == null) return null;

      // ✅ محاولة التعرف على النص باللغتين ودمج النتائج
      final latinText = await _recognizeWithRecognizer(
        _latinRecognizer,
        inputImage,
      );
      final arabicText = await _recognizeWithRecognizer(
        _arabicRecognizer,
        inputImage,
      );

      // دمج النتائج (إزالة التكرار)
      final combinedText = _combineTexts(latinText, arabicText);

      if (combinedText.isEmpty) return null;

      debugPrint('📝 النص المستخرج: $combinedText');
      return combinedText;
    } catch (e) {
      debugPrint('❌ خطأ في التعرف على النص: $e');
      return null;
    }
  }

  // التعرف على النص باستخدام معالج محدد
  Future<String> _recognizeWithRecognizer(
    TextRecognizer recognizer,
    InputImage inputImage,
  ) async {
    try {
      final RecognizedText recognizedText = await recognizer.processImage(
        inputImage,
      );
      return recognizedText.text;
    } catch (e) {
      debugPrint('⚠️ خطأ في المعالج: $e');
      return '';
    }
  }

  // دمج النصوص المستخرجة
  String _combineTexts(String text1, String text2) {
    if (text1.isEmpty) return text2;
    if (text2.isEmpty) return text1;

    // دمج النصوص مع فاصل
    return '$text1\n$text2';
  }

  // ✅ تحويل CameraImage إلى InputImage (محسّن)
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

      // تحديد الدوران
      const InputImageRotation imageRotation = InputImageRotation.rotation0deg;

      // تحديد تنسيق الصورة
      final InputImageFormat inputImageFormat =
          InputImageFormatValue.fromRawValue(image.format.raw) ??
          InputImageFormat.nv21;

      // إنشاء metadata
      final metadata = InputImageMetadata(
        size: imageSize,
        rotation: imageRotation,
        format: inputImageFormat,
        bytesPerRow: image.planes.isNotEmpty ? image.planes[0].bytesPerRow : 0,
      );

      // إنشاء InputImage
      return InputImage.fromBytes(bytes: bytes, metadata: metadata);
    } catch (e) {
      debugPrint('❌ خطأ في تحويل الصورة: $e');
      return null;
    }
  }

  // تنظيف الموارد
  void dispose() {
    _latinRecognizer.close();
    _arabicRecognizer.close();
  }
}
