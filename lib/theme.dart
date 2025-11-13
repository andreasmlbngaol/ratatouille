import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final darkMaterialTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange, brightness: Brightness.dark),
    useMaterial3: true
);

final lightMaterialTheme = ThemeData(
  textTheme: GoogleFonts.robotoTextTheme().apply(
      bodyColor: Color(0xFF76342E),
      displayColor: const Color(0xFF76342E)
  ),
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
  useMaterial3: true,
);