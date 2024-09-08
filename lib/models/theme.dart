import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.green,
      brightness: Brightness.light,
      backgroundColor: Colors.grey[300],
      fontFamily: 'Nunito', // Aplica la fuente Nunito
      textTheme:
          _buildTextTheme(Brightness.light), // Configura el tema de texto
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.green,
      brightness: Brightness.dark,
      backgroundColor: Colors.grey[800],
      fontFamily: 'Nunito', // Aplica la fuente Nunito
      textTheme: _buildTextTheme(Brightness.dark), // Configura el tema de texto
    );
  }

  // Construye un TextTheme personalizado basado en Brightness
  static TextTheme _buildTextTheme(Brightness brightness) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
        color: brightness == Brightness.light ? Colors.black : Colors.white,
      ),
      displayMedium: TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.bold,
        color: brightness == Brightness.light ? Colors.black : Colors.white,
      ),
      displaySmall: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: brightness == Brightness.light ? Colors.black : Colors.white,
      ),
      headlineLarge: TextStyle(
        fontSize: 22.0,
        fontWeight: FontWeight.bold,
        color: brightness == Brightness.light ? Colors.black : Colors.white,
      ),
      headlineMedium: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: brightness == Brightness.light ? Colors.black : Colors.white,
      ),
      headlineSmall: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        color: brightness == Brightness.light ? Colors.black : Colors.white,
      ),
      titleLarge: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        color: brightness == Brightness.light ? Colors.black : Colors.white,
      ),
      titleMedium: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.bold,
        color: brightness == Brightness.light ? Colors.black : Colors.white,
      ),
      titleSmall: TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.bold,
        color: brightness == Brightness.light ? Colors.black : Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
        color: brightness == Brightness.light ? Colors.black : Colors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.0,
        color: brightness == Brightness.light ? Colors.black : Colors.white,
      ),
      bodySmall: TextStyle(
        fontSize: 12.0,
        color: brightness == Brightness.light ? Colors.black : Colors.white,
      ),
      labelLarge: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.bold,
        color: brightness == Brightness.light ? Colors.black : Colors.white,
      ),
      labelMedium: TextStyle(
        fontSize: 12.0,
        color: brightness == Brightness.light ? Colors.black : Colors.white,
      ),
      labelSmall: TextStyle(
        fontSize: 10.0,
        color: brightness == Brightness.light ? Colors.black : Colors.white,
      ),
    );
  }
}
