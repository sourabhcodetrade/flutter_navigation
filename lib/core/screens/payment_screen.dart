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
  late final NavigatorState navigatorState;
  NavigationRouterWidget({
    super.key,
    required this.initialRoute,
    required this.onGenerateRoute,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        navigatorState.canPop() ? navigatorState.pop() : context.pop();
      },
      child: Navigator(
        onGenerateInitialRoutes: (navigator, initialRoute) {
          navigatorState = navigator;
          return Navigator.defaultGenerateInitialRoutes(
              navigator, initialRoute);
        },
        onGenerateRoute: onGenerateRoute,
        initialRoute: initialRoute.routeName,
      ),
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment 1"),
      ),
      body: Center(
        child: Container(
          color: Colors.yellow,
          child: ElevatedButton(
              onPressed: () {
                context.pushNamed(PaymentRouteName.payment2);
              },
              child: Text("Payment 2")),
        ),
      ),
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment 2"),
      ),
      body: Center(
        child: Container(
          color: Colors.tealAccent,
          child: ElevatedButton(
              onPressed: () {
                context.pushNamed(PaymentRouteName.payment3);
              },
              child: Text("Payment 3")),
        ),
      ),
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment 3"),
      ),
      body: Center(
        child: Container(
          color: Colors.yellow,
          child: ElevatedButton(
              onPressed: () {
                context.pushNamed(PaymentRouteName.payment4);
              },
              child: Text("Payment 3")),
        ),
      ),
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment 4"),
      ),
      body: Center(
        child: Container(
          color: Colors.yellow,
          child: ElevatedButton(
              onPressed: () {
                NavigationManager.rootNavigatorKey.currentContext!.pop();
              },
              child: Text("Home")),
        ),
      ),
    );
  }
}
