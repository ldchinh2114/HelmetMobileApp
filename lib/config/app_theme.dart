import 'package:flutter/material.dart';

/// Classic design language for HELMO.
///
/// The palette is warm and restrained: ivory paper, ink text, deep burgundy
/// as the single brand accent and antique gold for small ceremonial details.
/// Surfaces are separated by hairline rules rather than drop shadows, which
/// is what gives the interface its "classic catalogue" feel.
class AppColors {
  // Brand
  static const Color primary = Color(0xFF7C2233); // Deep burgundy
  static const Color primaryDark = Color(0xFF5E1826);
  static const Color primarySoft = Color(0xFFF3E7E9);
  static const Color gold = Color(0xFFB08D57); // Antique gold
  static const Color goldSoft = Color(0xFFF6EFE3);

  // Surfaces
  static const Color background = Color(0xFFFBF8F4); // Ivory
  static const Color paper = Color(0xFFFFFFFF);
  static const Color canvas = Color(0xFFF4EFE7); // Recessed artwork backdrop
  static const Color hairline = Color(0xFFE7E0D4); // Rules & borders
  static const Color hairlineStrong = Color(0xFFD4C9B7);

  // Ink
  static const Color ink = Color(0xFF2B2723);
  static const Color inkSoft = Color(0xFF6F675E);
  static const Color inkFaint = Color(0xFF9C948A);

  // Utility
  static const Color success = Color(0xFF3F6B4F);
  static const Color warning = Color(0xFFB08D57);
  static const Color error = Color(0xFF9B2C2C);
  static const Color star = Color(0xFFB08D57);
}

class AppFonts {
  static const String display = 'Playfair Display';
  static const String sans = 'Inter';

  static const List<String> displayFallback = <String>[
    'Georgia',
    'Times New Roman',
    'serif',
  ];

  static const List<String> sansFallback = <String>[
    'Roboto',
    'Helvetica Neue',
    'Arial',
    'sans-serif',
  ];
}

/// Spacing scale (4pt grid).
class AppSpacing {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double huge = 48;
}

/// Deliberately small radii — classic forms are crisp, not pillowy.
class AppRadius {
  static const double none = 0;
  static const double sm = 2;
  static const double md = 3;
  static const double lg = 4;
  static const double xl = 8;
  static const double full = 999;
}

/// Hairline rules used instead of shadows.
class AppBorders {
  static const BorderSide hairline = BorderSide(color: AppColors.hairline);
  static const BorderSide strong = BorderSide(color: AppColors.hairlineStrong);
  static const BorderSide gold = BorderSide(color: AppColors.gold);
  static const BorderSide primary = BorderSide(color: AppColors.primary);
}

class AppTextStyles {
  // ---- Display (serif) -------------------------------------------------

  static const TextStyle wordmark = TextStyle(
    fontFamily: AppFonts.display,
    fontFamilyFallback: AppFonts.displayFallback,
    fontSize: 23,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
    letterSpacing: 5.5,
    height: 1.1,
  );

  static const TextStyle displayLarge = TextStyle(
    fontFamily: AppFonts.display,
    fontFamilyFallback: AppFonts.displayFallback,
    fontSize: 30,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
    height: 1.15,
    letterSpacing: 0.2,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: AppFonts.display,
    fontFamilyFallback: AppFonts.displayFallback,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
    height: 1.2,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontFamily: AppFonts.display,
    fontFamilyFallback: AppFonts.displayFallback,
    fontSize: 19,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
    height: 1.25,
  );

  static const TextStyle productName = TextStyle(
    fontFamily: AppFonts.display,
    fontFamilyFallback: AppFonts.displayFallback,
    fontSize: 14.5,
    fontWeight: FontWeight.w500,
    color: AppColors.ink,
    height: 1.35,
  );

  static const TextStyle price = TextStyle(
    fontFamily: AppFonts.display,
    fontFamilyFallback: AppFonts.displayFallback,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    height: 1.2,
  );

  static const TextStyle priceLarge = TextStyle(
    fontFamily: AppFonts.display,
    fontFamilyFallback: AppFonts.displayFallback,
    fontSize: 26,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    height: 1.1,
  );

  static const TextStyle priceSmall = TextStyle(
    fontFamily: AppFonts.display,
    fontFamilyFallback: AppFonts.displayFallback,
    fontSize: 12.5,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  static const TextStyle originalPrice = TextStyle(
    fontFamily: AppFonts.sans,
    fontFamilyFallback: AppFonts.sansFallback,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.inkFaint,
    decoration: TextDecoration.lineThrough,
    decorationColor: AppColors.inkFaint,
  );

  // ---- Sans (body & utility) -------------------------------------------

  static const TextStyle body = TextStyle(
    fontFamily: AppFonts.sans,
    fontFamilyFallback: AppFonts.sansFallback,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.ink,
    height: 1.55,
  );

  static const TextStyle bodyMuted = TextStyle(
    fontFamily: AppFonts.sans,
    fontFamilyFallback: AppFonts.sansFallback,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.inkSoft,
    height: 1.6,
  );

  static const TextStyle label = TextStyle(
    fontFamily: AppFonts.sans,
    fontFamilyFallback: AppFonts.sansFallback,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.ink,
  );

  static const TextStyle meta = TextStyle(
    fontFamily: AppFonts.sans,
    fontFamilyFallback: AppFonts.sansFallback,
    fontSize: 11.5,
    fontWeight: FontWeight.w400,
    color: AppColors.inkSoft,
  );

  /// Small uppercase kicker, used above section titles.
  static const TextStyle eyebrow = TextStyle(
    fontFamily: AppFonts.sans,
    fontFamilyFallback: AppFonts.sansFallback,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppColors.gold,
    letterSpacing: 2.0,
    height: 1.2,
  );

  static const TextStyle navLabel = TextStyle(
    fontFamily: AppFonts.sans,
    fontFamilyFallback: AppFonts.sansFallback,
    fontSize: 10.5,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
  );

  static const TextStyle badgeCount = TextStyle(
    fontFamily: AppFonts.sans,
    fontFamilyFallback: AppFonts.sansFallback,
    fontSize: 9.5,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.2,
  );

  static const TextStyle button = TextStyle(
    fontFamily: AppFonts.sans,
    fontFamilyFallback: AppFonts.sansFallback,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.4,
    height: 1.1,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontFamily: AppFonts.sans,
    fontFamilyFallback: AppFonts.sansFallback,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.1,
    height: 1.1,
  );

  static const TextStyle link = TextStyle(
    fontFamily: AppFonts.sans,
    fontFamilyFallback: AppFonts.sansFallback,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    letterSpacing: 0.4,
  );

  static const TextStyle searchHint = TextStyle(
    fontFamily: AppFonts.sans,
    fontFamilyFallback: AppFonts.sansFallback,
    fontSize: 13.5,
    fontWeight: FontWeight.w400,
    color: AppColors.inkFaint,
  );

  static const TextStyle searchText = TextStyle(
    fontFamily: AppFonts.sans,
    fontFamilyFallback: AppFonts.sansFallback,
    fontSize: 13.5,
    fontWeight: FontWeight.w400,
    color: AppColors.ink,
  );
}

/// The application theme.
ThemeData buildAppTheme() {
  const ColorScheme scheme = ColorScheme.light(
    primary: AppColors.primary,
    onPrimary: Colors.white,
    primaryContainer: AppColors.primarySoft,
    onPrimaryContainer: AppColors.primaryDark,
    secondary: AppColors.gold,
    onSecondary: Colors.white,
    surface: AppColors.paper,
    onSurface: AppColors.ink,
    error: AppColors.error,
    onError: Colors.white,
    outline: AppColors.hairline,
    outlineVariant: AppColors.hairline,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.background,
    canvasColor: AppColors.background,
    fontFamily: AppFonts.sans,
    splashFactory: InkSparkle.splashFactory,
    visualDensity: VisualDensity.standard,
    textTheme: const TextTheme(
      displayLarge: AppTextStyles.displayLarge,
      displayMedium: AppTextStyles.displayMedium,
      titleLarge: AppTextStyles.sectionTitle,
      titleMedium: AppTextStyles.label,
      bodyLarge: AppTextStyles.body,
      bodyMedium: AppTextStyles.bodyMuted,
      bodySmall: AppTextStyles.meta,
      labelLarge: AppTextStyles.label,
      labelSmall: AppTextStyles.eyebrow,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      foregroundColor: AppColors.ink,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.sectionTitle,
      shape: Border(bottom: AppBorders.hairline),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.hairline,
      thickness: 1,
      space: 1,
    ),
    iconTheme: const IconThemeData(color: AppColors.ink, size: 21),
    listTileTheme: const ListTileThemeData(
      iconColor: AppColors.inkSoft,
      textColor: AppColors.ink,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        minimumSize: const Size(0, 48),
        textStyle: AppTextStyles.button,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        minimumSize: const Size(0, 48),
        textStyle: AppTextStyles.button,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.ink,
        side: AppBorders.strong,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        minimumSize: const Size(0, 48),
        textStyle: AppTextStyles.button,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        minimumSize: const Size(0, 36),
        textStyle: AppTextStyles.link,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.sm)),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.canvas,
      hintStyle: AppTextStyles.searchHint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
        borderSide: BorderSide.none,
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
        borderSide: BorderSide.none,
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
        borderSide: AppBorders.gold,
      ),
    ),
    chipTheme: const ChipThemeData(
      backgroundColor: AppColors.paper,
      side: AppBorders.strong,
      labelStyle: AppTextStyles.label,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.sm)),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.paper,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      modalElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.paper,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: AppTextStyles.sectionTitle,
      contentTextStyle: AppTextStyles.bodyMuted,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.ink,
      contentTextStyle: TextStyle(
        fontFamily: AppFonts.sans,
        fontFamilyFallback: AppFonts.sansFallback,
        fontSize: 13,
        color: Colors.white,
        height: 1.4,
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
      linearTrackColor: AppColors.hairline,
      circularTrackColor: AppColors.hairline,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.paper,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.inkFaint,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
  );
}
