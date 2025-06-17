# High-Performance Android App Drawer

A blazing-fast, customizable Android app drawer built with Flutter, designed for productivity and speed.

## Features

- **⚡ Instant Search**: Auto-focused search with fuzzy matching
- **⭐ Smart Favorites**: Easily mark and access your favorite apps
- **📊 Usage Tracking**: Automatically surfaces your most-used apps
- **🎨 Customizable Themes**: Dark/light themes with adjustable icon sizes
- **🚀 Performance Optimized**: Efficient rendering with SliverGrid
- **⌨️ Quick Actions**: Keyboard shortcuts and gesture support
- **🏠 Launcher Replacement**: Option to replace your default Android launcher

## Screenshots

*Screenshots will be added after initial testing*

## Installation

### Option 1: Download APK
1. Go to the [Releases](https://github.com/yamodiji/APP_D/releases) page
2. Download the latest APK file
3. Install on your Android device (enable "Install from unknown sources" if needed)

### Option 2: Build from Source
```bash
# Clone the repository
git clone https://github.com/yamodiji/APP_D.git
cd APP_D

# Get Flutter dependencies
flutter pub get

# Build APK
flutter build apk --release
```

## Requirements

- Android 6.0 (API level 23) or higher
- Flutter 3.24.0 or higher (for development)

## Configuration

### Setting as Default Launcher
1. Open your device's Settings
2. Go to Apps & notifications > Default apps > Home app
3. Select "App Drawer" from the list

### Customization
- **Themes**: Access via settings drawer (swipe from right edge)
- **Icon Size**: Adjustable in settings (Small, Medium, Large)
- **Favorites**: Long-press any app to add/remove from favorites
- **Search**: Search is auto-focused when opening the drawer

## Architecture

The app follows a clean architecture pattern with:

- **Models**: Data structures for app information
- **Providers**: State management using Provider pattern
- **Screens**: Main UI screens
- **Widgets**: Reusable UI components
- **Utils**: Constants and utility functions

## Development

### Project Structure
```
lib/
├── main.dart              # App entry point
├── models/
│   └── app_info.dart     # App data model
├── providers/
│   ├── app_provider.dart      # App state management
│   ├── theme_provider.dart    # Theme management
│   └── settings_provider.dart # Settings management
├── screens/
│   └── home_screen.dart      # Main app screen
├── widgets/
│   ├── app_grid_widget.dart     # App grid display
│   ├── app_item_widget.dart     # Individual app items
│   ├── quick_actions_widget.dart # Quick action buttons
│   ├── search_bar_widget.dart   # Search functionality
│   └── settings_drawer.dart     # Settings panel
└── utils/
    └── constants.dart           # App constants
```

### Key Dependencies
- `flutter`: Framework
- `provider`: State management
- `shared_preferences`: Local storage
- `device_apps`: Installed apps access
- `fuzzy`: Fuzzy search functionality

## Performance Features

- **Debounced Search**: 100ms delay to prevent excessive filtering
- **Efficient Rendering**: SliverGrid for smooth scrolling
- **Smart Caching**: App list cached with SharedPreferences
- **Optimized Images**: Efficient app icon loading

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the [MIT License](LICENSE).

## Support

If you encounter any issues or have suggestions, please [create an issue](https://github.com/yamodiji/APP_D/issues) on GitHub.

---

Built with ❤️ using Flutter 