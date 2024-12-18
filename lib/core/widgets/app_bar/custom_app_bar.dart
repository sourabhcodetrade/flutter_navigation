import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_setup/extension/navigation_extension.dart';

import '../../../utils/constants/color_constants.dart';
import '../../../utils/manager/get_it_manager.dart';
import '../../../utils/services/app_state.dart';

final class CustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget> actions;
  final bool showLeading;
  final double? leadingWidth;

  const CustomAppBar(
    this.title, {
    super.key,
    this.leading,
    this.actions = const [],
    this.showLeading = true,
    this.leadingWidth,
  });

  @override
  AppBar build(BuildContext context) => AppBar(
        leadingWidth: leadingWidth,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: getIt<ColorConstants>().primaryColor,
            fontFamily: "HelveticaNeueLTArabic",
          ),
        ),
        centerTitle: false,
        leading: showLeading ? leading ?? const AppBackButton() : null,
        actions: actions,
      );

  @override
  Size get preferredSize => const Size.fromHeight(50);
}

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  IconButton build(BuildContext context) => IconButton(
        onPressed: context.pop,
        icon: ValueListenableBuilder<bool>(
          valueListenable: appState.isArabic,
          builder: (context, value, child) => Transform.rotate(
            angle: value ? math.pi : 0,
            child: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
        ),
      );
}
