import 'package:flutter/material.dart';

import 'colors.dart';
import 'constants.dart';

class SigmaTheme {
  SigmaTheme._();

  static final ThemeData appTheme = ThemeData(
    fontFamily: SigmaConstants.fontFamily,
    scaffoldBackgroundColor: SigmaColors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: SigmaColors.white,
      surfaceTintColor: SigmaColors.white,
    ),
    
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
    inputDecorationTheme: InputDecorationThemeData(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(0)),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: EdgeInsetsGeometry.symmetric(vertical: 20, horizontal: 16),
        textStyle: TextStyle(
          fontFamily: SigmaConstants.fontFamily,

          color: SigmaColors.white,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(0),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsetsGeometry.symmetric(vertical: 20, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(0),
        ),
        textStyle: TextStyle(
          fontFamily: SigmaConstants.fontFamily,

          color: SigmaColors.white,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}
