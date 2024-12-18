import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';

import '../../app/modules/under_development/under_development_screen.dart';

import '../constants/enums/enum_route_name.dart';

final class NavigationManager {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    Map<String, dynamic>? args =
        routeSettings.arguments as Map<String, dynamic>?;
    return MaterialPageRoute(
      builder: (context) => getRouteScreen(
        routeName: EnumToString.fromString(
                RouteName.values, routeSettings.name ?? 'dashboard') ??
            RouteName.dashboard,
        args: args ?? {},
      ),
    );
  }

  static Widget getRouteScreen({
    required final RouteName routeName,
    final Map<String, dynamic> args = const {},
  }) {
    Widget routeScreen = const UnderDevelopmentScreen();
    routeScreen = switch (routeName) {
      // ************** OnBoard module starts **************
      RouteName.splashScreen => Placeholder(),
      // ************** OnBoard module ends **************

      _ => UnderDevelopmentScreen(showLeading: args['showLeading'] ?? true),
    };
    return routeScreen;
  }
}
