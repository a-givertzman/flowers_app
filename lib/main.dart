import 'package:flowers_app/domain/purchase/purchase.dart';
import 'package:flowers_app/domain/purchase/purchase_list.dart';
import 'package:flowers_app/domain/purchase/purchase_status.dart';
import 'package:flowers_app/infrastructure/api/api_request.dart';
import 'package:flowers_app/infrastructure/api/api_request_params.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';
import 'package:flowers_app/infrastructure/datasource/data_source.dart';
import 'package:flowers_app/presentation/purchase/purchase_list/purchase_list_page.dart';
import 'package:flowers_app/presentation/purchase/purchase_list/widgets/error_purchase_card.dart';
import 'package:flowers_app/presentation/purchase/purchase_list/widgets/purchase_card.dart';
import 'package:flowers_app/presentation/purchase/purchase_list/widgets/purchase_list_body.dart';
import 'package:flutter/material.dart';

void main() {
  const DataSource dataSource = DataSource({
    'purchase': DataSet(
      name: 'purchase', 
      apiRequest: ApiRequest(
        url: 'http://u1489690.isp.regruhosting.ru/public/api/getView.php',
        params: ApiRequestParams(
          tableName: 'purchase_preview',
          // where: [{'operator': 'where', 'field': 'id', 'cond': '=', 'value': 1}]
        ),
      ),
    ),
  });
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const PurchaseListPage(
        dataSource: dataSource,
      ),
      theme: ThemeData(
        colorScheme: const ColorScheme(
          primary: Color(0xff775246),
          primaryVariant: Color(0xff353535),
          secondary: Color(0xffB7A3A2),
          secondaryVariant: Color(0xffB7A3A2),
          surface: Color(0xffB7A3A2),
          background: Color(0xffFBF6F1),
          error: Color(0xff9E001A),
          onPrimary: Color(0xffFFFEFC),
          onSecondary: Color(0xff1F2A31),
          onSurface: Color(0xffB7A3D2),
          onBackground: Color(0xff353535),
          onError: Color(0xff9E441A),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          // backgroundColor: const Color(0xff644C3C),
          // color: const Color(0xffFFFFFF),
          titleTextStyle: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            fontSize: 20.0,
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
      ),
    )
  );
}