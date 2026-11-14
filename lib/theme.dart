import 'package:flutter/material.dart';

const couleurPrincipale = Color(0xFF1565C0);
const couleurPrincipaleFoncee = Color(0xFF0D47A1);
const couleurFond = Color(0xFFF3F6FB);

ThemeData construireTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: couleurPrincipale,
    primary: couleurPrincipale,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: couleurFond,
    appBarTheme: const AppBarTheme(
      backgroundColor: couleurPrincipale,
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: Colors.white,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Colors.blueGrey.shade50),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: couleurFond,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: scheme.primaryContainer,
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
}
