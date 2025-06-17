import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;
  final VoidCallback onClear;
  final bool isLoading;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onClear,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Search apps...',
          prefixIcon: isLoading
              ? Container(
                  width: 20,
                  height: 20,
                  padding: const EdgeInsets.all(12),
                  child: const CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.search),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: onClear,
                  tooltip: 'Clear search',
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: theme.colorScheme.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        style: theme.textTheme.bodyLarge,
      ),
    );
  }
} 