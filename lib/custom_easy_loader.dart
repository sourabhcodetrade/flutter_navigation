import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_setup/core/widgets/custom/custom_loader_widget.dart';
import 'package:flutter_setup/core/widgets/dialog/custom_dialog.dart';

class CustomEasyLoader {
  static final ValueNotifier<bool> loader = ValueNotifier(false);

  Widget init(context, Widget child) {
    return ValueListenableBuilder(
      valueListenable: loader,
      builder: (_, val, ___) => Stack(
        alignment: Alignment.center,
        children: [
          IgnorePointer(
            ignoring: val,
            child: child,
          ),
          Visibility(
            visible: val,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: val ? Colors.black45 : Colors.transparent,
              child: BackgroundFadingSpinKitLoader(),
            ),
          )
        ],
      ),
    );
  }

  void show() {
    loader.value = true;
  }

  void dismiss() {
    loader.value = false;
  }
}
