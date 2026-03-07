import 'package:flutter/material.dart';

// ============================================================================
// Color Palette
// ============================================================================

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF455A64); // Dark Blue-Gray
  static const Color secondary = Color(0xFFEDE3D0); // Cream
  static const Color tertiary = Color(0xFFB2B3AC); // Light Gray
  static const Color quaternary = Color(0xFF89908C); // Medium Gray

  // Semantic Colors
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFFF0000);
  static const Color success = Color(0xFF00CC00);

  // Neutral Palette
  static const Color surface = Color(0xFFFAFAFA);
  static const Color surface200 = Color(0xFFF5F5F5);
  static const Color surface300 = Color(0xFFEEEEEE);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color border = Color(0xFFD0D0D0);

  // Transparent variants
  static const Color primaryLight = Color(0x14455A64); // 8% opacity
  static const Color primaryDark = Color(0x1F455A64); // 12% opacity
  static const Color shadowColor = Color(0x19000000); // 10% opacity
  static const Color shadowColorDark = Color(0x26000000); // 15% opacity
  static const Color disabledColor = Color(0x6689908C); // 40% opacity
}

// ============================================================================
// Layout, Spacing, and Sizing
// ============================================================================

class AppLayout {
  static const double maxContentWidth = 1200;

  static EdgeInsets screenPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width >= 1440) {
      return const EdgeInsets.symmetric(horizontal: 80, vertical: 36);
    }
    if (width >= 1200) {
      return const EdgeInsets.symmetric(horizontal: 64, vertical: 32);
    }
    if (width >= 992) {
      return const EdgeInsets.symmetric(horizontal: 48, vertical: 28);
    }
    if (width >= 768) {
      return const EdgeInsets.symmetric(horizontal: 32, vertical: 24);
    }
    return const EdgeInsets.symmetric(horizontal: 20, vertical: 16);
  }

  static EdgeInsets sectionPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= 992
        ? const EdgeInsets.symmetric(vertical: 32)
        : const EdgeInsets.symmetric(vertical: 20);
  }
}

class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;
}

class AppAlignment {
  static const CrossAxisAlignment sectionCrossAxis = CrossAxisAlignment.start;
  static const MainAxisAlignment sectionMainAxis = MainAxisAlignment.start;
  static const Alignment heroContent = Alignment.centerLeft;
  static const Alignment centered = Alignment.center;
}

class AppButtonSize {
  static const Size small = Size(128, 44);
  static const Size medium = Size(168, 52);
  static const Size large = Size(220, 58);
}

class AppRadius {
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 28;
}

class AppFonts {
  // Must match the font family declared in pubspec.yaml.
  static const String primary = 'BricolageGrotesque';
}

// ============================================================================
// Typography
// ============================================================================

class AppTypography {
  static TextTheme textTheme = const TextTheme(
    // Header
    displayLarge: TextStyle(
      fontFamily: AppFonts.primary,
      fontSize: 56,
      height: 1.08,
      fontWeight: FontWeight.w700,
      letterSpacing: -1.4,
      color: AppColors.primary,
    ),

    // Tagline
    headlineMedium: TextStyle(
      fontFamily: AppFonts.primary,
      fontSize: 28,
      height: 1.24,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.4,
      color: AppColors.primary,
    ),

    // Description
    bodyLarge: TextStyle(
      fontFamily: AppFonts.primary,
      fontSize: 18,
      height: 1.65,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.1,
      color: AppColors.quaternary,
    ),

    // Body
    bodyMedium: TextStyle(
      fontFamily: AppFonts.primary,
      fontSize: 16,
      height: 1.55,
      fontWeight: FontWeight.w400,
      color: AppColors.quaternary,
    ),

    // Caption
    bodySmall: TextStyle(
      fontFamily: AppFonts.primary,
      fontSize: 13,
      height: 1.45,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.2,
      color: AppColors.quaternary,
    ),

    // Buttons
    labelLarge: TextStyle(
      fontFamily: AppFonts.primary,
      fontSize: 16,
      height: 1.2,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
    ),
  );
}

// ============================================================================
// App Theme
// ============================================================================

class AppTheme {
  static ThemeData get lightTheme {
    final colorScheme = const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      secondary: AppColors.secondary,
      onSecondary: AppColors.black,
      surface: AppColors.surface,
      onSurface: AppColors.primary,
      error: AppColors.error,
      onError: AppColors.white,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: AppFonts.primary,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.surface,
      textTheme: AppTypography.textTheme,
      dividerColor: AppColors.divider,
      disabledColor: AppColors.disabledColor,

      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.primary,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: AppFonts.primary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
          color: AppColors.primary,
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shadowColor: AppColors.shadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: const BorderSide(color: AppColors.border),
        ),
        margin: EdgeInsets.zero,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style:
            ElevatedButton.styleFrom(
              minimumSize: AppButtonSize.medium,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              elevation: 0,
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              disabledBackgroundColor: AppColors.primaryDark,
              disabledForegroundColor: AppColors.disabledColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              textStyle: AppTypography.textTheme.labelLarge,
            ).copyWith(
              overlayColor: WidgetStateProperty.resolveWith(
                (states) => states.contains(WidgetState.pressed)
                    ? AppColors.primaryDark
                    : null,
              ),
            ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: AppButtonSize.medium,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: AppTypography.textTheme.labelLarge,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(72, 44),
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          textStyle: AppTypography.textTheme.labelLarge,
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primary,
        contentTextStyle: AppTypography.textTheme.bodyMedium?.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w500,
        ),
        actionTextColor: AppColors.secondary,
        disabledActionTextColor: AppColors.tertiary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.error, width: 1.2),
        ),
      ),
    );
  }
}
