import 'dart:async';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flowers_app/domain/auth/app_user.dart';
import 'package:flowers_app/domain/auth/authenticate.dart';
import 'package:flowers_app/domain/core/errors/failure.dart';
import 'package:flowers_app/domain/core/local_store/local_store.dart';
import 'package:flowers_app/infrastructure/datasource/app_data_source.dart';
import 'package:flowers_app/presentation/auth/sign_in/sign_in_page.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runZonedGuarded(
    () async {
      // WidgetsFlutterBinding.ensureInitialized();
      // await Firebase.initializeApp();
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
                user: AppUser(
                  remote: dataSource.dataSet('client'),
                ),
                // firebaseAuth: FirebaseAuth.instance,
              ),
            ),
          },
          theme: appThemeData,
        ),
      );
    },
    (error, stackTrace) => 
      throw Failure(
        message: '[main] error: $error', 
        stackTrace: stackTrace,
      ),
  );
}
