import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/app_info.dart';
import '../utils/constants.dart';

class AppProvider extends ChangeNotifier {
  List<AppInfo> _allApps = [];
  List<AppInfo> _filteredApps = [];
  List<AppInfo> _favoriteApps = [];
  List<AppInfo> _mostUsedApps = [];
  bool _isLoading = false;
  String _searchQuery = '';
  Timer? _searchDebouncer;
  Database? _database;
  bool _isInitialized = false;

  List<AppInfo> get allApps => _allApps;
  List<AppInfo> get filteredApps => _filteredApps;
  List<AppInfo> get favoriteApps => _favoriteApps;
  List<AppInfo> get mostUsedApps => _mostUsedApps;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  bool get isInitialized => _isInitialized;

  Future<void> initializeProvider() async {
    if (_isInitialized) return;
    
    _isLoading = true;
    notifyListeners();

    try {
      await _initializeDatabase();
      await _loadAppsFromCache();
      
      // If cache is empty or outdated, refresh from system
      if (_allApps.isEmpty || await _shouldRefreshCache()) {
        await refreshApps();
      } else {
        _updateFilteredApps();
        _updateFavoriteApps();
        _updateMostUsedApps();
      }
      
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing AppProvider: $e');
      await refreshApps(); // Fallback to fresh load
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _initializeDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'speed_drawer.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE apps (
            packageName TEXT PRIMARY KEY,
            appName TEXT NOT NULL,
            icon BLOB,
            isSystemApp INTEGER NOT NULL DEFAULT 0,
            isEnabled INTEGER NOT NULL DEFAULT 1,
            versionName TEXT,
            versionCode INTEGER,
            usageCount INTEGER NOT NULL DEFAULT 0,
            lastUsed TEXT NOT NULL,
            isFavorite INTEGER NOT NULL DEFAULT 0,
            isHidden INTEGER NOT NULL DEFAULT 0,
            customName TEXT,
            cachedAt TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE INDEX idx_apps_usage ON apps(usageCount DESC, lastUsed DESC);
        ''');

        await db.execute('''
          CREATE INDEX idx_apps_favorites ON apps(isFavorite DESC);
        ''');
      },
    );
  }

  Future<void> _loadAppsFromCache() async {
    if (_database == null) return;

    try {
      final List<Map<String, dynamic>> maps = await _database!.query(
        'apps',
        where: 'isHidden = ?',
        whereArgs: [0],
        orderBy: 'appName COLLATE NOCASE ASC',
      );

      _allApps = maps.map((map) {
        return AppInfo(
          packageName: map['packageName'],
          appName: map['appName'],
          icon: map['icon'] != null ? base64Encode(map['icon']) : null,
          isSystemApp: map['isSystemApp'] == 1,
          isEnabled: map['isEnabled'] == 1,
          versionName: map['versionName'],
          versionCode: map['versionCode'],
          usageCount: map['usageCount'],
          lastUsed: DateTime.parse(map['lastUsed']),
          isFavorite: map['isFavorite'] == 1,
          isHidden: map['isHidden'] == 1,
          customName: map['customName'],
        );
      }).toList();

      debugPrint('Loaded ${_allApps.length} apps from cache');
    } catch (e) {
      debugPrint('Error loading apps from cache: $e');
      _allApps = [];
    }
  }

  Future<bool> _shouldRefreshCache() async {
    final prefs = await SharedPreferences.getInstance();
    final lastRefresh = prefs.getString('last_cache_refresh');
    
    if (lastRefresh == null) return true;
    
    final lastRefreshTime = DateTime.tryParse(lastRefresh);
    if (lastRefreshTime == null) return true;
    
    return DateTime.now().difference(lastRefreshTime) > AppConstants.cacheRefreshInterval;
  }

  Future<void> refreshApps() async {
    _isLoading = true;
    notifyListeners();

    try {
      final List<Application> installedApps = await DeviceApps.getInstalledApplications(
        includeAppIcons: true,
        includeSystemApps: true,
        onlyAppsWithLaunchIntent: true,
      );

      // Merge with existing app data
      final Map<String, AppInfo> existingApps = {
        for (var app in _allApps) app.packageName: app
      };

      _allApps = installedApps.map((app) {
        final existing = existingApps[app.packageName];
        if (existing != null) {
          // Update existing app with new system data
          return existing.copyWith(
            appName: app.appName,
            isSystemApp: app.systemApp,
            isEnabled: app.enabled,
            versionName: app.versionName,
            versionCode: app.versionCode,
            icon: app is ApplicationWithIcon ? base64Encode(app.icon) : existing.icon,
          );
        } else {
          // Create new app info
          return AppInfo.fromApplication(app);
        }
      }).where((app) => !app.isHidden).toList();

      // Sort alphabetically
      _allApps.sort((a, b) => a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase()));

      await _saveAppsToCache();
      _updateFilteredApps();
      _updateFavoriteApps();
      _updateMostUsedApps();

      // Update refresh timestamp
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_cache_refresh', DateTime.now().toIso8601String());

      debugPrint('Refreshed ${_allApps.length} apps');
    } catch (e) {
      debugPrint('Error refreshing apps: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveAppsToCache() async {
    if (_database == null) return;

    try {
      final batch = _database!.batch();
      
      // Clear existing cache
      batch.delete('apps');
      
      // Insert all apps
      for (final app in _allApps) {
        batch.insert('apps', {
          'packageName': app.packageName,
          'appName': app.appName,
          'icon': app.icon != null ? base64Decode(app.icon!) : null,
          'isSystemApp': app.isSystemApp ? 1 : 0,
          'isEnabled': app.isEnabled ? 1 : 0,
          'versionName': app.versionName,
          'versionCode': app.versionCode,
          'usageCount': app.usageCount,
          'lastUsed': app.lastUsed.toIso8601String(),
          'isFavorite': app.isFavorite ? 1 : 0,
          'isHidden': app.isHidden ? 1 : 0,
          'customName': app.customName,
          'cachedAt': DateTime.now().toIso8601String(),
        });
      }
      
      await batch.commit(noResult: true);
      debugPrint('Saved ${_allApps.length} apps to cache');
    } catch (e) {
      debugPrint('Error saving apps to cache: $e');
    }
  }

  void searchApps(String query) {
    _searchQuery = query;
    
    _searchDebouncer?.cancel();
    _searchDebouncer = Timer(const Duration(milliseconds: AppConstants.searchDebounceMs), () {
      _updateFilteredApps();
      notifyListeners();
    });
  }

  void _updateFilteredApps() {
    if (_searchQuery.isEmpty) {
      _filteredApps = List.from(_allApps);
    } else {
      final query = _searchQuery.toLowerCase();
      _filteredApps = _allApps.where((app) {
        return app.displayName.toLowerCase().contains(query) ||
               app.packageName.toLowerCase().contains(query);
      }).toList();
      
      // Limit results for performance
      if (_filteredApps.length > AppConstants.maxSearchResults) {
        _filteredApps = _filteredApps.take(AppConstants.maxSearchResults).toList();
      }
    }
  }

  void _updateFavoriteApps() {
    _favoriteApps = _allApps.where((app) => app.isFavorite).toList();
  }

  void _updateMostUsedApps() {
    final usedApps = _allApps.where((app) => app.usageCount > 0).toList();
    usedApps.sort((a, b) {
      final usageComparison = b.usageCount.compareTo(a.usageCount);
      if (usageComparison != 0) return usageComparison;
      return b.lastUsed.compareTo(a.lastUsed);
    });
    _mostUsedApps = usedApps.take(AppConstants.mostUsedCount).toList();
  }

  Future<void> launchApp(AppInfo app) async {
    try {
      final launched = await DeviceApps.openApp(app.packageName);
      if (launched) {
        app.incrementUsage();
        await _updateAppInCache(app);
        _updateMostUsedApps();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error launching app ${app.packageName}: $e');
    }
  }

  Future<void> toggleFavorite(AppInfo app) async {
    app.toggleFavorite();
    await _updateAppInCache(app);
    _updateFavoriteApps();
    notifyListeners();
  }

  Future<void> hideApp(AppInfo app) async {
    app.toggleHidden();
    _allApps.removeWhere((a) => a.packageName == app.packageName);
    await _updateAppInCache(app);
    _updateFilteredApps();
    _updateFavoriteApps();
    _updateMostUsedApps();
    notifyListeners();
  }

  Future<void> renameApp(AppInfo app, String newName) async {
    app.setCustomName(newName);
    await _updateAppInCache(app);
    
    // Re-sort if the name changed
    _allApps.sort((a, b) => a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase()));
    _updateFilteredApps();
    notifyListeners();
  }

  Future<void> _updateAppInCache(AppInfo app) async {
    if (_database == null) return;

    try {
      await _database!.update(
        'apps',
        {
          'usageCount': app.usageCount,
          'lastUsed': app.lastUsed.toIso8601String(),
          'isFavorite': app.isFavorite ? 1 : 0,
          'isHidden': app.isHidden ? 1 : 0,
          'customName': app.customName,
        },
        where: 'packageName = ?',
        whereArgs: [app.packageName],
      );
    } catch (e) {
      debugPrint('Error updating app in cache: $e');
    }
  }

  Future<void> openAppInfo(AppInfo app) async {
    try {
      final intent = AndroidIntent(
        action: 'android.settings.APPLICATION_DETAILS_SETTINGS',
        data: 'package:${app.packageName}',
      );
      await intent.launch();
    } catch (e) {
      debugPrint('Error opening app info: $e');
    }
  }

  Future<void> uninstallApp(AppInfo app) async {
    try {
      if (app.isSystemApp) {
        // For system apps, just hide them
        await hideApp(app);
        return;
      }

      final intent = AndroidIntent(
        action: 'android.intent.action.DELETE',
        data: 'package:${app.packageName}',
      );
      await intent.launch();
    } catch (e) {
      debugPrint('Error uninstalling app: $e');
    }
  }

  Future<void> createShortcut(AppInfo app) async {
    try {
      // Request permission for shortcut creation
      if (await Permission.systemAlertWindow.request().isGranted) {
        final intent = AndroidIntent(
          action: 'com.android.launcher.action.INSTALL_SHORTCUT',
          arguments: {
            'android.intent.extra.shortcut.INTENT': {
              'action': 'android.intent.action.MAIN',
              'category': 'android.intent.category.LAUNCHER',
              'component': app.packageName,
            },
            'android.intent.extra.shortcut.NAME': app.displayName,
            'duplicate': false,
          },
        );
        await intent.launch();
      }
    } catch (e) {
      debugPrint('Error creating shortcut: $e');
    }
  }

  void clearSearch() {
    _searchQuery = '';
    _updateFilteredApps();
    notifyListeners();
  }

  @override
  void dispose() {
    _searchDebouncer?.cancel();
    _database?.close();
    super.dispose();
  }
} 