import 'package:flutter/material.dart';

/// Sistema de diseño de "Red del barrio" (Fase 3).
///
/// Paleta (todas las parejas texto/fondo verificadas ≥ 4,5:1, WCAG AA):
///  · Morado marca  #5B3FC4 — identidad, botones, navegación
///  · Lila suave    #E9E3FF — fondos de tarjetas y chips
///  · Durazno cálido #FFD9BF — calidez: etiquetas y destacados
///  · Verde confirmado #0A6B66 — SOLO "hecho / enviado / real"
///  · Rojo emergencia #C42B1A — reservado a emergencia
class AppTheme {
  AppTheme._();

  static const brand = Color(0xFF5B3FC4);
  static const lilac = Color(0xFFE9E3FF);
  static const peach = Color(0xFFFFD9BF);
  static const confirmed = Color(0xFF0A6B66);
  static const emergencyRed = Color(0xFFC42B1A);

  static const _light = ColorScheme(
    brightness: Brightness.light,
    primary: brand,
    onPrimary: Colors.white,
    primaryContainer: lilac,
    onPrimaryContainer: Color(0xFF3B2790),
    secondary: Color(0xFF9A4A12),
    onSecondary: Colors.white,
    secondaryContainer: peach,
    onSecondaryContainer: Color(0xFF3A1D00),
    tertiary: confirmed,
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFD5EEEB),
    onTertiaryContainer: Color(0xFF063F3C),
    error: emergencyRed,
    onError: Colors.white,
    errorContainer: Color(0xFFFDE5E1),
    onErrorContainer: Color(0xFF5C0F06),
    surface: Color(0xFFF8F6FF),
    onSurface: Color(0xFF1F1A33),
    onSurfaceVariant: Color(0xFF5E5873),
    outline: Color(0xFF7A7490),
    outlineVariant: Color(0xFFD9D2F0),
    surfaceContainerLowest: Colors.white,
    surfaceContainerLow: Color(0xFFF3F0FF),
    surfaceContainer: Color(0xFFEFEBFB),
    surfaceContainerHigh: Color(0xFFE9E3FF),
    surfaceContainerHighest: Color(0xFFE3DCF8),
  );

  static const _dark = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFB9A8FF),
    onPrimary: Color(0xFF2A1670),
    primaryContainer: Color(0xFF43309A),
    onPrimaryContainer: Color(0xFFE9E3FF),
    secondary: Color(0xFFFFB68A),
    onSecondary: Color(0xFF3A1D00),
    secondaryContainer: Color(0xFF5A3512),
    onSecondaryContainer: Color(0xFFFFD9BF),
    tertiary: Color(0xFF7FD6CD),
    onTertiary: Color(0xFF00322F),
    tertiaryContainer: Color(0xFF14504C),
    onTertiaryContainer: Color(0xFFD5EEEB),
    error: Color(0xFFFF8F7F),
    onError: Color(0xFF3A0904),
    errorContainer: Color(0xFF6E1A10),
    onErrorContainer: Color(0xFFFDE5E1),
    surface: Color(0xFF15121F),
    onSurface: Color(0xFFECE8FF),
    onSurfaceVariant: Color(0xFFC5BEDD),
    outline: Color(0xFF8F88A8),
    outlineVariant: Color(0xFF3C3556),
    surfaceContainerLowest: Color(0xFF100D19),
    surfaceContainerLow: Color(0xFF1C1829),
    surfaceContainer: Color(0xFF211D30),
    surfaceContainerHigh: Color(0xFF2A253B),
    surfaceContainerHighest: Color(0xFF352F49),
  );

  /// Emergencia: rojo claramente distinto del resto de la app.
  static const _emergency = ColorScheme(
    brightness: Brightness.light,
    primary: emergencyRed,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFFDE5E1),
    onPrimaryContainer: Color(0xFF5C0F06),
    secondary: Color(0xFF9A4A12),
    onSecondary: Colors.white,
    secondaryContainer: peach,
    onSecondaryContainer: Color(0xFF3A1D00),
    tertiary: Color(0xFF7A5200),
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFFFE9A8),
    onTertiaryContainer: Color(0xFF3F2A00),
    error: emergencyRed,
    onError: Colors.white,
    errorContainer: Color(0xFFFDE5E1),
    onErrorContainer: Color(0xFF5C0F06),
    surface: Color(0xFFFFF8F7),
    onSurface: Color(0xFF2B1512),
    onSurfaceVariant: Color(0xFF6B4A45),
    outline: Color(0xFF8E6B65),
    outlineVariant: Color(0xFFF0CFC9),
    surfaceContainerLowest: Colors.white,
    surfaceContainerLow: Color(0xFFFFF1EF),
    surfaceContainer: Color(0xFFFFE9E6),
    surfaceContainerHigh: Color(0xFFFDE0DC),
    surfaceContainerHighest: Color(0xFFF8D6D1),
  );

  static ThemeData light() => _build(_light);
  static ThemeData dark() => _build(_dark);
  static ThemeData emergency() => _build(_emergency);

  static ThemeData _build(ColorScheme s) {
    final base = ThemeData(useMaterial3: true, colorScheme: s);
    final text = base.textTheme.copyWith(
      headlineMedium: base.textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.w800,
      ),
      headlineSmall: base.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w800,
      ),
      titleLarge: base.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      titleMedium: base.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      bodyMedium: base.textTheme.bodyMedium?.copyWith(
        fontSize: 15,
        height: 1.4,
      ),
      bodyLarge: base.textTheme.bodyLarge?.copyWith(fontSize: 16, height: 1.4),
    );
    final round = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    );
    return base.copyWith(
      textTheme: text,
      scaffoldBackgroundColor: s.surface,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      appBarTheme: AppBarTheme(
        backgroundColor: s.surface,
        foregroundColor: s.onSurface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        titleTextStyle: text.titleLarge?.copyWith(
          color: s.onSurface,
          fontWeight: FontWeight.w800,
        ),
      ),
      cardTheme: CardThemeData(
        color: s.surfaceContainerLowest,
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: s.outlineVariant),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 52),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: const StadiumBorder(),
          side: BorderSide(color: s.primary, width: 1.5),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        side: BorderSide(color: s.outlineVariant),
        backgroundColor: s.surfaceContainerLowest,
        selectedColor: s.primaryContainer,
        labelStyle: TextStyle(color: s.onSurface, fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: s.surfaceContainerLowest,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: s.outline),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 76,
        backgroundColor: s.surfaceContainerLowest,
        indicatorColor: s.primaryContainer,
        indicatorShape: const StadiumBorder(),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? s.onPrimaryContainer
                : s.onSurfaceVariant,
          ),
        ),
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: s.onSurface,
          ),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: s.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      dialogTheme: DialogThemeData(backgroundColor: s.surface, shape: round),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: s.onSurface,
        contentTextStyle: TextStyle(color: s.surface, fontSize: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: s.primary,
        foregroundColor: s.onPrimary,
        extendedTextStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
