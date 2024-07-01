import 'package:flutter/material.dart';
import 'package:price/core/constants/color_constants.dart';

class CustomDatePickerTheme {
  static ThemeData get theme {
    return ThemeData(
        colorScheme: ColorScheme(
            brightness: Brightness.dark,
            primary: primaryColor,
            onPrimary: Colors.white,
            secondary: tintColor,
            onSecondary: Colors.white,
            error: Colors.red,
            onError: Colors.white,
            surface: secondaryColor,
            onSurface: Colors.white));
  }
}
