# Reglas ProGuard para el APK release
# Flutter necesita estas reglas para que el APK funcione correctamente

-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**
