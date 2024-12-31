import 'package:flutter/material.dart';
import 'package:local_gen_ai/core/typography/typography.dart';

/// A class that defines the color palette and themes for the application.
class Palette {
  // Light Theme
  /// The light theme configuration for the application.
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    hintColor: Colors.blueAccent,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      color: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
    ),
    textTheme: CustomTypography.nunitoTextTheme,
  );

  // Dark Theme
  /// The dark theme configuration for the application.
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blueGrey,
    hintColor: Colors.tealAccent,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      color: Colors.blueGrey,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: CustomTypography.nunitoTextTheme,
  );
}