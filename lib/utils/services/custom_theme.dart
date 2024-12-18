import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../manager/get_it_manager.dart';

final class CustomTheme {
  ThemeData lightTheme() {
    final OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(
        color: getIt<ColorConstants>().lightGreyColor,
        width: 1,
      ),
    );
    return ThemeData(
      useMaterial3: false,
      scaffoldBackgroundColor: getIt<ColorConstants>().scaffoldBgColor,
      primaryColor: getIt<ColorConstants>().primaryColor,
      colorScheme:
          ColorScheme.light(primary: getIt<ColorConstants>().primaryColor),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(color: getIt<ColorConstants>().primaryColor),
        backgroundColor: getIt<ColorConstants>().whiteColor,
        elevation: 1,
        titleTextStyle: TextStyle(
          color: getIt<ColorConstants>().primaryColor,
          height: 1,
          fontSize: 15,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: getIt<ColorConstants>().whiteColor,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: getIt<ColorConstants>().primaryColor,
        unselectedItemColor:
            getIt<ColorConstants>().bottomNavBarUnselectedColor,
        selectedIconTheme:
            IconThemeData(color: getIt<ColorConstants>().primaryColor),
        unselectedIconTheme: IconThemeData(
            color: getIt<ColorConstants>().bottomNavBarUnselectedColor),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
          color: getIt<ColorConstants>().primaryColor),
      inputDecorationTheme: InputDecorationTheme(
        border: outlineInputBorder,
        hintStyle: const TextStyle(
          color: Color(0xFF848484),
          height: 1,
          fontWeight: FontWeight.normal,
          fontSize: 12,
        ),
        focusColor: const Color(0xFF848484),
        focusedBorder: outlineInputBorder,
        enabledBorder: outlineInputBorder,
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        prefixIconColor: getIt<ColorConstants>().textFieldIconColor,
        suffixIconColor: getIt<ColorConstants>().textFieldIconColor,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      ),
      textSelectionTheme: TextSelectionThemeData(
          cursorColor: getIt<ColorConstants>().greyColor),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: getIt<ColorConstants>().primaryColor,
          shadowColor: getIt<ColorConstants>().shadowColor,
          elevation: 5,
          padding: const EdgeInsetsDirectional.only(start: 30.0, end: 30.0),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: BorderSide(color: getIt<ColorConstants>().primaryColor),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          iconColor: getIt<ColorConstants>().primaryColor,
          foregroundColor: getIt<ColorConstants>().primaryColor,
        ),
      ),
      radioTheme: RadioThemeData(
        fillColor:
            WidgetStateProperty.all(getIt<ColorConstants>().primaryColor),
      ),
      textTheme: TextTheme(
        // headline 1
        displayLarge: Typography.whiteMountainView.displayMedium?.copyWith(
          height: 1,
        ),
        // headline 2
        displayMedium: Typography.whiteMountainView.displayMedium?.copyWith(
          height: 1,
        ),
        // headline 3
        displaySmall: Typography.whiteMountainView.displayMedium?.copyWith(
          height: 1,
        ),
        // headline 4
        headlineMedium: Typography.whiteMountainView.displayMedium?.copyWith(
          height: 1,
        ),
        // headline 5
        headlineSmall: Typography.whiteMountainView.displayMedium?.copyWith(
          height: 1,
        ),
        // headline 6
        titleLarge: Typography.whiteMountainView.displayMedium?.copyWith(
          height: 1,
        ),
        // // Body Medium fonts - for Medium common texts
        bodyMedium: Typography.whiteMountainView.bodyMedium?.copyWith(
          height: 1,
          color: getIt<ColorConstants>().primaryColor,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((state) {
          if (state.contains(WidgetState.selected) ||
              state.contains(WidgetState.focused) ||
              state.contains(WidgetState.pressed)) {
            return getIt<ColorConstants>().primaryColor;
          }
          if (state.contains(WidgetState.error)) return Colors.red;
          if (state.contains(WidgetState.disabled)) {
            return getIt<ColorConstants>().greyColor;
          }
          return null;
        }),
      ),
      dialogTheme: DialogTheme(
        titleTextStyle: Typography.whiteMountainView.displayLarge?.copyWith(
          color: Colors.black,
          fontSize: 18,
        ),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: getIt<ColorConstants>().whiteColor,
        headerBackgroundColor: getIt<ColorConstants>().primaryColor,
        headerForegroundColor: getIt<ColorConstants>().whiteColor,
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: getIt<ColorConstants>().whiteColor,
      ),
    );
  }

  ThemeData darkTheme() {
    final OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(
        color: getIt<ColorConstants>().darkGreyColor,
        width: 1,
      ),
    );
    return ThemeData(
      useMaterial3: false,
      scaffoldBackgroundColor: getIt<ColorConstants>().darkBackgroundColor,
      primaryColor: getIt<ColorConstants>().primaryColor,
      colorScheme:
          ColorScheme.dark(primary: getIt<ColorConstants>().primaryColor),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(color: getIt<ColorConstants>().whiteColor),
        backgroundColor: getIt<ColorConstants>().darkBackgroundColor,
        elevation: 1,
        titleTextStyle: TextStyle(
          color: getIt<ColorConstants>().whiteColor,
          height: 1,
          fontSize: 15,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: getIt<ColorConstants>().darkBackgroundColor,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: getIt<ColorConstants>().primaryColor,
        unselectedItemColor:
            getIt<ColorConstants>().darkBottomNavBarUnselectedColor,
        selectedIconTheme:
            IconThemeData(color: getIt<ColorConstants>().primaryColor),
        unselectedIconTheme: IconThemeData(
          color: getIt<ColorConstants>().darkBottomNavBarUnselectedColor,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: getIt<ColorConstants>().primaryColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: outlineInputBorder,
        hintStyle: TextStyle(
          color: getIt<ColorConstants>().darkHintTextColor,
          height: 1,
          fontWeight: FontWeight.normal,
          fontSize: 12,
        ),
        focusColor: getIt<ColorConstants>().darkHintTextColor,
        focusedBorder: outlineInputBorder,
        enabledBorder: outlineInputBorder,
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        prefixIconColor: getIt<ColorConstants>().textFieldIconColor,
        suffixIconColor: getIt<ColorConstants>().textFieldIconColor,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: getIt<ColorConstants>().primaryColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: getIt<ColorConstants>().primaryColor,
          shadowColor: getIt<ColorConstants>().shadowColor,
          elevation: 5,
          padding: const EdgeInsetsDirectional.only(start: 30.0, end: 30.0),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: BorderSide(color: getIt<ColorConstants>().primaryColor),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          iconColor: getIt<ColorConstants>().primaryColor,
          foregroundColor: getIt<ColorConstants>().primaryColor,
        ),
      ),
      radioTheme: RadioThemeData(
        fillColor:
            WidgetStateProperty.all(getIt<ColorConstants>().primaryColor),
      ),
      textTheme: TextTheme(
        displayLarge: Typography.whiteMountainView.displayMedium?.copyWith(
          height: 1,
          color: getIt<ColorConstants>().whiteColor,
        ),
        displayMedium: Typography.whiteMountainView.displayMedium?.copyWith(
          height: 1,
          color: getIt<ColorConstants>().whiteColor,
        ),
        displaySmall: Typography.whiteMountainView.displayMedium?.copyWith(
          height: 1,
          color: getIt<ColorConstants>().whiteColor,
        ),
        headlineMedium: Typography.whiteMountainView.displayMedium?.copyWith(
          height: 1,
          color: getIt<ColorConstants>().whiteColor,
        ),
        headlineSmall: Typography.whiteMountainView.displayMedium?.copyWith(
          height: 1,
          color: getIt<ColorConstants>().whiteColor,
        ),
        titleLarge: Typography.whiteMountainView.displayMedium?.copyWith(
          height: 1,
          color: getIt<ColorConstants>().whiteColor,
        ),
        bodyMedium: Typography.whiteMountainView.bodyMedium?.copyWith(
          height: 1,
          color: getIt<ColorConstants>().whiteColor,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((state) {
          if (state.contains(WidgetState.selected) ||
              state.contains(WidgetState.focused) ||
              state.contains(WidgetState.pressed)) {
            return getIt<ColorConstants>().primaryColor;
          }
          if (state.contains(WidgetState.error)) return Colors.red;
          if (state.contains(WidgetState.disabled)) {
            return getIt<ColorConstants>().greyColor;
          }
          return null;
        }),
      ),
      dialogTheme: DialogTheme(
        titleTextStyle: Typography.whiteMountainView.displayLarge?.copyWith(
          color: getIt<ColorConstants>().whiteColor,
          fontSize: 18,
        ),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: getIt<ColorConstants>().darkBackgroundColor,
        headerBackgroundColor: getIt<ColorConstants>().primaryColor,
        headerForegroundColor: getIt<ColorConstants>().whiteColor,
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: getIt<ColorConstants>().darkBackgroundColor,
      ),
    );
  }
}
