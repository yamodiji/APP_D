class AppConstants {
  // Theme constants
  static const String themeKey = 'theme_mode';
  static const String iconSizeKey = 'icon_size';
  static const String backgroundOpacityKey = 'background_opacity';
  static const String fuzzySearchKey = 'fuzzy_search';
  static const String favoriteAppsKey = 'favorite_apps';
  static const String mostUsedAppsKey = 'most_used_apps';
  static const String showMostUsedKey = 'show_most_used';
  static const String searchHistoryKey = 'search_history';
  static const String autoFocusKey = 'auto_focus';
  static const String vibrationKey = 'vibration';
  static const String animationsKey = 'animations';
  static const String showKeyboardKey = 'show_keyboard';
  static const String showSearchHistoryKey = 'show_search_history';
  static const String clearSearchOnCloseKey = 'clear_search_on_close';

  // Performance constants
  static const int maxSearchResults = 50;
  static const int maxSearchHistory = 10;
  static const int maxMostUsedApps = 8;
  static const int debounceDelayMs = 100;
  static const int animationDurationMs = 150;

  // Icon sizes
  static const double smallIconSize = 32.0;
  static const double mediumIconSize = 48.0;
  static const double largeIconSize = 64.0;
  static const double extraLargeIconSize = 80.0;

  // Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double borderRadius = 8.0;

  // Search configuration
  static const double searchThreshold = 0.6;
  static const int minSearchLength = 1;
} 