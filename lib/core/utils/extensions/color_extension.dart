import 'package:flutter/material.dart';

extension HexColor on String? {
  Color toColor({final Color defaultColor = Colors.grey}) {
    if ((this?? '') != '') {
      final hex = this!.replaceFirst('#', '');
      if (hex.length >= 6) {
        try {
          return Color(int.parse('FF$hex', radix: 16));
        } catch (e) {
          return defaultColor;
        }
      } else {
        return defaultColor;
      }
    } else {
      return defaultColor;
    }
  }
}
