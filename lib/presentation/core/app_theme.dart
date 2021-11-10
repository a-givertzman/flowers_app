import 'package:flutter/material.dart';

final appThemeData = ThemeData(
        colorScheme: const ColorScheme(
          primary: Color(0xffF5EADD),
          primaryVariant: Color(0xffF5EADD), //0xff353535
          secondary: Color(0xff413F30),
          secondaryVariant: Color(0xffF0CE65),
          surface: Color(0xffB7A3A2),
          background: Color(0xffF9F0E6),
          error: Color(0xff9E001A),
          onPrimary: Color(0xff1B2935),
          onSecondary: Color(0xffBBD667),//0xffF5EADD
          onSurface: Color(0xffB7A3D2),
          onBackground: Color(0xff413F30),
          onError: Color(0xff9E441A),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            fontSize: 20.0,
            color: Color(0xff1B2935)
          ),
        ),
        textTheme: const TextTheme(
          // headline1
          // headline2
          // headline3
          // headline4
          // headline5
          // headline6
          subtitle1: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: Color(0xffFFFFFF),
          ),
          // subtitle2
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
          )
          // caption
          // button
          // overline
        ),
      );