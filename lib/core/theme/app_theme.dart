import 'package:flutter/material.dart';

/// Recursos visuales comunes a toda la aplicación.
abstract final class AppTheme {
  /// Paleta propia de TaskFlow (verde azulado).
  static const Color seedColor = Color(0xFF256D85);

  static ThemeData get light => ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
        useMaterial3: true,
      );
}
