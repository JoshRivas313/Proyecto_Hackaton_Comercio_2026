import 'package:flutter/material.dart';

/// Sistema de diseño de "Red del barrio": paleta Barrio Vivo (fuente única de colores).
///
///  · Violeta  #5635B8 — marca, navegación y botones principales
///  · Coral    #FF795F — acciones comunitarias y destacados
///  · Crema    #FFF7ED — fondo general (superficies en blanco)
///  · Oscuro   #30283B — textos y títulos
///  · Verde    #16816B — confianza, disponibilidad y confirmaciones
///  · Amarillo #F5C863 — acentos ilustrativos
///  · Rojo     #C73535 — reservado a emergencia
///
/// Las pantallas NO escriben colores HEX: usan estos tokens o el ColorScheme del tema.
class AppTheme {
  AppTheme._();

  static const brand = Color(0xFF5635B8);
  static const lilac = Color(0xFFE9E3FF);
  static const peach = Color(0xFFFFD9BF);
  static const confirmed = Color(0xFF16816B);
  static const emergencyRed = Color(0xFFC73535);

  // Acentos del sistema "Barrio cálido" (texto oscuro sobre cada uno, contraste AA).
  static const deepViolet = Color(0xFF3B2790);
  static const coral = Color(0xFFFF795F); // acción principal · texto #2A1670
  static const coralSoft = Color(0xFFFFE1D6);
  static const sun = Color(0xFFF5C863); // texto #4A1F00
  static const mint = Color(0xFFBDEFD3); // texto #0B3D2E
  static const sky = Color(0xFFCDE7FF); // texto #12304D
  static const cream = Color(0xFFFFF7ED);

  // --- Texto y neutros ---
  static const ink = Color(0xFF30283B); // texto y títulos
  static const outlineSoft = Color(0xFFEBDCCB); // contornos suaves sobre crema

  // --- Texto sobre cada acento (contraste AA) ---
  static const onCoral = Color(0xFF2A1670); // sobre coral
  static const onSun = Color(0xFF4A1F00); // sobre amarillo y coral suave
  static const onMint = Color(0xFF0B3D2E); // sobre menta y verde suave
  static const onSky = Color(0xFF12304D); // sobre cielo
  static const onPink = Color(0xFF5A0F33); // sobre rosa suave
  static const onLime = Color(0xFF244A0B); // sobre lima suave
  static const onRedSoft = Color(0xFF5C0F06); // sobre rojo suave
  static const onTeal = Color(0xFF063F3C); // sobre verde azulado suave

  // --- Variantes suaves (fondos) ---
  static const redSoft = Color(0xFFFCE6E3); // advertencias y llamadas
  static const greenSoft = Color(0xFFE3F4EF); // apoyo comunitario y logros
  static const sunSoft = Color(0xFFFFF0C2);
  static const pinkSoft = Color(0xFFFFDDEB);
  static const limeSoft = Color(0xFFE3F3D3);
  static const tealSoft = Color(0xFFD5EEEB);
  static const violetTint = Color(0xFFF6F0FF); // anillos del radar
  static const violetLine = Color(0xFFCDBDF2); // líneas del radar
  static const brandLight = Color(0xFF7B58DA); // degradado de marca

  // --- Sombras ---
  static const shadowBrand = Color(0x665635B8);
  static const shadowInk = Color(0x1F30283B);
  static const shadowNav = Color(0x143B2790);
  static const shadowSoft = Color(0x40000000);

  static const _light = ColorScheme(
    brightness: Brightness.light,
    primary: brand,
    onPrimary: Colors.white,
    primaryContainer: lilac,
    onPrimaryContainer: Color(0xFF3B2790),
    secondary: Color(0xFF9A4A12),
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFFFE1D6),
    onSecondaryContainer: Color(0xFF3A1D00),
    tertiary: confirmed,
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFD5EEEB),
    onTertiaryContainer: Color(0xFF063F3C),
    error: emergencyRed,
    onError: Colors.white,
    errorContainer: Color(0xFFFDE5E1),
    onErrorContainer: Color(0xFF5C0F06),
    surface: Color(0xFFFFF7ED),
    onSurface: Color(0xFF30283B),
    onSurfaceVariant: Color(0xFF5E5873),
    outline: Color(0xFF7A7490),
    outlineVariant: Color(0xFFEBDCCB),
    surfaceContainerLowest: Colors.white,
    surfaceContainerLow: Color(0xFFFFF1E2),
    surfaceContainer: Color(0xFFFCE9D6),
    surfaceContainerHigh: Color(0xFFF7E1CB),
    surfaceContainerHighest: Color(0xFFF1D9C0),
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
