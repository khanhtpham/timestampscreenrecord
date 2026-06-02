import 'package:flutter/material.dart';

/// Brand accents — identical in both themes so the product keeps its identity.
const kAccent = Color(0xFFFF3B5C);
const kCyanDark = Color(0xFF2DE0FF);
const kCyanLight = Color(0xFF0E9FBF);

/// Semantic colors resolved per brightness, exposed as a [ThemeExtension] so
/// widgets read them via `Theme.of(context).extension<AppColors>()`.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.surface,
    required this.surfaceHigh,
    required this.accent,
    required this.cyan,
    required this.textPrimary,
    required this.textSecondary,
    required this.hairline,
  });

  final Color background;
  final Color surface;
  final Color surfaceHigh;
  final Color accent;
  final Color cyan;
  final Color textPrimary;
  final Color textSecondary;
  final Color hairline;

  static const dark = AppColors(
    background: Color(0xFF0E0A1A),
    surface: Color(0xFF1A1330),
    surfaceHigh: Color(0xFF241A3D),
    accent: kAccent,
    cyan: kCyanDark,
    textPrimary: Colors.white,
    textSecondary: Color(0x99FFFFFF),
    hairline: Color(0x14FFFFFF),
  );

  static const light = AppColors(
    background: Color(0xFFF5F3FB),
    surface: Color(0xFFFFFFFF),
    surfaceHigh: Color(0xFFEDE8F7),
    accent: kAccent,
    cyan: kCyanLight,
    textPrimary: Color(0xFF1A1330),
    textSecondary: Color(0x8C1A1330),
    hairline: Color(0x141A1330),
  );

  @override
  AppColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceHigh,
    Color? accent,
    Color? cyan,
    Color? textPrimary,
    Color? textSecondary,
    Color? hairline,
  }) {
    return AppColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceHigh: surfaceHigh ?? this.surfaceHigh,
      accent: accent ?? this.accent,
      cyan: cyan ?? this.cyan,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      hairline: hairline ?? this.hairline,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceHigh: Color.lerp(surfaceHigh, other.surfaceHigh, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      cyan: Color.lerp(cyan, other.cyan, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      hairline: Color.lerp(hairline, other.hairline, t)!,
    );
  }
}

ThemeData _baseTheme(Brightness brightness, AppColors colors) {
  final scheme = ColorScheme.fromSeed(
    seedColor: kAccent,
    brightness: brightness,
  ).copyWith(surface: colors.surface, secondary: colors.cyan);

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: colors.background,
    extensions: [colors],
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
    ),
  );
}

ThemeData buildLightTheme() => _baseTheme(Brightness.light, AppColors.light);

ThemeData buildDarkTheme() => _baseTheme(Brightness.dark, AppColors.dark);
