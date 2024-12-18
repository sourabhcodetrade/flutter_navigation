import 'package:flutter/material.dart';
import 'package:flutter_setup/utils/constants/enums/enum_route_name.dart';

extension NavigationExtension on BuildContext {
  Future<T?> pushNamed<T extends Object?>(
    RouteName routeName, {
    final bool withNavBar = true,
    Object? args,
  }) =>
      Navigator.of(this, rootNavigator: !withNavBar)
          .pushNamed<T>(routeName.name, arguments: args);

  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(RouteName routeName,
      {Object? args}) {
    return Navigator.of(this, rootNavigator: true).pushNamedAndRemoveUntil<T>(
      routeName.name,
      (route) => false,
      arguments: args,
    );
  }

  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    RouteName routeName, {
    TO? result,
    final bool withNavBar = true,
    Object? args,
  }) =>
      Navigator.of(this, rootNavigator: !withNavBar)
          .pushReplacementNamed<T?, TO>(routeName.name,
              arguments: args, result: result);

  void pop<T extends Object?>({T? args, bool withNavBar = true}) =>
      Navigator.of(this, rootNavigator: !withNavBar).pop<T?>(args);

  bool canPop({final bool withNavBar = true}) {
    final NavigatorState? navigator =
        Navigator.maybeOf(this, rootNavigator: !withNavBar);
    return navigator != null && navigator.canPop();
  }

  void hideBottomSheet<T extends Object?>({final T? args}) =>
      pop(args: args, withNavBar: false);

  void hideDialog<T extends Object?>({final T? args}) =>
      pop(args: args, withNavBar: false);
}
