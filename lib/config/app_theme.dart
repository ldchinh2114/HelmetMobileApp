import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFE53935); // Red
  static const Color primaryDark = Color(0xFFC62828);
  static const Color black = Color(0xFF212121);
  static const Color darkGray = Color(0xFF424242);
  static const Color gray = Color(0xFF757575);
  static const Color lightGray = Color(0xFFBDBDBD);
  static const Color background = Color(0xFFFAFAFA);
  static const Color white = Color(0xFFFFFFFF);
  static const Color redAccent = Color(0xFFFF5252);
  static const Color starYellow = Color(0xFFFFC107);
  static const Color gradientStart = Color(0xFFE53935);
  static const Color gradientEnd = Color(0xFFB71C1C);
}

class AppTextStyles {
  static const String _fontFamily = 'Roboto';

  static const TextStyle logo = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.black,
    letterSpacing: 3,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
  );

  static const TextStyle seeAll = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.gray,
  );

  static const TextStyle productName = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
  );

  static const TextStyle price = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static const TextStyle originalPrice = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.gray,
    decoration: TextDecoration.lineThrough,
  );

  static const TextStyle soldCount = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.gray,
  );

  static const TextStyle categoryName = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
  );

  static const TextStyle benefitText = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
  );

  static const TextStyle searchHint = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.lightGray,
  );

  static const TextStyle searchText = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );

  static const TextStyle bannerButton = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  static const TextStyle promotionTitle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  static const TextStyle promotionSubtitle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
  );

  static const TextStyle navLabel = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle badgeCount = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

class AppRadius {
  static const double sm = 4;
  static const double md = 8;
  static const double lg = 12;
  static const double xl = 16;
  static const double xxl = 20;
  static const double full = 999;
}