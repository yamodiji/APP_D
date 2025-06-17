import 'package:flutter/material.dart';
import '../models/app_info.dart';
import 'app_item_widget.dart';

class QuickActionsWidget extends StatelessWidget {
  final List<AppInfo> favoriteApps;
  final List<AppInfo> mostUsedApps;
  final Function(AppInfo) onAppTap;
  final Function(AppInfo) onAppLongPress;

  const QuickActionsWidget({
    super.key,
    required this.favoriteApps,
    required this.mostUsedApps,
    required this.onAppTap,
    required this.onAppLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Favorites Section
        if (favoriteApps.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Icon(
                  Icons.favorite,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Favorites',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          _buildHorizontalAppList(favoriteApps),
        ],
        
        // Most Used Section
        if (mostUsedApps.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Icon(
                  Icons.trending_up,
                  size: 20,
                  color: theme.colorScheme.secondary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Most Used',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
          _buildHorizontalAppList(mostUsedApps),
        ],
      ],
    );
  }

  Widget _buildHorizontalAppList(List<AppInfo> apps) {
    return Container(
      height: 100,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: apps.length,
        itemBuilder: (context, index) {
          final app = apps[index];
          return Container(
            width: 80,
            margin: const EdgeInsets.only(right: 12),
            child: AppItemWidget(
              app: app,
              iconSize: 48,
              onTap: () => onAppTap(app),
              onLongPress: () => onAppLongPress(app),
            ),
          );
        },
      ),
    );
  }
} 