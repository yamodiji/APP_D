import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_info.dart';
import '../providers/theme_provider.dart';
import '../providers/settings_provider.dart';
import '../utils/constants.dart';

class AppGridWidget extends StatelessWidget {
  final List<AppInfo> apps;
  final Function(AppInfo) onAppTap;
  final Function(AppInfo) onAppLongPress;

  const AppGridWidget({
    super.key,
    required this.apps,
    required this.onAppTap,
    required this.onAppLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, SettingsProvider>(
      builder: (context, themeProvider, settingsProvider, child) {
        if (apps.isEmpty) {
          return Center(
            child: Text(
              'No apps found',
              style: TextStyle(
                color: themeProvider.getTextColor(context),
                fontSize: 16,
              ),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _getCrossAxisCount(context, settingsProvider.iconSize),
            childAspectRatio: 0.8,
            crossAxisSpacing: AppConstants.paddingSmall,
            mainAxisSpacing: AppConstants.paddingSmall,
          ),
          itemCount: apps.length,
          itemBuilder: (context, index) {
            final app = apps[index];
            return GestureDetector(
              onTap: () => onAppTap(app),
              onLongPress: () => onAppLongPress(app),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App icon
                  Container(
                    width: settingsProvider.iconSize,
                    height: settingsProvider.iconSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: app.icon != null
                          ? Image.memory(
                              app.icon!,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              color: themeProvider.getSurfaceColor(context),
                              child: Icon(
                                Icons.android,
                                size: settingsProvider.iconSize * 0.6,
                                color: themeProvider.getTextColor(context),
                              ),
                            ),
                    ),
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // App name
                  Text(
                    app.displayName,
                    style: TextStyle(
                      color: themeProvider.getTextColor(context),
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  int _getCrossAxisCount(BuildContext context, double iconSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = iconSize + 32; // icon + padding
    return (screenWidth / itemWidth).floor().clamp(3, 6);
  }
} 