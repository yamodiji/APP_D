import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  double _iconSize = AppConstants.defaultIconSize;
  double _backgroundOpacity = AppConstants.defaultBackgroundOpacity;
  int _appsPerRow = AppConstants.defaultAppsPerRow;

  ThemeMode get themeMode => _themeMode;
  double get iconSize => _iconSize;
  double get backgroundOpacity => _backgroundOpacity;
  int get appsPerRow => _appsPerRow;

  ThemeProvider() {
    _loadFromPreferences();
  }

  Future<void> _loadFromPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final themeIndex = prefs.getInt(AppConstants.themeKey) ?? 0;
      _themeMode = ThemeMode.values[themeIndex];
      
      _iconSize = prefs.getDouble(AppConstants.iconSizeKey) ?? AppConstants.defaultIconSize;
      _backgroundOpacity = prefs.getDouble(AppConstants.backgroundOpacityKey) ?? AppConstants.defaultBackgroundOpacity;
      _appsPerRow = prefs.getInt(AppConstants.appsPerRowKey) ?? AppConstants.defaultAppsPerRow;
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading theme preferences: $e');
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(AppConstants.themeKey, mode.index);
    } catch (e) {
      debugPrint('Error saving theme mode: $e');
    }
  }

  Future<void> setIconSize(double size) async {
    _iconSize = size.clamp(32.0, 128.0);
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(AppConstants.iconSizeKey, _iconSize);
    } catch (e) {
      debugPrint('Error saving icon size: $e');
    }
  }

  Future<void> setBackgroundOpacity(double opacity) async {
    _backgroundOpacity = opacity.clamp(0.1, 1.0);
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(AppConstants.backgroundOpacityKey, _backgroundOpacity);
    } catch (e) {
      debugPrint('Error saving background opacity: $e');
    }
  }

  Future<void> setAppsPerRow(int count) async {
    _appsPerRow = count.clamp(2, 6);
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(AppConstants.appsPerRowKey, _appsPerRow);
    } catch (e) {
      debugPrint('Error saving apps per row: $e');
    }
  }

  void toggleTheme() {
    switch (_themeMode) {
      case ThemeMode.light:
        setThemeMode(ThemeMode.dark);
        break;
      case ThemeMode.dark:
        setThemeMode(ThemeMode.system);
        break;
      case ThemeMode.system:
        setThemeMode(ThemeMode.light);
        break;
    }
  }
} 