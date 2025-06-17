import 'package:device_apps/device_apps.dart';

class AppInfo {
  final String packageName;
  final String appName;
  final String? icon;
  final bool isSystemApp;
  final bool isEnabled;
  final String? versionName;
  final int? versionCode;
  int usageCount;
  DateTime lastUsed;
  bool isFavorite;
  bool isHidden;
  String? customName;
  
  AppInfo({
    required this.packageName,
    required this.appName,
    this.icon,
    this.isSystemApp = false,
    this.isEnabled = true,
    this.versionName,
    this.versionCode,
    this.usageCount = 0,
    DateTime? lastUsed,
    this.isFavorite = false,
    this.isHidden = false,
    this.customName,
  }) : lastUsed = lastUsed ?? DateTime.now();

  factory AppInfo.fromApplication(Application app) {
    return AppInfo(
      packageName: app.packageName,
      appName: app.appName,
      icon: app is ApplicationWithIcon ? app.icon : null,
      isSystemApp: app.systemApp,
      isEnabled: app.enabled,
      versionName: app.versionName,
      versionCode: app.versionCode,
    );
  }

  factory AppInfo.fromJson(Map<String, dynamic> json) {
    return AppInfo(
      packageName: json['packageName'] ?? '',
      appName: json['appName'] ?? '',
      icon: json['icon'],
      isSystemApp: json['isSystemApp'] ?? false,
      isEnabled: json['isEnabled'] ?? true,
      versionName: json['versionName'],
      versionCode: json['versionCode'],
      usageCount: json['usageCount'] ?? 0,
      lastUsed: DateTime.tryParse(json['lastUsed'] ?? '') ?? DateTime.now(),
      isFavorite: json['isFavorite'] ?? false,
      isHidden: json['isHidden'] ?? false,
      customName: json['customName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'packageName': packageName,
      'appName': appName,
      'icon': icon,
      'isSystemApp': isSystemApp,
      'isEnabled': isEnabled,
      'versionName': versionName,
      'versionCode': versionCode,
      'usageCount': usageCount,
      'lastUsed': lastUsed.toIso8601String(),
      'isFavorite': isFavorite,
      'isHidden': isHidden,
      'customName': customName,
    };
  }

  String get displayName => customName ?? appName;

  void incrementUsage() {
    usageCount++;
    lastUsed = DateTime.now();
  }

  void toggleFavorite() {
    isFavorite = !isFavorite;
  }

  void toggleHidden() {
    isHidden = !isHidden;
  }

  void setCustomName(String? name) {
    customName = name?.isEmpty == true ? null : name;
  }

  AppInfo copyWith({
    String? packageName,
    String? appName,
    String? icon,
    bool? isSystemApp,
    bool? isEnabled,
    String? versionName,
    int? versionCode,
    int? usageCount,
    DateTime? lastUsed,
    bool? isFavorite,
    bool? isHidden,
    String? customName,
  }) {
    return AppInfo(
      packageName: packageName ?? this.packageName,
      appName: appName ?? this.appName,
      icon: icon ?? this.icon,
      isSystemApp: isSystemApp ?? this.isSystemApp,
      isEnabled: isEnabled ?? this.isEnabled,
      versionName: versionName ?? this.versionName,
      versionCode: versionCode ?? this.versionCode,
      usageCount: usageCount ?? this.usageCount,
      lastUsed: lastUsed ?? this.lastUsed,
      isFavorite: isFavorite ?? this.isFavorite,
      isHidden: isHidden ?? this.isHidden,
      customName: customName ?? this.customName,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppInfo &&
          runtimeType == other.runtimeType &&
          packageName == other.packageName;

  @override
  int get hashCode => packageName.hashCode;

  @override
  String toString() {
    return 'AppInfo{packageName: $packageName, appName: $appName, usageCount: $usageCount}';
  }
} 