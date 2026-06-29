import 'package:flutter/material.dart';

class AppColors {
  // Brand
  static const Color primary   = Color(0xFFEF4444); // red-500
  static const Color secondary = Color(0xFFF97316); // orange-500

  // Backgrounds
  static const Color background     = Color(0xFFF9FAFB); // gray-50
  static const Color backgroundDark = Color(0xFF111827); // gray-900
  static const Color surface        = Color(0xFFFFFFFF);
  static const Color surfaceDark    = Color(0xFF1F2937); // gray-800
  static const Color card           = Color(0xFFFFFFFF);
  static const Color cardDark       = Color(0xFF1F2937);

  // Text
  static const Color textDark  = Color(0xFF111827);
  static const Color textGrey  = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);

  // Borders
  static const Color border     = Color(0xFFE5E7EB);
  static const Color borderDark = Color(0xFF374151);

  // Status
  static const Color green  = Color(0xFF22C55E);
  static const Color yellow = Color(0xFFF59E0B);
  static const Color blue   = Color(0xFF3B82F6);
  static const Color red    = Color(0xFFEF4444);

  // Gradient
  static const LinearGradient brandGradient = LinearGradient(
    colors: [Color(0xFFEF4444), Color(0xFFF97316)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient brandGradientVertical = LinearGradient(
    colors: [Color(0xFFEF4444), Color(0xFFF97316)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
