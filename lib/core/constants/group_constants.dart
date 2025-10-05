import 'package:flutter/material.dart';

class GroupConstants {
  static final List<Map<String, dynamic>> groupTypes = [
    {
      'value': 'family',
      'label': 'عائلة',
      'icon': Icons.home,
      'color': const Color(0xFF667EEA),
    },
    {
      'value': 'travel',
      'label': 'سفر',
      'icon': Icons.flight,
      'color': const Color(0xFF11998E),
    },
    {
      'value': 'business',
      'label': 'عمل',
      'icon': Icons.business,
      'color': const Color(0xFFFF512F),
    },
    {
      'value': 'friends',
      'label': 'أصدقاء',
      'icon': Icons.group,
      'color': const Color(0xFF4FACFE),
    },
  ];

  static const List<String> currencies = ['SAR', 'USD', 'EUR', 'AED'];

 static List<Color> groupTypeColors(String? groupType) {
    switch (groupType?.toLowerCase()) {
      case 'family':
        return [const Color(0xFF667EEA), const Color(0xFF764BA2)];
      case 'travel':
        return [const Color(0xFF11998E), const Color(0xFF38EF7D)];
      case 'business':
        return [const Color(0xFFFF512F), const Color(0xFFDD2476)];
      case 'friends':
        return [const Color(0xFF4FACFE), const Color(0xFF00F2FE)];
      default:
        return [const Color(0xFF667EEA), const Color(0xFF764BA2)];
    }
  }

  static IconData groupTypeIcon(String? groupType) {
    switch (groupType?.toLowerCase()) {
      case 'family':
        return Icons.home;
      case 'travel':
        return Icons.flight;
      case 'business':
        return Icons.business;
      case 'friends':
        return Icons.group;
      default:
        return Icons.groups;
    }
  }
}
