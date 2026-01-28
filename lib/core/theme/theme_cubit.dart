import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Theme mode options
enum AppThemeMode { light, dark, system }

/// Cubit to manage app theme
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  /// Set theme to light mode
  void setLightTheme() {
    emit(ThemeMode.light);
  }

  /// Set theme to dark mode
  void setDarkTheme() {
    emit(ThemeMode.dark);
  }

  /// Set theme to system default
  void setSystemTheme() {
    emit(ThemeMode.system);
  }

  /// Toggle between light and dark (ignoring system)
  void toggleTheme() {
    if (state == ThemeMode.light) {
      emit(ThemeMode.dark);
    } else {
      emit(ThemeMode.light);
    }
  }
}
