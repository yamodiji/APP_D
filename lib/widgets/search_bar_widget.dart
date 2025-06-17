import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../providers/settings_provider.dart';
import '../utils/constants.dart';

class SearchBarWidget extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onClear;
  final VoidCallback onSettingsPressed;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onClear,
    required this.onSettingsPressed,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  void initState() {
    super.initState();
    // Ensure keyboard shows when autofocus is enabled
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settingsProvider = context.read<SettingsProvider>();
      if (settingsProvider.showKeyboard && widget.focusNode.hasFocus) {
        SystemChannels.textInput.invokeMethod('TextInput.show');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, SettingsProvider>(
      builder: (context, themeProvider, settingsProvider, child) {
        return Container(
          decoration: BoxDecoration(
            color: themeProvider.getSurfaceColor(context),
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            border: Border.all(
              color: themeProvider.getTextColor(context).withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Search icon
              Padding(
                padding: const EdgeInsets.only(
                  left: AppConstants.paddingMedium,
                ),
                child: Icon(
                  Icons.search,
                  color: themeProvider.getTextColor(context).withOpacity(0.6),
                  size: 20,
                ),
              ),
              
              // Search input field
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  autofocus: settingsProvider.showKeyboard,
                  style: TextStyle(
                    color: themeProvider.getTextColor(context),
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search apps...',
                    hintStyle: TextStyle(
                      color: themeProvider.getTextColor(context).withOpacity(0.5),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingMedium,
                      vertical: AppConstants.paddingMedium,
                    ),
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) {
                    // Keep focus on search bar after submit
                    if (settingsProvider.showKeyboard) {
                      widget.focusNode.requestFocus();
                    }
                  },
                ),
              ),
              
              // Clear button
              if (widget.controller.text.isNotEmpty)
                IconButton(
                  onPressed: widget.onClear,
                  icon: Icon(
                    Icons.clear,
                    color: themeProvider.getTextColor(context).withOpacity(0.6),
                  ),
                  iconSize: 20,
                  tooltip: 'Clear',
                ),
              
              // Settings button
              IconButton(
                onPressed: widget.onSettingsPressed,
                icon: Icon(
                  Icons.settings,
                  color: themeProvider.getTextColor(context).withOpacity(0.6),
                ),
                iconSize: 20,
                tooltip: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
} 