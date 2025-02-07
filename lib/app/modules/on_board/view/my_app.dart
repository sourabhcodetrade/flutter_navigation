import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_setup/utils/constants/enums/enum_route_name.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_setup/utils/manager/get_it_manager.dart';
import 'package:flutter_setup/utils/services/app_state.dart';
import 'package:flutter_setup/utils/services/custom_theme.dart';
import 'package:flutter_setup/utils/services/firebase_services.dart';

import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/manager/local_notification_manager.dart';
import '../../../../utils/manager/navigation_manager.dart';
import '../../../../utils/manager/storage_manager.dart';

@pragma('vm:entry-point')
Future<void> _onBackgroundMessage(RemoteMessage remoteMessage) async {
  try {
    await initializeGetItDependencies();
  } catch (ex) {
    debugPrint("exception caught in onBackground Message => $ex");
  }
  await getIt<StorageManager>().setSPInstance();
  final userId =
      await getIt<StorageManager>().getIntData(getIt<AppConstants>().userId);
  if (userId == null) return;
  getIt<LocalNotificationManager>().displayMessage(remoteMessage);
}

final class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

final class _MyAppState extends State<MyApp> {
  String newMessageId = '';

  @override
  void initState() {
    // _initializeFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Setup',
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), // English
      ],
      navigatorKey: NavigationManager.rootNavigatorKey,
      initialRoute: RootRouteName.splashScreen.routeName,
      onGenerateRoute: NavigationManager.onRootGenerateRoute,
      // home: Navigator(
      //   key: NavigationManager.navigatorKey,
      //   initialRoute: RootRouteName.splashScreen.routeName,
      //   onGenerateRoute: NavigationManager.onRootGenerateRoute,
      // ),
      themeMode: ThemeMode.light,
      theme: getIt<CustomTheme>().lightTheme(),
    );
  }
}

extension _HelperMethod on _MyAppState {
  Future<void> _initializeFirebase() async {
    getIt<FirebaseServices>().onMessageListener(
      (remoteMessage) async {
        if (remoteMessage.messageId != newMessageId ||
            getIt<AppState>().userId.isEmpty ||
            !(await getIt<FirebaseServices>()
                .listenerFunction(remoteMessage))) {
          return;
        }
        if (!mounted && NavigationManager.navigatorKey.currentContext == null) {
          return;
        }
        if (!(getIt<LocalNotificationManager>().isInitialized)) {
          await getIt<LocalNotificationManager>().initialize(
              NavigationManager.navigatorKey.currentContext ?? context);
        }

        getIt<LocalNotificationManager>().displayMessage(remoteMessage);
        newMessageId = remoteMessage.messageId!;
      },
    );

    getIt<FirebaseServices>().getInitialMessage(
      (remoteMessage) async {
        await getIt<AppState>().appInitializationCompleter.future;
        if (getIt<AppState>().userId.isEmpty ||
            !mounted && NavigationManager.navigatorKey.currentContext == null) {
          return;
        }
        if (!(getIt<LocalNotificationManager>().isInitialized)) {
          await getIt<LocalNotificationManager>().initialize(
              NavigationManager.navigatorKey.currentContext ?? context);
        }
        getIt<LocalNotificationManager>().navigate(
            NavigationManager.navigatorKey.currentContext ?? context,
            remoteMessage.data);
      },
    );

    getIt<FirebaseServices>().onBackgroundMessageListener(_onBackgroundMessage);

    getIt<FirebaseServices>().onMessageOpenedAppHandler(
      (remoteMessage) async {
        if (getIt<AppState>().userId.isEmpty ||
            !mounted && NavigationManager.navigatorKey.currentContext == null) {
          return;
        }
        if (!(getIt<LocalNotificationManager>().isInitialized)) {
          await getIt<LocalNotificationManager>().initialize(
              NavigationManager.navigatorKey.currentContext ?? context);
        }
        getIt<LocalNotificationManager>().navigate(
            NavigationManager.navigatorKey.currentContext ?? context,
            remoteMessage.data);
      },
    );
  }
}
