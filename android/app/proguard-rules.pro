# Flutter embedding — keep the engine/plugin entry points R8 cannot see.
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.embedding.**

# Our components are instantiated by the framework via the manifest. AGP keeps
# manifest-referenced classes, but pin them explicitly to be safe.
-keep class com.khanhpham.timestamp.MainActivity { *; }
-keep class com.khanhpham.timestamp.ScreenRecordService { *; }
