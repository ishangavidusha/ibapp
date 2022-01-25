import 'package:flutter/material.dart';

class AppTheme {
  final Color _primary = Colors.deepPurple;
  final Color _primaryVariant = Colors.deepPurple.shade800;
  final Color _secondary = const Color(0xFF171C26);
  final Color _secondaryVariant = const Color(0xFF000000);
  final Color _surface = const Color(0xFFF5F7FA);
  final Color _background = Colors.deepPurple.shade50;
  final Color _error = const Color(0xFFFF5555);
  final Color _onPrimary = const Color(0xFFF5F7FA);
  final Color _onSecondary = const Color(0xFFFFC833);
  final Color _onSurface = const Color(0xFF171C26);
  final Color _onBackground = const Color(0xFF171C26);
  final Color _onError = const Color(0xFFF5F7FA);
  final Color _appBlue = const Color(0xFF6678FF);
  final Color _appGreen = const Color(0xFF00C569);
  final Color _appRed = const Color(0xFFFF5555);
  final Brightness _brightness = Brightness.light;

  Color get primary => _primary;
  Color get secondary => _secondary;
  Color get primaryText => shift(_primary, 0.1, stronger: true);
  Color get secondaryText => shift(_secondary, 0.2, stronger: false);
  Color get surface => _surface;
  Color get background => _background;
  Color get blue => _appBlue;
  Color get green => _appGreen;
  Color get red => _appRed;

  ColorScheme get colorScheme {
    return ColorScheme(
      primary: _primary,
      primaryVariant: _primaryVariant,
      secondary: _secondary,
      secondaryVariant: _secondaryVariant,
      surface: _surface,
      background: _background,
      error: _error,
      onPrimary: _onPrimary,
      onSecondary: _onSecondary,
      onSurface: _onSurface,
      onBackground: _onBackground,
      onError: _onError,
      brightness: _brightness,
    );
  }

  /// This will add luminance in dark mode, and remove it in light.
  // Allows the view to just make something "stronger" or "weaker" without worrying what the current theme brightness is
  //      color = theme.shift(someColor, .1); //-10% lum in dark mode, +10% in light mode
  Color shift(Color c, double amt, {bool stronger = true}) {
    amt *= (stronger ? -1 : 1);
    var hslc = HSLColor.fromColor(c); // Convert to HSL
    double lightness = (hslc.lightness + amt).clamp(0, 1.0).toDouble(); // Add/Remove lightness
    return hslc.withLightness(lightness).toColor(); // Convert back to Color
  }
}