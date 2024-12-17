import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_constants.dart';

final class UtilMethods {
  static final UtilMethods instance = UtilMethods._();

  factory UtilMethods() => instance;

  UtilMethods._();

  /// this method will translate numeric numbers to arabic
  String translateNumericToArabicNumbers(final String number) => number
      .replaceAll('0', '٠')
      .replaceAll('1', '١')
      .replaceAll('2', '٢')
      .replaceAll('3', '٣')
      .replaceAll('4', '٤')
      .replaceAll('5', '٥')
      .replaceAll('6', '٦')
      .replaceAll('7', '٧')
      .replaceAll('8', '٨')
      .replaceAll('9', '٩');

  /// this method will translate arabic numbers to numeric
  String translateArabicToNumericNumber(final String number) => number
      .replaceAll('٠', '0')
      .replaceAll('١', '1')
      .replaceAll('٢', '2')
      .replaceAll('٣', '3')
      .replaceAll('٤', '4')
      .replaceAll('٥', '5')
      .replaceAll('٦', '6')
      .replaceAll('٧', '7')
      .replaceAll('٨', '8')
      .replaceAll('٩', '9');

  /// Method to call all validators
  Future<bool> callValidators(
      List<GlobalKey<FormFieldState>> validations) async {
    try {
      if (validations.isEmpty) return true;
      for (final validation in validations) {
        if (!validation.currentState!.validate()) return false;
      }
      return true;
    } catch (e) {
      debugPrint("$e");
      return false;
    }
  }

  /// Method to calculate BMI
  Future<double?> calculateBMI(String height, String weight) async {
    double? bmi;
    try {
      if (height.trim().isEmpty || weight.trim().isEmpty) {
        throw Exception("Height or Weight can't be empty");
      }
      final h = double.parse(height) / 100;
      final w = double.parse(weight);
      if ((height != "") && (weight != "")) {
        bmi = (w / math.pow(h, 2));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return bmi;
  }

  /// Method to parse bool value from Map fromJson
  bool boolValueParser(dynamic value) => (value is bool) ? value : false;

  /// Method to parse String value from Map fromJson
  String stringValueParser(
    dynamic value, {
    final String placeHolder = AppConstants.stringPlaceHolder,
  }) =>
      (value == false || value == null || value == "")
          ? placeHolder
          : (value is String)
              ? value
              : "$value";

  /// Method to parse Empty String value from Map fromJson
  String emptyStringValueParser(dynamic value) =>
      (value == false || value == null)
          ? ""
          : (value is String)
              ? value
              : "$value";

  /// Method to parse placeholder("-") to empty string
  String placeholderParser(dynamic value) =>
      (value == AppConstants.stringPlaceHolder)
          ? ""
          : (value is String)
              ? value
              : "$value";

  /// Method to parse placeholder("-") to bool value
  dynamic placeholderValueParser(dynamic value) =>
      (value == AppConstants.stringPlaceHolder)
          ? false
          : (value is String)
              ? value
              : "$value";

  /// Method to parse int value from Map fromJson
  int intValueParser(dynamic value) {
    try {
      if (value == false || value == null) {
        return 0;
      } else {
        int val = 0;
        if (value is double) {
          val = value.toInt();
        } else if (value is String) {
          val = int.parse(value);
        } else if (value is int) {
          val = value;
        } else {
          throw Exception("");
        }
        return val;
      }
    } catch (e) {
      log("Unable to parse in Int");
      return 0;
    }
  }

  /// Method to parse double value from Map fromJson
  double doubleValueParser(dynamic value) {
    try {
      if (value == false || value == null) {
        return 0;
      } else {
        double val = 0;
        if (value is double) {
          val = value;
        } else if (value is String) {
          val = double.parse(value);
        } else if (value is int) {
          val = value.toDouble();
        } else {
          throw Exception("");
        }
        return val;
      }
    } catch (e) {
      log("Unable to parse in double");
      return 0;
    }
  }

  /// Method to parse Date value from Map fromJson
  DateTime dateValueParser(
    dynamic value, {
    final DateTime? time,
    final bool isUtc = false,
    final bool isConvertToLocal = false,
  }) {
    DateTime parsedValue =
        (value == false || value == null || value.toString().isEmpty)
            ? time ?? DateTime.now()
            : (value is String)
                ? DateTime.parse(value + (isUtc ? "Z" : ""))
                : value;
    if (isConvertToLocal) return parsedValue.toLocal();
    return parsedValue;
  }

  /// Method to parse Date value from Map fromJson
  DateTime? nullableDateValueParser(
    dynamic value, {
    final bool isUtc = false,
  }) =>
      (value == false || value == null || value.toString().isEmpty)
          ? null
          : (value is String)
              ? DateTime.parse(value + (isUtc ? "Z" : ""))
              : value;

  /// Method to parse TimeOfDay value from Map fromJson
  TimeOfDay timeOfDayValueParser(dynamic value, {TimeOfDay? time}) {
    try {
      if (value == false || value == null || value.toString().isEmpty) {
        return time ?? const TimeOfDay(hour: 00, minute: 00);
      } else if (value is String) {
        return TimeOfDay(
            hour: int.parse(value.split(":")[0]),
            minute: int.parse(value.split(":")[1]));
      } else {
        final String time = "$value".replaceAll(".", ":");
        return TimeOfDay(
          hour: int.parse(time.split(":")[0]),
          minute: int.parse(time.split(":")[1]),
        );
      }
    } catch (e) {
      log("Unable to parse");
      return const TimeOfDay(hour: 00, minute: 00);
    }
  }

  /// Method to parse List value from Map fromJson
  List<T> listValueParser<T extends Object>(
      dynamic value, T Function(Map<String, dynamic> json) parseMethod) {
    try {
      return (value == false || value == null)
          ? []
          : (value as List).map((e) => parseMethod(e)).toList();
    } catch (e) {
      log("Unable to parse");
      return [];
    }
  }

  /// Method to parse List value from List fromJson
  List<T> listValueParserFromList<T extends Object>(
      dynamic value, T Function(List<dynamic> json) parseMethod) {
    try {
      return (value == false || value == null)
          ? []
          : (value as List).map((e) => parseMethod(e)).toList();
    } catch (e) {
      log("Unable to parse");
      return [];
    }
  }

  /// Method to parse List value from Map fromJson inside the compute method
  Future<List<T>> computeListValueParser<T extends Object>(
      dynamic value, T Function(Map<String, dynamic> json) parseMethod) async {
    try {
      if (value == false || value == null) return [];
      final List<T> computedData = await compute<List<dynamic>, List<T>>(
          (data) => data.map((e) => parseMethod(e)).toList(), value);
      return computedData;
    } catch (e) {
      log("Unable to parse");
      return [];
    }
  }

  /// Method to parse List value from Map fromJson
  T? methodValueParser<T extends Object>(
      dynamic value, T Function(Map<String, dynamic> json) parseMethod) {
    try {
      return switch (value) { false || null => null, _ => parseMethod(value) };
    } catch (e) {
      log("Unable to parse");
      return null;
    }
  }

  /// The function uses a switch statement to check the value against multiple cases.
  /// If the value matches any of the cases null, 0, '' (empty string),
  /// AppConstants.stringPlaceHolder, or [] (empty list), then it returns false.
  /// Otherwise, it returns the original value.
  dynamic paramValueParser(dynamic value) {
    return switch (value) {
      null || 0 || '' || AppConstants.stringPlaceHolder || [] => false,
      _ => value
    };
  }

  String doubleToTimeValueParser(dynamic value) {
    if (value is double) {
      String hour = value.toInt().toString();
      String minute = ((value - value.toInt()) * 60).round().toString();
      if (minute.length < 2) minute = "0$minute";
      if (hour.length < 2) hour = "0$hour";
      String time = '$hour:$minute';
      return time;
    } else {
      return AppConstants.stringPlaceHolder;
    }
  }

  /// HH:MM Formated String must be passes
  double timeToDoubleValueParser(String value) {
    try {
      double hour = double.parse(value.substring(0, 2));
      double minute = double.parse(value.substring(3, 5)) / 60;

      return hour + minute;
    } catch (ex) {
      throw const FormatException('Value does not match HH:MM Format');
    }
  }

  /// Method to parse List value from Map fromJson without null
  T nonNullMethodValueParser<T extends Object>(
      dynamic value, T Function(Map<String, dynamic> json) parseMethod) {
    try {
      return (value == false || value == null)
          ? parseMethod({})
          : parseMethod(value);
    } catch (e) {
      log("Unable to parse");
      return parseMethod({});
    }
  }

  /// Method to parse List value from Map fromJson
  List<T> listValueParserWithoutMethod<T extends Object>(dynamic value) {
    try {
      return (value == false || value == null)
          ? []
          : (value as List).map<T>((e) => e).toList();
    } catch (e) {
      log("Unable to parse");
      return [];
    }
  }

  void onScrollListener(void Function() onScroll, ScrollController controller) {
    final maxScroll = controller.position.maxScrollExtent;
    // final currentScroll = controller.position.pixels;
    if (maxScroll == controller.offset) onScroll();
  }

  String formatTime(TimeOfDay selectedTime, {bool withSecond = true}) {
    String time = "";
    time +=
        "${(selectedTime.hour.toString().length == 1) ? '0' : ''}${selectedTime.hour}:";
    time +=
        "${(selectedTime.minute.toString().length == 1) ? '0' : ''}${selectedTime.minute}";
    if (withSecond) time += ":00";
    return time;
  }

  String formatCupertinoTime(Duration selectedTime, {bool withSecond = true}) {
    final int hours = selectedTime.inHours,
        minutes = selectedTime.inMinutes,
        seconds = selectedTime.inSeconds;
    String time = "";
    time += "${(hours.toString().length == 1) ? '0' : ''}$hours:";
    time +=
        "${(minutes.toString().length == 1) ? '0' : ''}${hours > 0 ? (minutes % (60 * (hours - 1))) : minutes}";
    if (withSecond) time += ":$seconds";
    return time;
  }

  Future<String> selectTime(
    BuildContext context, {
    bool timeWithSeconds = false,
  }) async {
    final chosenTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dialOnly,
    );
    if (chosenTime == null) return '';
    return UtilMethods.instance
        .formatTime(chosenTime, withSecond: timeWithSeconds);
  }

  Future<void> setOrientation() async =>
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

  void changeSystemColor(Color color) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarColor: color,
      systemNavigationBarColor: color,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
  }
}
