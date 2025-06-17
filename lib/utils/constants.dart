import 'package:flutter/material.dart';

class AppConstants {
  // App Settings Keys
  static const String themeKey = 'theme_mode';
  static const String iconSizeKey = 'icon_size';
  static const String backgroundOpacityKey = 'background_opacity';
  static const String searchDelayKey = 'search_delay';
  static const String showMostUsedKey = 'show_most_used';
  static const String showFavoritesKey = 'show_favorites';
  static const String appsPerRowKey = 'apps_per_row';
  static const String favoritesKey = 'favorites';
  static const String appUsageKey = 'app_usage';
  static const String cacheVersionKey = 'cache_version';

  // Search Configuration
  static const int searchDebounceMs = 150;
  static const int maxSearchResults = 50;
  static const int mostUsedCount = 12;

  // Cache Configuration
  static const int cacheVersion = 1;
  static const Duration cacheRefreshInterval = Duration(hours: 6);

  // UI Constants
  static const double defaultIconSize = 64.0;
  static const double defaultBackgroundOpacity = 0.95;
  static const int defaultAppsPerRow = 4;
  static const EdgeInsets defaultPadding = EdgeInsets.all(8.0);

  // Animation Durations
  static const Duration fastAnimation = Duration(milliseconds: 150);
  static const Duration normalAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);

  // Colors
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color accentBlue = Color(0xFF03DAC6);
  static const Color errorRed = Color(0xFFCF6679);
  static const Color surfaceColor = Color(0xFF121212);

  // Context Menu Options
  static const List<String> appContextMenuOptions = [
    'Open',
    'App Info',
    'Uninstall',
    'Add to Favorites',
    'Create Shortcut',
    'Hide App',
  ];

  // Themes
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF0A0A0A),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
    ),
    cardTheme: CardTheme(
      elevation: 2,
      color: surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: surfaceColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  );
} 