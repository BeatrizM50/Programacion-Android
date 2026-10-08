import 'package:flutter/material.dart';

// Sistema de tema minimalista editorial ReNotes.
// Paleta clara: "Academic Editorial Notebook" (marfil + terracota + burdeos).
// Paleta oscura: "Academic Deep Wine Minimal" (vino profundo + terracota).
// Sin sombras duras: jerarquía por capas tonales y bordes hairline.

class AppTheme {
  AppTheme._();

  // ---------- Claro ----------
  static const _lightPrimary = Color(0xFF954335);
  static const _lightOnPrimary = Color(0xFFFFFFFF);
  static const _lightPrimaryContainer = Color(0xFFFFDAD4);
  static const _lightOnPrimaryContainer = Color(0xFF3F0301);
  static const _lightSecondary = Color(0xFF8F4955);
  static const _lightSecondaryContainer = Color(0xFFFEA6B3);
  static const _lightOnSecondaryContainer = Color(0xFF7A3844);
  static const _lightTertiary = Color(0xFF954050);
  static const _lightError = Color(0xFFBA1A1A);

  static const _lightSurface = Color(0xFFFFF8F7);
  static const _lightLowest = Color(0xFFFFFFFF);
  static const _lightLow = Color(0xFFFFF0F1);
  static const _lightContainer = Color(0xFFFFE9EB);
  static const _lightHigh = Color(0xFFFFE1E4);
  static const _lightHighest = Color(0xFFFFD9DE);
  static const _lightOnSurface = Color(0xFF360C17);
  static const _lightOnVariant = Color(0xFF55423F);
  static const _lightOutline = Color(0xFF88726E);
  static const _lightOutlineVariant = Color(0xFFDBC1BC);

  // ---------- Oscuro ----------
  static const _darkPrimary = Color(0xFFFFB4A7);
  static const _darkOnPrimary = Color(0xFF5C180F);
  static const _darkPrimaryContainer = Color(0xFFD67565);
  static const _darkOnPrimaryContainer = Color(0xFF531209);
  static const _darkSecondary = Color(0xFFFEB5A4);
  static const _darkSecondaryContainer = Color(0xFF6C382D);
  static const _darkTertiary = Color(0xFFFFB2BC);
  static const _darkError = Color(0xFFFFB4AB);
  static const _darkOnError = Color(0xFF690005);
  static const _darkErrorContainer = Color(0xFF93000A);

  static const _darkSurface = Color(0xFF200E14);
  static const _darkLowest = Color(0xFF1A090F);
  static const _darkLow = Color(0xFF29161C);
  static const _darkContainer = Color(0xFF2E1A20);
  static const _darkHigh = Color(0xFF39242A);
  static const _darkHighest = Color(0xFF452E35);
  static const _darkOnSurface = Color(0xFFFDD9E2);
  static const _darkOnVariant = Color(0xFFDBC1BC);
  static const _darkOutline = Color(0xFFA38C87);
  static const _darkOutlineVariant = Color(0xFF55423F);

  static ThemeData get light {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: _lightPrimary,
      onPrimary: _lightOnPrimary,
      primaryContainer: _lightPrimaryContainer,
      onPrimaryContainer: _lightOnPrimaryContainer,
      secondary: _lightSecondary,
      onSecondary: _lightOnPrimary,
      secondaryContainer: _lightSecondaryContainer,
      onSecondaryContainer: _lightOnSecondaryContainer,
      tertiary: _lightTertiary,
      onTertiary: _lightOnPrimary,
      tertiaryContainer: _lightSecondaryContainer,
      onTertiaryContainer: _lightOnSecondaryContainer,
      error: _lightError,
      onError: _lightOnPrimary,
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF93000A),
      surface: _lightSurface,
      onSurface: _lightOnSurface,
      surfaceContainerLowest: _lightLowest,
      surfaceContainerLow: _lightLow,
      surfaceContainer: _lightContainer,
      surfaceContainerHigh: _lightHigh,
      surfaceContainerHighest: _lightHighest,
      onSurfaceVariant: _lightOnVariant,
      outline: _lightOutline,
      outlineVariant: _lightOutlineVariant,
      scrim: Color(0xFF4B1D27),
      inverseSurface: Color(0xFF50212B),
      onInverseSurface: Color(0xFFFFECEE),
      inversePrimary: Color(0xFFFFB4A7),
      surfaceTint: _lightPrimary,
    );
    return _base(scheme);
  }

  static ThemeData get dark {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: _darkPrimary,
      onPrimary: _darkOnPrimary,
      primaryContainer: _darkPrimaryContainer,
      onPrimaryContainer: _darkOnPrimaryContainer,
      secondary: _darkSecondary,
      onSecondary: _darkOnPrimary,
      secondaryContainer: _darkSecondaryContainer,
      onSecondaryContainer: Color(0xFFEBA493),
      tertiary: _darkTertiary,
      onTertiary: Color(0xFF5D1526),
      tertiaryContainer: Color(0xFFD57383),
      onTertiaryContainer: Color(0xFF540D20),
      error: _darkError,
      onError: _darkOnError,
      errorContainer: _darkErrorContainer,
      onErrorContainer: Color(0xFFFFDAD6),
      surface: _darkSurface,
      onSurface: _darkOnSurface,
      surfaceContainerLowest: _darkLowest,
      surfaceContainerLow: _darkLow,
      surfaceContainer: _darkContainer,
      surfaceContainerHigh: _darkHigh,
      surfaceContainerHighest: _darkHighest,
      onSurfaceVariant: _darkOnVariant,
      outline: _darkOutline,
      outlineVariant: _darkOutlineVariant,
      scrim: Color(0xFF0C0407),
      inverseSurface: _darkOnSurface,
      onInverseSurface: Color(0xFF412A31),
      inversePrimary: Color(0xFF984537),
      surfaceTint: _darkPrimary,
    );
    return _base(scheme);
  }

  /// Base minimalista compartida: bordes hairline, radios 8/16/pill,
  /// sin sombras duras, tipografía con tracking editorial.
  static ThemeData _base(ColorScheme scheme) {
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: scheme.outlineVariant),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: scheme.primary, width: 1.5),
    );
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.01,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: scheme.outlineVariant),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      chipTheme: ChipThemeData(
        shape: const StadiumBorder(),
        side: BorderSide(color: scheme.outlineVariant),
        backgroundColor: scheme.surfaceContainerHigh,
        selectedColor: scheme.primary,
        labelStyle: TextStyle(color: scheme.onSurface, fontSize: 12),
        secondaryLabelStyle: TextStyle(color: scheme.onPrimary, fontSize: 12),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLowest,
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: focusedBorder,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        labelStyle: TextStyle(color: scheme.onSurfaceVariant),
        hintStyle: TextStyle(
          color: scheme.onSurfaceVariant.withValues(alpha: 0.6),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 0,
        shape: const StadiumBorder(),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: scheme.surface,
        selectedItemColor: scheme.primary,
        unselectedItemColor: scheme.onSurfaceVariant,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: BorderSide(color: scheme.primary, width: 1.5),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant.withValues(alpha: 0.6),
        thickness: 1,
      ),
      listTileTheme: ListTileThemeData(
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 15,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.005,
        ),
        subtitleTextStyle: TextStyle(
          color: scheme.onSurfaceVariant,
          fontSize: 13,
          height: 1.5,
        ),
      ),
      textTheme: TextTheme(
        headlineSmall: TextStyle(
          color: scheme.onSurface,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.015,
        ),
        titleLarge: TextStyle(
          color: scheme.onSurface,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.01,
        ),
        bodyLarge: TextStyle(color: scheme.onSurface, height: 1.6),
        bodyMedium: TextStyle(
          color: scheme.onSurface,
          height: 1.55,
        ),
        bodySmall: TextStyle(
          color: scheme.onSurfaceVariant,
          letterSpacing: 0.01,
        ),
        labelSmall: TextStyle(
          color: scheme.onSurfaceVariant,
          letterSpacing: 0.04,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
