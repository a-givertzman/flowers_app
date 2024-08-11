import 'dart:async';

import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_app/domain/auth/app_user.dart';
import 'package:flowers_app/domain/auth/authenticate.dart';
import 'package:flowers_app/presentation/auth/sign_in/sign_in_page.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flowers_app/settings/app_settings.dart';
import 'package:flowers_app/settings/setting.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/src/core/json/json_map.dart';
import 'package:hmi_core/src/core/text_file.dart';
///
/// Application entry point
void main() {
  Log.initialize(level: LogLevel.all);

  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      // await Firebase.initializeApp();
      await _initStatics();      
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
///
/// Application static entities initialization
Future<void> _initStatics() async {
  await AppSettings.initialize(
    jsonMap: JsonMap.fromTextFile(
      const TextFile.asset(
        'assets/settings/app-settings.json',
      ),
    ),
  );
}
