import 'package:flutter/material.dart';
import 'package:flutter_setup/extension/navigation_extension.dart';
import 'package:flutter_setup/utils/constants/enums/enum_route_name.dart';

final class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Future.delayed(
      Duration(seconds: 3),
      () => context.pushNamed(RootRouteName.home),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Text("Splash"),
    );
  }
}
