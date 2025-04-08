import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemeData {
  static ThemeData get theme => ThemeData(
    colorScheme: ColorScheme.highContrastLight().copyWith(
      surface: Colors.white,
      onSurface: Colors.black,
      primary: Colors.blue,
      onPrimary: Colors.white,
      secondary: const Color.fromARGB(255, 33, 229, 243),
      onSecondary: Colors.white,
      tertiary: const Color.fromARGB(255, 33, 243, 61),
      onTertiary: Colors.white,
    ),
    useMaterial3: true,
    textTheme: GoogleFonts.ralewayTextTheme().copyWith(
      titleLarge: GoogleFonts.ralewayTextTheme().titleLarge?.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: GoogleFonts.ralewayTextTheme().titleMedium?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      titleSmall: GoogleFonts.ralewayTextTheme().titleSmall?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: GoogleFonts.ralewayTextTheme().bodyLarge?.copyWith(
        fontSize: 16,
      ),
      bodyMedium: GoogleFonts.ralewayTextTheme().bodyMedium?.copyWith(
        fontSize: 14,
      ),
      bodySmall: GoogleFonts.ralewayTextTheme().bodySmall?.copyWith(
        fontSize: 12,
      ),
      labelLarge: GoogleFonts.ralewayTextTheme().labelLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      labelMedium: GoogleFonts.ralewayTextTheme().labelMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      labelSmall: GoogleFonts.ralewayTextTheme().labelSmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  static ThemeData get light =>
      ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue));

  static ThemeData get dark =>
      ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue));
}
