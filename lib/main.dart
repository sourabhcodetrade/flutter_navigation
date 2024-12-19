import 'dart:async';
import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_setup/utils/constants/app_config.dart';
import 'package:flutter_setup/utils/manager/get_it_manager.dart';

import 'app/modules/on_board/view/my_app.dart';

void main() {
  /// DO NOT Change Environment without approval
  AppConfig.instance.setEnvironment(Environment.prod);
  mainDelegate();
}

void mainDelegate() async {
  runZonedGuarded<void>(() async {
    HttpOverrides.global = MyHttpOverrides();
    WidgetsFlutterBinding.ensureInitialized();
    await initializeGetItDependencies();
    if (!AppConfig.instance.isFlavourInitialized) {
      AppConfig.instance.setEnvironment(AppConfig.instance.currentEnv);
    }
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    runApp(
      const MyApp(),
    );
  }, (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack);
  });
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) =>
      super.createHttpClient(context)
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
}
