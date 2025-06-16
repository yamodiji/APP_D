# Add project specific ProGuard rules here.

# Keep Flutter and Dart runtime
-keep class io.flutter.** { *; }
-keep class dart.** { *; }

# Keep device_apps plugin classes
-keep class com.example.device_apps.** { *; }
-keep class fr.g123k.deviceapps.** { *; }

# Keep shared_preferences plugin
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# Keep provider classes
-keep class ** extends androidx.lifecycle.ViewModel { *; }

# Keep JSON serialization
-keepattributes *Annotation*
-keepclassmembers class ** {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep custom app classes
-keep class com.speedDrawer.speed_drawer.** { *; }

# Prevent optimization of performance-critical code
-dontoptimize
-dontobfuscate 