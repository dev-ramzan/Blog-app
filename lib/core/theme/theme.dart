import 'package:clean_architecture_app/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // border resuable function
  static _border([Color color = AppPallete.borderColor]) => OutlineInputBorder(
        borderSide: BorderSide(
          width: 3,
          color: color,
        ),
        borderRadius: BorderRadius.circular(10),
      );
  static final darkThemeMode = ThemeData.dark().copyWith(
    chipTheme: ChipThemeData(
      side: BorderSide.none,
    ),
    scaffoldBackgroundColor: AppPallete.backgroundColor,
    appBarTheme: AppBarTheme(backgroundColor: AppPallete.backgroundColor),
    inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.all(27),
        border: _border(),
        enabledBorder: _border(),
        focusedBorder: _border(AppPallete.gradient2),
        errorBorder: _border(AppPallete.errorColor)),
  );
}
