import 'package:flowers_app/domain/user/user.dart';
import 'package:flowers_app/infrastructure/api/app_data_source.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flowers_app/presentation/purchase/purchase_overview/purchase_overview_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: PurchaseListPage(
      //   dataSource: dataSource,
      // ),
      initialRoute: '/',
      routes: {
        '/': (context) => PurchaseOverviewPage(
          dataSource: dataSource,
          user: User(id: '2', name: 'Антон', account: 0),
        ),
        // When navigating to the "/second" route, build the SecondScreen widget.
        // '/second': (context) => 
      },
      theme: appThemeData,
    )
  );
}