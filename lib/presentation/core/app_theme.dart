import 'package:flutter/material.dart';

const accentColor = Color(0xffFF8426);
const onAccentColor = Color(0xffFFFFFF);

const primary = Color(0xff303F46);
const primaryContainer = Color(0xff455A64);
const secondary = Color(0xff263238);
const secondaryContainer = Color(0xff768F9B);
const surface = Color(0xffB7A3A2);
const background = Color(0xff303F46);
const error = Color(0xff9E001A);
const onPrimary = Color(0xffB7A3A2);
const onSecondary = Color(0xffF5EADD);
const onSurface = Color(0xffB7A3D2);
const onBackground = Color(0xffB7A3A2);
const onError = Color(0xffF5EADD);
const shadowColor = Color(0xff000000);

const primaryFontFamily = 'Rubik';
const secondaryFontFamily = 'Roboto';

const baseFontSize = 14.0;

final appThemeData = ThemeData(
        backgroundColor: const Color(0xff303F46),
        scaffoldBackgroundColor: const Color(0xff303F46),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xffFFFFFF),
          selectionColor: accentColor,
          selectionHandleColor: accentColor,
        ),
        dialogTheme: const DialogTheme(
          backgroundColor: Color(0xff303F46),
          titleTextStyle: TextStyle(
            fontFamily: secondaryFontFamily,
            fontSize: baseFontSize + 6.0,
            fontWeight: FontWeight.w500,
            color: Color(0xffFFFFFF),
          ),
          contentTextStyle: TextStyle(
            fontFamily: secondaryFontFamily,
            fontSize: baseFontSize,
            fontWeight: FontWeight.normal,
            color: Color(0xffFFFFFF),
          ),
        ),
        colorScheme: const ColorScheme(
          primary: primary,
          primaryContainer: primaryContainer, 
          secondary: secondary,
          secondaryContainer: secondaryContainer,
          surface: surface,
          background: background,
          error: error,
          onPrimary: onPrimary,
          onSecondary: onSecondary,
          onSurface: onSurface,
          onBackground: onBackground,
          onError: onError,
          brightness: Brightness.light,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: accentColor,
            onPrimary: onAccentColor,
            onSurface: onSurface,
            shadowColor: shadowColor,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: onAccentColor,
            backgroundColor: accentColor,
          ),
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: secondaryFontFamily,
            fontWeight: FontWeight.normal,
            fontSize: baseFontSize + 10.0,
            color: Color(0xffB7A3A2),
          ),
        ),
        textTheme: const TextTheme(
          // headline1
          headline2: TextStyle(
            fontFamily: primaryFontFamily,
            fontSize: baseFontSize + 12.0,
            fontWeight: FontWeight.normal,
            color: Color(0xffFFFFFF),
          ),
          headline3: TextStyle(
            fontFamily: primaryFontFamily,
            fontSize: baseFontSize + 12.0,
            fontWeight: FontWeight.normal,
            color: Color(0xff263238),
          ),
          headline4: TextStyle(
            fontFamily: secondaryFontFamily,
            fontSize: baseFontSize + 6.0,     //18
            fontWeight: FontWeight.normal,
            color: Color(0xff263238),
          ),
          // headline5
          // headline6
          subtitle1: TextStyle(
            fontFamily: secondaryFontFamily,
            fontSize: baseFontSize + 2.0,
            fontWeight: FontWeight.normal,
            color: Color(0xff263238),
          ),
          subtitle2: TextStyle(
            fontFamily: secondaryFontFamily,
            fontSize: baseFontSize + 2.0,
            fontWeight: FontWeight.normal,
            color: Color(0xffFFFFFF),
          ),
          bodyText1: TextStyle(
            fontFamily: secondaryFontFamily,
            fontSize: baseFontSize,
            fontWeight: FontWeight.normal,
            color: Color(0xff1F2A31),
            height: 1.5,
          ),
          bodyText2: TextStyle(
            fontFamily: secondaryFontFamily,
            fontSize: baseFontSize,
            fontWeight: FontWeight.normal,
            color: Color(0xffFFFFFF),
            height: 1.5,
          ),
          // caption
          // button
          // overline
        ),
      );
