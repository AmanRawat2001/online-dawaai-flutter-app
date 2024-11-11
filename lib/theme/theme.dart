import 'package:flutter/material.dart';

// ThemeData for light and dark themes
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: Color(0xFF019245),
    secondary: Color(0xFFEE3926),
    surface: Colors.white,
    onSurface: Colors.black,
    onPrimary: Colors.grey,
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: Color(0xFF019245),
    secondary: Color(0xFFEE3926),
    surface: Colors.black,
    onSurface: Colors.white,
    onPrimary: Colors.grey,
  ),
);
