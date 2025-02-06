import 'package:flutter/material.dart';
import 'package:flutter_setup/extension/navigation_extension.dart';
import 'package:flutter_setup/utils/manager/navigation_manager.dart';

import '../../utils/constants/enums/enum_route_name.dart';

final class PaymentRouter extends StatelessWidget {
  const PaymentRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationRouterWidget(
      initialRoute: PaymentRouteName.payment1,
      onGenerateRoute: NavigationManager.onPaymentGenerateRoute,
      callback: () {},
    );
  }
}

class NavigationRouterWidget extends StatelessWidget {
  final Routes initialRoute;
  final Route<dynamic> Function(RouteSettings routeSettings) onGenerateRoute;
  final VoidCallback callback;
  const NavigationRouterWidget({
    super.key,
    required this.initialRoute,
    required this.onGenerateRoute,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: onGenerateRoute,
      initialRoute: initialRoute.routeName,
    );
  }
}

final class PaymentScreen1 extends StatefulWidget {
  const PaymentScreen1({super.key});

  @override
  State<PaymentScreen1> createState() => _PaymentScreen1State();
}

class _PaymentScreen1State extends State<PaymentScreen1> {
  @override
  void initState() {
    Future.delayed(
      Duration(seconds: 3),
      () => context.pushNamed(PaymentRouteName.payment2),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent,
      child: Text("P1"),
    );
  }
}

final class PaymentScreen2 extends StatefulWidget {
  const PaymentScreen2({super.key});

  @override
  State<PaymentScreen2> createState() => _PaymentScreen2State();
}

class _PaymentScreen2State extends State<PaymentScreen2> {
  @override
  void initState() {
    Future.delayed(
      Duration(seconds: 3),
      () => context.pushNamed(PaymentRouteName.payment3),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurple,
      child: Text("P2"),
    );
  }
}

final class PaymentScreen3 extends StatefulWidget {
  const PaymentScreen3({super.key});

  @override
  State<PaymentScreen3> createState() => _PaymentScreen3State();
}

class _PaymentScreen3State extends State<PaymentScreen3> {
  @override
  void initState() {
    Future.delayed(
      Duration(seconds: 3),
      () => context.pushNamed(PaymentRouteName.payment4),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.pink,
      child: Text("P3"),
    );
  }
}

final class PaymentScreen4 extends StatefulWidget {
  const PaymentScreen4({super.key});

  @override
  State<PaymentScreen4> createState() => _PaymentScreen4State();
}

class _PaymentScreen4State extends State<PaymentScreen4> {
  @override
  void initState() {
    Future.delayed(
      Duration(seconds: 3),
      () => NavigationManager.navigatorKey.currentContext!.pop(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.tealAccent,
      child: Text("P4"),
    );
  }
}
