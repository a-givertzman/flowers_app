import 'package:flutter/material.dart';

final appThemeData = ThemeData(
        backgroundColor: const Color(0xff303F46),
        scaffoldBackgroundColor: const Color(0xff303F46),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xffFFFFFF),
          selectionColor: Color(0xffFF8426),
          selectionHandleColor: Color(0xffFF8426),
        ),
        dialogTheme: const DialogTheme(
          backgroundColor: Color(0xff303F46),
          titleTextStyle: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            color: Color(0xffFFFFFF),
          ),
          contentTextStyle: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 12.0,
            fontWeight: FontWeight.normal,
            color: Color(0xffFFFFFF),
          )
        ),
        colorScheme: const ColorScheme(
          primary: Color(0xff303F46),
          primaryVariant: Color(0xff455A64), 
          secondary: Color(0xff263238),
          secondaryVariant: Color(0xff768F9B),
          surface: Color(0xffB7A3A2),
          background: Color(0xff303F46),
          error: Color(0xff9E001A),
          onPrimary: Color(0xffB7A3A2),
          onSecondary: Color(0xffF5EADD),
          onSurface: Color(0xffB7A3D2),
          onBackground: Color(0xffB7A3A2),
          onError: Color(0xffF5EADD),
          brightness: Brightness.light,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: const Color(0xffFFFFFF),
            backgroundColor: const Color(0xffFF8426),
          )
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.normal,
            fontSize: 20.0,
            color: Color(0xffB7A3A2)
          ),
        ),
        textTheme: const TextTheme(
          // headline1
          headline2: TextStyle(
            fontFamily: 'Rubik',
            fontSize: 24.0,
            fontWeight: FontWeight.normal,
            color: Color(0xffFFFFFF),
          ),
          headline3: TextStyle(
            fontFamily: 'Rubik',
            fontSize: 24.0,
            fontWeight: FontWeight.normal,
            color: Color(0xff263238),
          ),
          headline4: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 18.0,
            fontWeight: FontWeight.normal,
            color: Color(0xff263238),
          ),
          // headline5
          // headline6
          subtitle1: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
            color: Color(0xff263238),
          ),
          subtitle2: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
            color: Color(0xffFFFFFF),
          ),
          bodyText1: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 12.0,
            fontWeight: FontWeight.normal,
            color: Color(0xff1F2A31),
            height: 1.5,
          ),
          bodyText2: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 12.0,
            fontWeight: FontWeight.normal,
            color: Color(0xffFFFFFF),
            height: 1.5,
          ),
          // caption
          // button
          // overline
        ),
      );