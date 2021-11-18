import 'package:flowers_app/domain/auth/authenticate.dart';
import 'package:flowers_app/domain/auth/user.dart';
import 'package:flowers_app/domain/core/local_store/local_store.dart';
import 'package:flowers_app/infrastructure/datasource/app_data_source.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flowers_app/presentation/sign_in/sign_in_page.dart';
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
        // '/second': (context) => PurchaseOverviewPage(
        //   dataSource: dataSource,
        //   user: User(id: '2', phone: 'Антон', account: 0),
        // ),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/': (context) => SignInPage(
          auth: Authenticate(
            localStore: LocalStore(), 
            user: User(
              remote: dataSource.dataSet('client'),
            ),
          ),
        )
      },
      theme: appThemeData,
    )
  );
}