import 'package:flutter/material.dart';

var colorSeed = Colors.teal[900];
const scaffoldBackgroundColor = Color(0xFFF8F7F7);

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorSchemeSeed: colorSeed,
    scaffoldBackgroundColor: scaffoldBackgroundColor,
  );
}
