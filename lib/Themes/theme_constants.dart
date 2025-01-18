import 'package:flutter/material.dart';

// Define the light theme for the application
final ThemeData lightTheme = ThemeData(
  useMaterial3: true, // Use Material Design 3
  brightness: Brightness.light, // Set brightness to light
  colorSchemeSeed: Colors.green, // Seed color for the color scheme

  // AppBar theme
  appBarTheme: const AppBarTheme(
    foregroundColor: Colors.white, // Foreground color for the app bar
    backgroundColor: Colors.green, // Background color for the app bar
  ),

  // Switch theme
  switchTheme: SwitchThemeData(
    thumbColor:
        MaterialStateProperty.all(Colors.green), // Thumb color for the switch
    trackColor: MaterialStateProperty.all(
        Colors.green[800]), // Track color for the switch
    trackOutlineColor: MaterialStateProperty.all(
        Colors.white), // Track outline color for the switch
    thumbIcon: MaterialStateProperty.all(
        const Icon(Icons.light_mode)), // Icon for the switch thumb
  ),

  // BottomNavigationBar theme
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor:
        Colors.white, // Background color for the bottom navigation bar
    selectedItemColor: Colors.green, // Color for the selected item
    unselectedItemColor: Colors.grey, // Color for the unselected items
  ),
);

// Define the dark theme for the application
final ThemeData darkTheme = ThemeData(
  useMaterial3: true, // Use Material Design 3
  brightness: Brightness.dark, // Set brightness to dark
  colorScheme: const ColorScheme.dark(), // Use the default dark color scheme

  // AppBar theme
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black87, // Background color for the app bar
  ),

  // Switch theme
  switchTheme: SwitchThemeData(
    thumbColor:
        MaterialStateProperty.all(Colors.white), // Thumb color for the switch
    trackColor:
        MaterialStateProperty.all(Colors.black), // Track color for the switch
    trackOutlineColor: MaterialStateProperty.all(
        Colors.white), // Track outline color for the switch
    thumbIcon: MaterialStateProperty.all(
        const Icon(Icons.dark_mode)), // Icon for the switch thumb
  ),

  // BottomNavigationBar theme
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor:
        Colors.black, // Background color for the bottom navigation bar
    selectedItemColor: Colors.green, // Color for the selected item
    unselectedItemColor: Colors.grey, // Color for the unselected items
  ),

  // CircularProgressIndicator theme
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Colors.white, // Color for the circular progress indicator
  ),

  // ElevatedButton theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(
          Colors.black87), // Background color for the elevated button
      foregroundColor: const MaterialStatePropertyAll(
          Colors.white), // Foreground color for the elevated button
    ),
  ),
);
