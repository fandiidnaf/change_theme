import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:test/main.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(super.theme);

  void changeTheme(ThemeMode newState) async {
    emit(newState);
    final box = Hive.box(themeBox);
    await box.putAt(0, newState.name);
  }
}

extension StringExt on String {
  ThemeMode get toThemeMode {
    switch (this) {
      case "light":
        return ThemeMode.light;
      case "dark":
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}

extension ThemeModeExt on ThemeMode {
  void changeSystemUi(BuildContext context) {
    late final Brightness setBrigthness;

    if (this == ThemeMode.system) {
      final brightness = MediaQuery.platformBrightnessOf(context);
      setBrigthness =
          brightness == Brightness.light ? Brightness.dark : Brightness.light;
    } else {
      setBrigthness =
          this == ThemeMode.light ? Brightness.dark : Brightness.light;
    }

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: setBrigthness,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: setBrigthness,
        // systemNavigationBarColor: Colors.transparent,
      ),
    );
  }
}
