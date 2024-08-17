import 'dart:async';

import 'package:flowers_app/domain/auth/app_user.dart';
import 'package:flowers_app/domain/auth/authenticate.dart';
import 'package:flowers_app/presentation/auth/sign_in/sign_in_page.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flowers_app/settings/app_settings.dart';
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
      runApp(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SignInPage(
              auth: Authenticate(
                user: AppUser(),
                // firebaseAuth: FirebaseAuth.instance,
              ),
            ),
          initialRoute: '/signInPage',
          routes: {
            '/signInPage': (context) => SignInPage(
              auth: Authenticate(
                user: AppUser(),
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
