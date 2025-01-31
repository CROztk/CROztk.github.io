import 'package:flutter/material.dart';

// This is the light theme
ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.orange, brightness: Brightness.light),
  useMaterial3: true,
);

// This is the dark theme
ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.orange, brightness: Brightness.dark),
  useMaterial3: true,
);
