// lib/features/DateScanner/domain/entities/date_scan_result.dart

import 'package:flutter/material.dart';

enum ProductStatus {
  expired, // منتهي
  nearExpiry, // قريب من الانتهاء (< 30 يوم)
  valid, // صالح
  unclear; // غير واضح

  Color get color {
    switch (this) {
      case ProductStatus.expired:
        return const Color(0xFFE74C3C);
      case ProductStatus.nearExpiry:
        return const Color(0xFFF39C12);
      case ProductStatus.valid:
        return const Color(0xFF27AE60);
      case ProductStatus.unclear:
        return const Color(0xFF95A5A6);
    }
  }

  IconData get icon {
    switch (this) {
      case ProductStatus.expired:
        return Icons.dangerous_rounded;
      case ProductStatus.nearExpiry:
        return Icons.warning_amber_rounded;
      case ProductStatus.valid:
        return Icons.check_circle_rounded;
      case ProductStatus.unclear:
        return Icons.help_outline_rounded;
    }
  }

  String get label {
    switch (this) {
      case ProductStatus.expired:
        return 'منتهي الصلاحية';
      case ProductStatus.nearExpiry:
        return 'قريب من الانتهاء';
      case ProductStatus.valid:
        return 'صالح';
      case ProductStatus.unclear:
        return 'غير واضح';
    }
  }
}

class DateScanResult {
  final DateTime? expiryDate;
  final DateTime? manufacturingDate;
  final DateTime? bestBefore;
  final ProductStatus status;
  final String? rawText;
  final Duration? validityPeriod;
  final int? daysUntilExpiry;
  final List<String> detectedTexts;

  DateScanResult({
    this.expiryDate,
    this.manufacturingDate,
    this.bestBefore,
    required this.status,
    this.rawText,
    this.validityPeriod,
    this.daysUntilExpiry,
    this.detectedTexts = const [],
  });

  bool get hasValidData =>
      expiryDate != null || manufacturingDate != null || bestBefore != null;

  String get statusMessage {
    if (!hasValidData) {
      return 'وجه الكاميرا نحو التاريخ';
    }

    switch (status) {
      case ProductStatus.expired:
        return 'هذا المنتج منتهي الصلاحية';
      case ProductStatus.nearExpiry:
        return 'ينتهي خلال $daysUntilExpiry يوم';
      case ProductStatus.valid:
        return 'المنتج صالح للاستخدام';
      case ProductStatus.unclear:
        return 'أعد توجيه الكاميرا للحصول على نتيجة أفضل';
    }
  }

  DateScanResult copyWith({
    DateTime? expiryDate,
    DateTime? manufacturingDate,
    DateTime? bestBefore,
    ProductStatus? status,
    String? rawText,
    Duration? validityPeriod,
    int? daysUntilExpiry,
    List<String>? detectedTexts,
  }) {
    return DateScanResult(
      expiryDate: expiryDate ?? this.expiryDate,
      manufacturingDate: manufacturingDate ?? this.manufacturingDate,
      bestBefore: bestBefore ?? this.bestBefore,
      status: status ?? this.status,
      rawText: rawText ?? this.rawText,
      validityPeriod: validityPeriod ?? this.validityPeriod,
      daysUntilExpiry: daysUntilExpiry ?? this.daysUntilExpiry,
      detectedTexts: detectedTexts ?? this.detectedTexts,
    );
  }
}
