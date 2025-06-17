import 'package:flutter/material.dart';
import '../models/app_info.dart';
import 'app_item_widget.dart';

class AppGridWidget extends StatelessWidget {
  final List<AppInfo> apps;
  final int appsPerRow;
  final double iconSize;
  final Function(AppInfo) onAppTap;
  final Function(AppInfo) onAppLongPress;

  const AppGridWidget({
    super.key,
    required this.apps,
    required this.appsPerRow,
    required this.iconSize,
    required this.onAppTap,
    required this.onAppLongPress,
  });

  @override
  Widget build(BuildContext context) {
    if (apps.isEmpty) {
      return _buildEmptyState(context);
    }

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: appsPerRow,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              childAspectRatio: 0.85,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index >= apps.length) return null;
                
                final app = apps[index];
                return AppItemWidget(
                  app: app,
                  iconSize: iconSize,
                  onTap: () => onAppTap(app),
                  onLongPress: () => onAppLongPress(app),
                );
              },
              childCount: apps.length,
              // Enable semantic indexing for better performance
              addSemanticIndexes: false,
            ),
          ),
        ),
        
        // Add some bottom padding
        const SliverPadding(
          padding: EdgeInsets.only(bottom: 80),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: theme.colorScheme.onSurface.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'No apps found',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or refresh the app list',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
} 