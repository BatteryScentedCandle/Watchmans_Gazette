import 'package:flutter/material.dart';

class SdgColors {
  static const Map<int, Color> colors = {
    1: Color(0xFFE5243B),
    2: Color(0xFFDDA63A),
    3: Color(0xFF4C9F38),
    4: Color(0xFFC5192D),
    5: Color(0xFFFF3A21),
    6: Color(0xFF26BDE2),
    7: Color(0xFFFCC30B),
    8: Color(0xFFA21942),
    9: Color(0xFFFD6925),
    10: Color(0xFFDD1367),
    11: Color(0xFFFD9D24),
    12: Color(0xFFBF8B2E),
    13: Color(0xFF3F7E44),
    14: Color(0xFF0A97D9),
    15: Color(0xFF56C02B),
    16: Color(0xFF00689D),
    17: Color(0xFF19486A),
  };

  static Color getColor(int sdg) {
    return colors[sdg] ?? Colors.grey;
  }

  static String getLabel(int sdg) {
    return 'SDG $sdg';
  }
}
