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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Splash"),
      ),
      body: Center(
        child: Container(
          color: Colors.red,
          child: ElevatedButton(
              onPressed: () {
                context.pushNamed(RootRouteName.home);
              },
              child: Text("Home")),
        ),
      ),
    );
  }
}
