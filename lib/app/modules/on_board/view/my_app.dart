import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_setup/utils/constants/enums/enum_route_name.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_setup/utils/manager/get_it_manager.dart';
import 'package:flutter_setup/utils/services/custom_theme.dart';

import '../../../../utils/manager/navigation_manager.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      themeMode: ThemeMode.light,
      theme: getIt<CustomTheme>().lightTheme(),
      initialRoute: RouteName.splashScreen.name,
      onGenerateRoute: NavigationManager.onGenerateRoute,
    );
  }
}
