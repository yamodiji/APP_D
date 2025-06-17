import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class ThemeProvider extends ChangeNotifier {
  final SharedPreferences _prefs;
  
  ThemeMode _themeMode = ThemeMode.system;
  double _iconSize = AppConstants.mediumIconSize;
  double _backgroundOpacity = 0.9;

  ThemeProvider(this._prefs) {
    _loadThemePreferences();
  }

  // Getters
  ThemeMode get themeMode => _themeMode;
  double get iconSize => _iconSize;
  double get backgroundOpacity => _backgroundOpacity;

  bool get isDarkMode => _themeMode == ThemeMode.dark ||
      (_themeMode == ThemeMode.system && 
       WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark);

  // Simplified theme definitions
  ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
  );

  ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
  );

  // Methods to update theme settings
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _prefs.setString(AppConstants.themeKey, mode.toString());
    notifyListeners();
  }

  void setIconSize(double size) {
    _iconSize = size;
    _prefs.setDouble(AppConstants.iconSizeKey, size);
    notifyListeners();
  }

  void setBackgroundOpacity(double opacity) {
    _backgroundOpacity = opacity;
    _prefs.setDouble(AppConstants.backgroundOpacityKey, opacity);
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else {
      setThemeMode(ThemeMode.light);
    }
  }

  // Load preferences from storage
  void _loadThemePreferences() {
    final themeString = _prefs.getString(AppConstants.themeKey);
    if (themeString != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (mode) => mode.toString() == themeString,
        orElse: () => ThemeMode.system,
      );
    }

    _iconSize = _prefs.getDouble(AppConstants.iconSizeKey) ?? AppConstants.mediumIconSize;
    _backgroundOpacity = _prefs.getDouble(AppConstants.backgroundOpacityKey) ?? 0.9;
  }

  // Simplified color methods
  Color getTextColor(BuildContext context) {
    return isDarkMode ? Colors.white : Colors.black87;
  }

  Color getAccentColor(BuildContext context) {
    return Colors.blue;
  }

  Color getBackgroundColor(BuildContext context) {
    return isDarkMode ? Colors.black : Colors.white;
  }

  Color getCardColor(BuildContext context) {
    return isDarkMode ? Colors.grey[900]! : Colors.white;
  }

  Color getSurfaceColor(BuildContext context) {
    return isDarkMode ? Colors.grey[800]! : Colors.grey[100]!;
  }
} 