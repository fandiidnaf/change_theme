import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const Color white = Color.fromARGB(0, 255, 255, 255);
  static const Color black = Color.fromARGB(0, 0, 0, 0);
}

class AppThemeExt extends ThemeExtension<AppThemeExt> {
  final Color scaffoldColor;

  const AppThemeExt({required this.scaffoldColor});

  @override
  ThemeExtension<AppThemeExt> copyWith({Color? scaffoldColor}) {
    return AppThemeExt(scaffoldColor: scaffoldColor ?? this.scaffoldColor);
  }

  @override
  ThemeExtension<AppThemeExt> lerp(
    covariant ThemeExtension<AppThemeExt>? other,
    double t,
  ) {
    if (other is! AppThemeExt) return this;
    return AppThemeExt(
      scaffoldColor: Color.lerp(scaffoldColor, other.scaffoldColor, t)!,
    );
  }
}

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    extensions: [AppThemeExt(scaffoldColor: AppColors.white)],
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    extensions: [AppThemeExt(scaffoldColor: AppColors.black)],
  );
}

extension AppThemeExts on BuildContext {
  AppThemeExt get colors => Theme.of(this).extension<AppThemeExt>()!;
}
