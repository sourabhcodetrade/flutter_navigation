import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_setup/utils/services/firebase_services.dart';
import 'package:flutter_setup/utils/services/package_services.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../constants/app_config.dart';
import '../constants/app_constants.dart';
import '../manager/get_it_manager.dart';
import '../manager/storage_manager.dart';

final class AppState {
  final Completer<void> appInitializationCompleter = Completer<void>();
  Size _screenSize = Size.zero;
  final String _appName = "";
  String _timeZone = "",
      _sessionId = "",
      _deviceId = "",
      _fcmToken = "",
      _apnsToken = "",
      _userId = "",
      _appVersion = "",
      _accessToken = "";

  // Don't change this
  final String _authKeyFile = "";

  final ValueNotifier<bool> isArabic = ValueNotifier<bool>(true);

  // Getter
  String get appName => _appName;

  String get timeZone => _timeZone;

  String get userId => _userId;

  String get sessionId => _sessionId;

  String get deviceId => _deviceId;

  String get accessToken => _accessToken;

  String get authKeyFile => _authKeyFile;

  String get fcmToken => _fcmToken;

  String get apnsToken => _apnsToken;

  String get appVersion => _appVersion;

  double getScreenHeight({double percent = 1}) => _screenSize.height * percent;

  double getScreenWidth({double percent = 1}) => _screenSize.width * percent;

  // Setter
  set setScreenSize(BuildContext context) =>
      _screenSize = MediaQuery.of(context).size;

  set setSessionId(String sessionId) => _sessionId = sessionId;

  set setUserId(String userId) => _userId = userId;

  set setAccessToken(String token) => _accessToken = token;

  /// Method to set initial Values
  Future<void> setInitialValues() async {
    _timeZone = await FlutterTimezone.getLocalTimezone();
    _sessionId = (await getIt<StorageManager>()
            .getData(getIt<AppConstants>().sessionId) ??
        '');
    debugPrint('Current Env is "${AppConfig.instance.currentEnv.name}"');
    await Future.wait([
      _setDeviceId(),
      _setPackageInfo(),
      _setAPNSToken(),
      _setFCMToken(),
    ]);
  }

  void _clearValues() {
    _accessToken = "";
    _fcmToken = "";
    _apnsToken = "";
    _userId = "";
  }

  Future<void> clearAllValues() async {
    _clearValues();
    final storageManager = getIt<StorageManager>();
    final bool isRememberMe =
        await storageManager.getBoolData(getIt<AppConstants>().isRememberMe);
    final String email =
        await storageManager.getData(getIt<AppConstants>().emailId) ?? '';
    final String password =
        await storageManager.getData(getIt<AppConstants>().password) ?? '';

    /// delete old values
    await getIt<FirebaseServices>().deleteFCMToken();
    await storageManager.clearData();

    /// setting up new values
    await Future.wait([
      _setFCMToken(),
      _setAPNSToken(),
      if (isRememberMe)
        storageManager.saveData(getIt<AppConstants>().emailId, email),
      if (isRememberMe)
        storageManager.saveData(getIt<AppConstants>().password, password),
      if (isRememberMe)
        storageManager.saveBoolData(
            getIt<AppConstants>().isRememberMe, isRememberMe),
    ]);
  }

  /// Set FCM Token
  Future<void> _setFCMToken() async {
    if (_fcmToken.isNotEmpty) return debugPrint("FCM Token already assigned.");
    await getIt<FirebaseServices>().getFCMToken();
    _apnsToken = getIt<FirebaseServices>().fcmToken;
  }

  /// Set APNS Token
  Future<void> _setAPNSToken() async {
    if (_apnsToken.isNotEmpty) {
      return debugPrint("APNS Token already assigned.");
    }
    await getIt<FirebaseServices>().getAPNSToken();
    _apnsToken = getIt<FirebaseServices>().apnsToken;
  }

  /// Set Device Id
  Future<void> _setDeviceId() async {
    if (_deviceId.isNotEmpty) return debugPrint("Device Id already assigned.");
    _deviceId = await getIt<PackageServices>().getDeviceId();
    debugPrint("Device Id is => $_deviceId");
  }

  /// Set Package info
  Future<void> _setPackageInfo() async {
    if (_appVersion.isNotEmpty) {
      return debugPrint("App Version is already assigned.");
    }
    try {
      _appVersion = (await PackageInfo.fromPlatform()).version;
      debugPrint("App Version is => $_appVersion");
    } catch (e) {
      debugPrint("Error found in _setPackageInfo => $e");
    }
  }
}
