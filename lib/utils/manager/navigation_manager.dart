import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_setup/core/screens/home.dart';
import 'package:flutter_setup/core/screens/payment_screen.dart';
import 'package:flutter_setup/core/screens/splash.dart';

import '../../app/modules/under_development/under_development_screen.dart';

import '../constants/enums/enum_route_name.dart';

final class NavigationManager {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static Route<dynamic> onRootGenerateRoute(RouteSettings routeSettings) {
    Map<String, dynamic>? args =
        routeSettings.arguments as Map<String, dynamic>?;
    return MaterialPageRoute(
      settings: routeSettings,
      builder: (context) => getRootRouteScreen(
        routeName: EnumToString.fromString(
                RootRouteName.values, routeSettings.name ?? 'dashboard') ??
            RootRouteName.dashboard,
        args: args ?? {},
      ),
    );
  }

  static Route<dynamic> onPaymentGenerateRoute(RouteSettings routeSettings) {
    Map<String, dynamic>? args =
        routeSettings.arguments as Map<String, dynamic>?;
    return MaterialPageRoute(
      settings: routeSettings,
      builder: (context) => getPaymentRouteScreen(
        routeName: EnumToString.fromString(
                PaymentRouteName.values, routeSettings.name ?? 'dashboard') ??
            PaymentRouteName.payment1,
        args: args ?? {},
      ),
    );
  }

  static Widget getRootRouteScreen({
    required final RootRouteName routeName,
    final Map<String, dynamic> args = const {},
  }) {
    Widget routeScreen = const UnderDevelopmentScreen();
    routeScreen = switch (routeName) {
      // ************** OnBoard module starts **************
      RootRouteName.splashScreen => Splash(),
      RootRouteName.paymentRouter => PaymentRouter(),
      RootRouteName.home => Home(),
      // ************** OnBoard module ends **************

      _ => UnderDevelopmentScreen(showLeading: args['showLeading'] ?? true),
    };
    return routeScreen;
  }

  static Widget getPaymentRouteScreen({
    required final PaymentRouteName routeName,
    final Map<String, dynamic> args = const {},
  }) {
    Widget routeScreen = const UnderDevelopmentScreen();
    routeScreen = switch (routeName) {
      // ************** Payment module starts **************
      PaymentRouteName.payment1 => PaymentScreen1(),
      PaymentRouteName.payment2 => PaymentScreen2(),
      PaymentRouteName.payment3 => PaymentScreen3(),
      PaymentRouteName.payment4 => PaymentScreen4(),
      // ************** Payment module ends **************
      _ => UnderDevelopmentScreen(showLeading: args['showLeading'] ?? true),
    };
    return routeScreen;
  }
}
