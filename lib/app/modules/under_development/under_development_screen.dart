import 'package:flutter/material.dart';
import 'package:flutter_setup/extension/localization_extension.dart';

import '../../../core/widgets/app_bar/custom_app_bar.dart';

final class UnderDevelopmentScreen extends StatelessWidget {
  final bool showLeading;
  const UnderDevelopmentScreen({super.key, this.showLeading = true});

  @override
  Scaffold build(BuildContext context) => Scaffold(
        appBar: CustomAppBar(
          context.localization.underDevelopment,
          showLeading: showLeading,
        ),
        body: Center(child: Text(context.localization.comingSoon)),
      );
}
