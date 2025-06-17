import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class SettingsProvider extends ChangeNotifier {
  bool _showMostUsed = true;
  bool _showFavorites = true;
  int _searchDelay = AppConstants.searchDebounceMs;
  bool _hapticFeedback = true;
  bool _showSystemApps = false;
  bool _autoLaunch = false;

  bool get showMostUsed => _showMostUsed;
  bool get showFavorites => _showFavorites;
  int get searchDelay => _searchDelay;
  bool get hapticFeedback => _hapticFeedback;
  bool get showSystemApps => _showSystemApps;
  bool get autoLaunch => _autoLaunch;

  SettingsProvider() {
    _loadFromPreferences();
  }

  Future<void> _loadFromPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      _showMostUsed = prefs.getBool(AppConstants.showMostUsedKey) ?? true;
      _showFavorites = prefs.getBool(AppConstants.showFavoritesKey) ?? true;
      _searchDelay = prefs.getInt(AppConstants.searchDelayKey) ?? AppConstants.searchDebounceMs;
      _hapticFeedback = prefs.getBool('haptic_feedback') ?? true;
      _showSystemApps = prefs.getBool('show_system_apps') ?? false;
      _autoLaunch = prefs.getBool('auto_launch') ?? false;
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  Future<void> setShowMostUsed(bool value) async {
    _showMostUsed = value;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.showMostUsedKey, value);
    } catch (e) {
      debugPrint('Error saving show most used setting: $e');
    }
  }

  Future<void> setShowFavorites(bool value) async {
    _showFavorites = value;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.showFavoritesKey, value);
    } catch (e) {
      debugPrint('Error saving show favorites setting: $e');
    }
  }

  Future<void> setSearchDelay(int delay) async {
    _searchDelay = delay.clamp(0, 1000);
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(AppConstants.searchDelayKey, _searchDelay);
    } catch (e) {
      debugPrint('Error saving search delay: $e');
    }
  }

  Future<void> setHapticFeedback(bool value) async {
    _hapticFeedback = value;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('haptic_feedback', value);
    } catch (e) {
      debugPrint('Error saving haptic feedback setting: $e');
    }
  }

  Future<void> setShowSystemApps(bool value) async {
    _showSystemApps = value;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('show_system_apps', value);
    } catch (e) {
      debugPrint('Error saving show system apps setting: $e');
    }
  }

  Future<void> setAutoLaunch(bool value) async {
    _autoLaunch = value;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('auto_launch', value);
    } catch (e) {
      debugPrint('Error saving auto launch setting: $e');
    }
  }
} 