import 'dart:async';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_app/domain/auth/app_user.dart';
import 'package:flowers_app/domain/auth/authenticate.dart';
import 'package:flowers_app/domain/core/errors/failure.dart';
import 'package:flowers_app/infrastructure/datasource/app_data_source.dart';
import 'package:flowers_app/presentation/auth/sign_in/sign_in_page.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';

void main() {
  runZonedGuarded(
    () async {
      // WidgetsFlutterBinding.ensureInitialized();
      // await Firebase.initializeApp();
      final AppUserSqlAccess clientSqlAccess = SqlAccess(
        address: ApiAddress(host: const Setting('api-host').toString(), port: const Setting('api-port').toInt),
        authToken: const Setting('api-auth-token').toString(),
        database: const Setting('api-database').toString(),
        sqlBuilder: (sql, userPhone) {
          return Sql(sql: "select * from client where phone = '${userPhone?.numberWithCode}';");
        },
      );
      runApp(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SignInPage(
              auth: Authenticate(
                user: AppUser(
                  remote: clientSqlAccess,
                ),
                // firebaseAuth: FirebaseAuth.instance,
              ),
            ),
          initialRoute: '/signInPage',
          routes: {
            '/signInPage': (context) => SignInPage(
              auth: Authenticate(
                user: AppUser(
                  remote: clientSqlAccess,
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
