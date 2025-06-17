import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/app_info.dart';

class AppItemWidget extends StatefulWidget {
  final AppInfo app;
  final double iconSize;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const AppItemWidget({
    super.key,
    required this.app,
    required this.iconSize,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  State<AppItemWidget> createState() => _AppItemWidgetState();
}

class _AppItemWidgetState extends State<AppItemWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();
    HapticFeedback.lightImpact();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: widget.onTap,
            onLongPress: widget.onLongPress,
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: _isPressed
                    ? theme.colorScheme.surface.withOpacity(0.8)
                    : Colors.transparent,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Icon
                  Container(
                    width: widget.iconSize,
                    height: widget.iconSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.iconSize * 0.2),
                      boxShadow: [
                        BoxShadow(
                          color: theme.shadowColor.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(widget.iconSize * 0.2),
                      child: _buildAppIcon(theme),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // App Name
                  Text(
                    widget.app.displayName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  // Favorite Indicator
                  if (widget.app.isFavorite)
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.favorite,
                        size: 12,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppIcon(ThemeData theme) {
    if (widget.app.icon != null) {
      try {
        final Uint8List iconBytes = base64Decode(widget.app.icon!);
        return Image.memory(
          iconBytes,
          width: widget.iconSize,
          height: widget.iconSize,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildFallbackIcon(theme),
        );
      } catch (e) {
        return _buildFallbackIcon(theme);
      }
    }
    return _buildFallbackIcon(theme);
  }

  Widget _buildFallbackIcon(ThemeData theme) {
    return Container(
      width: widget.iconSize,
      height: widget.iconSize,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withOpacity(0.8),
            theme.colorScheme.secondary.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(widget.iconSize * 0.2),
      ),
      child: Icon(
        Icons.android,
        size: widget.iconSize * 0.6,
        color: theme.colorScheme.onPrimary,
      ),
    );
  }
} 