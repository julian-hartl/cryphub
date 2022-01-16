import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _darkBg = Color(0xFF272829);
const _darkOnBg = Color(0xFFFEFEFE);
ThemeData dark(BuildContext context) => ThemeData(
      colorScheme: const ColorScheme.dark(
        background: _darkBg,
        surface: Color(0xFF424342),
        primary: Color(0xFF31E384),
        onBackground: _darkOnBg,
      ),
      fontFamily: GoogleFonts.aBeeZee().fontFamily,
      scaffoldBackgroundColor: _darkBg,
      appBarTheme: AppBarTheme(
          backgroundColor: _darkBg,
          iconTheme: const IconThemeData(color: _darkOnBg),
          titleTextStyle:
              _lightTextTheme.bodyText2?.copyWith(color: _darkOnBg)),
      textTheme: GoogleFonts.robotoTextTheme().copyWith(
        bodyText2: TextStyle(color: _darkOnBg),
      ),
    );

const _lightBg = Color(0xFFFEFEFE);
final _lightTextTheme = GoogleFonts.montserratTextTheme().copyWith();
const _lightOnBg = Color(0xFF272829);
ThemeData light(BuildContext context) => ThemeData(
      colorScheme: const ColorScheme.light(
          background: _lightBg,
          surface: Color(0xFFD5D5D7),
          primary: Color(0xFF31E384),
          onBackground: _lightOnBg),
      scaffoldBackgroundColor: _lightBg,
      appBarTheme: AppBarTheme(
          backgroundColor: _lightBg,
          iconTheme: const IconThemeData(color: _lightOnBg),
          titleTextStyle:
              _lightTextTheme.bodyText2?.copyWith(color: _lightOnBg)),
      textTheme: _lightTextTheme,
    );

const positiveGrowthColor = Color(0xFF31E384);
const noGrowthColor = Color(0xFF979A9B);
const negativeGrowthColor = Color(0xFFFA8C96);

abstract class Themes {
  static const dark = 'dark';
  static const light = 'light';
}
