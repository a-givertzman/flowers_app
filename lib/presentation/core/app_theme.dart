import 'package:flutter/material.dart';

const accentColor = Color(0xffFCCA55);
const onAccentColor = Color(0xff000000);
const accentContainerColor = Color(0xffFF8040);
const onAccentContainerColor = Color(0xff000000);

const primary = Color(0xffFFFFFF);
const onPrimary = Color(0xff1F2B3F);
const primaryContainer = Color(0xffDFE4E5);
const onPrimaryContainer = Color(0xff000000);
const secondary = Color(0xffDFE4E5);
const onSecondary = Color(0xff242527);
const secondaryContainer = Color(0xffDFE4E5);
const onSecondaryContainer = Color(0xff242527);
const surface = Color(0xffFDEABF);
const onSurface = Color(0xff242527);
const background = Color(0xffCBCBCB);
const onBackground = Color(0xff1F2B3F);
const error = Color(0xff9E001A);
const onError = Color(0xffF5EADD);
const shadowColor = Color(0xff000000);

const primaryFontFamily = 'Rubik';
const secondaryFontFamily = 'Roboto';

const baseFontSize = 14.0;

final appThemeData = ThemeData(
        backgroundColor: background,
        scaffoldBackgroundColor: background,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xff000000),
          selectionColor: accentColor,
          selectionHandleColor: accentColor,
        ),
        dialogTheme: const DialogTheme(
          backgroundColor: secondary,
          titleTextStyle: TextStyle(
            fontFamily: secondaryFontFamily,
            fontSize: baseFontSize + 6.0,
            fontWeight: FontWeight.w500,
            color: onSecondary,
          ),
          contentTextStyle: TextStyle(
            fontFamily: secondaryFontFamily,
            fontSize: baseFontSize,
            fontWeight: FontWeight.normal,
            color: onSecondary,
          ),
        ),
        colorScheme: const ColorScheme(
          primary: primary,
          onPrimary: onPrimary,
          primaryContainer: primaryContainer, 
          onPrimaryContainer: onPrimaryContainer,
          secondary: secondary,
          onSecondary: onSecondary,
          secondaryContainer: secondaryContainer,
          onSecondaryContainer: onSecondaryContainer,
          tertiary: accentColor,
          onTertiary: onAccentColor,
          tertiaryContainer: accentContainerColor,
          onTertiaryContainer: onAccentContainerColor,
          surface: surface,
          onSurface: onSurface,
          background: background,
          onBackground: onBackground,
          error: error,
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
            fontSize: baseFontSize * 1.2,
            color: onSecondary,
          ),
        ),
        textTheme: const TextTheme(
          // headline1
          headline2: TextStyle(
            fontFamily: primaryFontFamily,
            fontSize: baseFontSize + 12.0,
            fontWeight: FontWeight.normal,
            color: onBackground,
          ),
          headline3: TextStyle(
            fontFamily: primaryFontFamily,
            fontSize: baseFontSize + 12.0,
            fontWeight: FontWeight.normal,
            color: onBackground,
          ),
          headline4: TextStyle(
            fontFamily: secondaryFontFamily,
            fontSize: baseFontSize + 6.0,     //18
            fontWeight: FontWeight.normal,
            color: onBackground,
          ),
          // headline5
          // headline6
          subtitle1: TextStyle(
            fontFamily: secondaryFontFamily,
            fontSize: baseFontSize + 2.0,
            fontWeight: FontWeight.normal,
            color: onBackground,
          ),
          subtitle2: TextStyle(
            fontFamily: secondaryFontFamily,
            fontSize: baseFontSize + 2.0,
            fontWeight: FontWeight.normal,
            color: onBackground,
          ),
          bodyText1: TextStyle(
            fontFamily: secondaryFontFamily,
            fontSize: baseFontSize,
            fontWeight: FontWeight.normal,
            color: onBackground,
            height: 1.5,
          ),
          bodyText2: TextStyle(
            fontFamily: secondaryFontFamily,
            fontSize: baseFontSize,
            fontWeight: FontWeight.normal,
            color: onBackground,
            height: 1.5,
          ),
          // caption
          // button
          // overline
        ),
      );
