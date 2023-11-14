import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:anekapanduan/utils/colors.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: appBackgroundColorLight,
    fontFamily: GoogleFonts.outfit().fontFamily,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      error: errorColor,
    ),
    iconTheme: const IconThemeData(color: Colors.black),
    appBarTheme: const AppBarTheme(backgroundColor: appBackgroundColorLight),
    bottomAppBarTheme:
        const BottomAppBarTheme(color: Colors.white, elevation: 0.0),
    snackBarTheme: SnackBarThemeData(
        contentTextStyle:
            TextStyle(fontFamily: GoogleFonts.outfit().fontFamily)),
    textTheme: const TextTheme(
        titleLarge: TextStyle(
            fontSize: 38, fontWeight: FontWeight.bold, color: Colors.black),
        titleMedium: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(color: Colors.black, fontSize: 18),
        bodyMedium: TextStyle(fontSize: 16, color: Colors.black),
        bodySmall: TextStyle(color: greyColor, fontSize: 14)),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            textStyle: MaterialStateProperty.all(TextStyle(
                color: primaryColor,
                fontSize: 16,
                fontFamily: GoogleFonts.outfit().fontFamily,
                fontWeight: FontWeight.w500)))));

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: appBackgroundColorDark,
    fontFamily: GoogleFonts.outfit().fontFamily,
    colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
        brightness: Brightness.dark),
    iconTheme: const IconThemeData(color: Colors.white),
    appBarTheme: const AppBarTheme(backgroundColor: appBackgroundColorDark),
    bottomAppBarTheme:
        const BottomAppBarTheme(color: appBackgroundColorDark, elevation: 0.0),
    snackBarTheme: SnackBarThemeData(
        contentTextStyle:
            TextStyle(fontFamily: GoogleFonts.outfit().fontFamily)),
    textTheme: const TextTheme(
        titleLarge: TextStyle(
            fontSize: 38, fontWeight: FontWeight.bold, color: Colors.white),
        titleMedium: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(color: Colors.white, fontSize: 18),
        bodyMedium: TextStyle(fontSize: 16, color: Colors.white),
        bodySmall: TextStyle(color: greyColor, fontSize: 14)),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            textStyle: MaterialStateProperty.all(TextStyle(
                color: primaryColor,
                fontSize: 16,
                fontFamily: GoogleFonts.outfit().fontFamily,
                fontWeight: FontWeight.w500)))));
