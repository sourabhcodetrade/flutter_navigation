import 'package:flutter/material.dart';
import 'package:flutter_setup/extension/navigation_extension.dart';
import 'package:flutter_setup/utils/manager/navigation_manager.dart';

import '../../utils/constants/enums/enum_route_name.dart';

final class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    Future.delayed(
      Duration(seconds: 3),
      () => context.pushNamed(RootRouteName.paymentRouter),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      child: Text("Home"),
    );
  }
}
