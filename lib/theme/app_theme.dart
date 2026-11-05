import 'package:flutter/material.dart';

// Paleta: grafite, osso e um único laranja de sinalização.
class AppColors {
  static const ink = Color(0xFF0E0F11);
  static const panel = Color(0xFF16181B);
  static const line = Color(0xFF2A2D31);
  static const bone = Color(0xFFE9E4D8);
  static const boneDim = Color(0xFF9A9A94);
  static const signal = Color(0xFFFF5A1F);
  static const ok = Color(0xFF7FB069);
  static const fail = Color(0xFFD64545);
}

// Hierarquia: títulos grossos e apertados, dados e rótulos em monoespaçada.
class AppText {
  static const display = TextStyle(
    fontSize: 52,
    height: 0.95,
    fontWeight: FontWeight.w800,
    letterSpacing: -2,
    color: AppColors.bone,
  );

  static const title = TextStyle(
    fontSize: 20,
    height: 1.15,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
    color: AppColors.bone,
  );

  static const body = TextStyle(
    fontSize: 14,
    height: 1.55,
    color: AppColors.boneDim,
  );

  static const label = TextStyle(
    fontFamily: 'monospace',
    fontSize: 11,
    letterSpacing: 1.6,
    fontWeight: FontWeight.w500,
    color: AppColors.boneDim,
  );

  static const data = TextStyle(
    fontFamily: 'monospace',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.bone,
  );
}

ThemeData buildTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.ink,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.signal,
      surface: AppColors.ink,
    ),
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
  );
}
