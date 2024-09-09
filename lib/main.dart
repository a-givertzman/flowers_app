import 'dart:async';

import 'package:flowers_app/domain/auth/app_user.dart';
import 'package:flowers_app/domain/auth/authenticate.dart';
import 'package:flowers_app/presentation/auth/sign_in/sign_in_page.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flowers_app/presentation/purchase/purchase_overview/purchase_overview_page.dart';
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
  const log = Log("main");
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await _initStatics();      
      final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
      final signInPage = SignInPage(
        auth: Authenticate(
          user: AppUser(),
        ),
        onSuccess: (context, user) {
          log.warning(".SignInPage.onSuccess | user: $user");
          return PurchaseOverviewPage(user: user);
        },
      );
      runApp(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          home: signInPage,
          initialRoute: '/signInPage',
          routes: {
            '/signInPage': (context) => signInPage,
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
