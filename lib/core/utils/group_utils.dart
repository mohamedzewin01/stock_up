import 'package:flutter/material.dart';

class GroupUtils {
  static List<Color> getGroupTypeColors(String? groupType) {
    switch (groupType?.toLowerCase()) {
      case 'housing':
        return [const Color(0xFF6D5DFB), const Color(0xFF33C1FF)];
      case 'trip':
        return [const Color(0xFF11998E), const Color(0xFF38EF7D)];
      case 'outing':
        return [const Color(0xFFFFB75E), const Color(0xFFED8F03)];
      case 'family':
        return [const Color(0xFF667EEA), const Color(0xFF764BA2)];
      case 'couple':
        return [const Color(0xFFFF758C), const Color(0xFFFE8473)];
      case 'friends':
        return [const Color(0xFF4FACFE), const Color(0xFF00F2FE)];
      case 'business':
        return [const Color(0xFFFF6B6B), const Color(0xFFEE5A52)];
      default:
        return [const Color(0xFF9D9D9D), const Color(0xFFC4C4C4)];
    }
  }


  static Map<String, dynamic> getGroupTypeInfo(String? groupType) {
    switch (groupType?.toLowerCase()) {
      case 'housing':
        return {
          'icon': Icons.home_work_rounded,
          'label': 'سكن مشترك',
          'color': const Color(0xFF6D5DFB),
        };
      case 'trip':
        return {
          'icon': Icons.flight_takeoff_rounded,
          'label': 'رحلة',
          'color': const Color(0xFF11998E),
        };
      case 'outing':
        return {
          'icon': Icons.restaurant_rounded,
          'label': 'خروجة',
          'color': const Color(0xFFFFB75E),
        };
      case 'family':
        return {
          'icon': Icons.home_rounded,
          'label': 'عائلة',
          'color': const Color(0xFF667EEA),
        };
      case 'couple':
        return {
          'icon': Icons.favorite_rounded,
          'label': 'زوجين',
          'color': const Color(0xFFFF758C),
        };
      case 'friends':
        return {
          'icon': Icons.group_rounded,
          'label': 'أصدقاء',
          'color': const Color(0xFF4FACFE),
        };
      case 'business':
        return {
          'icon': Icons.business_center_rounded,
          'label': 'عمل',
          'color': const Color(0xFFFF6B6B),
        };
      default:
        return {
          'icon': Icons.category_rounded,
          'label': 'أخرى',
          'color': const Color(0xFF9D9D9D),
        };
    }
  }


  static final groupTypes = [
    'housing',     // سكن مشترك
    'trip',        // رحلة
    'outing',      // خروجة
    'family',      // عائلة
    'couple',      // زوجين
    'friends',     // أصدقاء
    'business',    // عمل/مشروع مشترك
    'other',       // أخرى
  ];

  static final List<String> currencies = [
    'sar',  // ريال سعودي
    'egp',  // جنيه مصري
    'usd',  // دولار أمريكي
    'inr',  // روبية هندية
    'bdt',  // تاكا بنجلاديشي
    'lkr',  // روبية سريلانكية
    'ngn',  // نيرة نيجيرية
    'eur',  // يورو
    'jod',  // دينار أردني
    'try',  // ليرة تركية
    'qar',  // ريال قطري
    'aed',  // درهم إماراتي
    'dzd',  // دينار جزائري
    'mad',  // درهم مغربي
    'tnd',  // دينار تونسي
    'syp',  // ليرة سورية
    'sdg',  // جنيه سوداني
    'yer',  // ريال يمني
    'omr',  // ريال عماني
    'kwd',  // دينار كويتي
  ];

  static Map<String, dynamic> getCurrencyInfo(String? currency) {
    switch (currency?.toLowerCase()) {
      case 'sar':
        return {
          'icon': Icons.currency_exchange,
          'label': 'ريال سعودي',
          'color': Colors.teal,
          'flag': 'https://flagcdn.com/w40/sa.png',
        };
      case 'egp':
        return {
          'icon': Icons.currency_pound,
          'label': 'جنيه مصري',
          'color': Colors.amber[800],
          'flag': 'https://flagcdn.com/w40/eg.png',
        };
      case 'usd':
        return {
          'icon': Icons.attach_money,
          'label': 'دولار أمريكي',
          'color': Colors.green,
          'flag': 'https://flagcdn.com/w40/us.png',
        };
      case 'eur':
        return {
          'icon': Icons.euro,
          'label': 'يورو',
          'color': Colors.blueAccent,
          'flag': 'https://flagcdn.com/w40/eu.png',
        };
      case 'inr':
        return {
          'icon': Icons.currency_rupee,
          'label': 'روبية هندية',
          'color': Colors.deepPurple,
          'flag': 'https://flagcdn.com/w40/in.png',
        };
      case 'bdt':
        return {
          'icon': Icons.currency_bitcoin, // مؤقتاً
          'label': 'تاكا بنجلاديشي',
          'color': Colors.green[800],
          'flag': 'https://flagcdn.com/w40/bd.png',
        };
      case 'lkr':
        return {
          'icon': Icons.currency_lira,
          'label': 'روبية سريلانكية',
          'color': Colors.orange,
          'flag': 'https://flagcdn.com/w40/lk.png',
        };
      case 'ngn':
        return {
          'icon': Icons.money,
          'label': 'نيرة نيجيرية',
          'color': Colors.green[700],
          'flag': 'https://flagcdn.com/w40/ng.png',
        };
      case 'jod':
        return {
          'icon': Icons.attach_money_outlined,
          'label': 'دينار أردني',
          'color': Colors.redAccent,
          'flag': 'https://flagcdn.com/w40/jo.png',
        };
      case 'try':
        return {
          'icon': Icons.currency_lira,
          'label': 'ليرة تركية',
          'color': Colors.red,
          'flag': 'https://flagcdn.com/w40/tr.png',
        };
      case 'qar':
        return {
          'icon': Icons.currency_exchange,
          'label': 'ريال قطري',
          'color': Colors.purple,
          'flag': 'https://flagcdn.com/w40/qa.png',
        };
      case 'aed':
        return {
          'icon': Icons.currency_exchange,
          'label': 'درهم إماراتي',
          'color': Colors.grey,
          'flag': 'https://flagcdn.com/w40/ae.png',
        };
      case 'dzd':
        return {
          'icon': Icons.attach_money_outlined,
          'label': 'دينار جزائري',
          'color': Colors.green,
          'flag': 'https://flagcdn.com/w40/dz.png',
        };
      case 'mad':
        return {
          'icon': Icons.attach_money_outlined,
          'label': 'درهم مغربي',
          'color': Colors.red[900],
          'flag': 'https://flagcdn.com/w40/ma.png',
        };
      case 'tnd':
        return {
          'icon': Icons.attach_money_outlined,
          'label': 'دينار تونسي',
          'color': Colors.red,
          'flag': 'https://flagcdn.com/w40/tn.png',
        };
      case 'syp':
        return {
          'icon': Icons.money,
          'label': 'ليرة سورية',
          'color': Colors.brown,
          'flag': 'https://flagcdn.com/w40/sy.png',
        };
      case 'sdg':
        return {
          'icon': Icons.money,
          'label': 'جنيه سوداني',
          'color': Colors.orange[800],
          'flag': 'https://flagcdn.com/w40/sd.png',
        };
      case 'yer':
        return {
          'icon': Icons.money,
          'label': 'ريال يمني',
          'color': Colors.black,
          'flag': 'https://flagcdn.com/w40/ye.png',
        };
      case 'omr':
        return {
          'icon': Icons.money,
          'label': 'ريال عماني',
          'color': Colors.redAccent,
          'flag': 'https://flagcdn.com/w40/om.png',
        };
      case 'kwd':
        return {
          'icon': Icons.money,
          'label': 'دينار كويتي',
          'color': Colors.green[900],
          'flag': 'https://flagcdn.com/w40/kw.png',
        };
      default:
        return {
          'icon': Icons.money_off,
          'label': 'عملة أخرى',
          'color': Colors.grey,
          'flag': null,
        };
    }
  }

}
