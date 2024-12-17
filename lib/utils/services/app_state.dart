import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_setup/utils/services/package_services.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../constants/app_config.dart';
import '../constants/app_constants.dart';
import '../manager/get_it_manager.dart';
import '../manager/storage_manager.dart';

final AppState appState = AppState();

final class AppState {
  static final AppState instance = AppState._();

  factory AppState() => instance;

  AppState._();

  final Completer<void> appInitializationCompleter = Completer<void>();
  late Size _screenSize;
  final String _appName = "نهتم";
  String _timeZone = "",
      _sessionId = "",
      _deviceId = "",
      _fcmToken = "",
      _apnsToken = "",
      _voipToken = "",
      _userRole = "",
      _userId = "",
      _userName = "-",
      _userMail = "-",
      _physicianId = "",
      _partnerId = "",
      _appVersion = "",
      _accessToken = "";

  // Don't change this
  final String _authKeyFile = "";

  // Don't change this
  int _currentChatPatientId = 0;
  final double _scrollThreshold = 200.0;
  final ValueNotifier<int> notificationCount = ValueNotifier<int>(0);
  final ValueNotifier<bool> isDrawerOpen = ValueNotifier<bool>(true),
      isArabic = ValueNotifier<bool>(true);
  bool isVideoCallRunning = false,
      isLocationServiceRunning = false,
      _isPinSet = false,
      _isBiometricEnable = false;

  // Getter
  String get appName => _appName;

  String get timeZone => _timeZone;

  String get userId => _userId;

  String get userName => _userName;

  String get userRole => _userRole;

  String get userMail => _userMail;

  String get physicianId => _physicianId;

  String get partnerId => _partnerId;

  String get sessionId => _sessionId;

  String get deviceId => _deviceId;

  String get accessToken => _accessToken;

  String get authKeyFile => _authKeyFile;

  String get fcmToken => _fcmToken;

  String get apnsToken => _apnsToken;

  /// voipToken will be used to receive voip calls via custom apns server
  String get voipToken => _voipToken;

  String get appVersion => _appVersion;

  int get currentChatPatientId => _currentChatPatientId;

  double get scrollThreshold => _scrollThreshold;

  bool get isBiometricEnable => _isBiometricEnable;

  bool get isPinEnable => _isPinSet;

  double getScreenHeight({double percent = 1}) => _screenSize.height * percent;

  double getScreenWidth({double percent = 1}) => _screenSize.width * percent;

  // Setter
  set setScreenSize(BuildContext context) =>
      _screenSize = MediaQuery.of(context).size;

  set setSessionId(String sessionId) => _sessionId = sessionId;

  set setUserId(String userId) => _userId = userId;

  set setAccessToken(String token) => _accessToken = token;

  set setUserName(String userName) => _userName = userName;

  set setUserMail(String userMail) => _userMail = userMail;

  set setUserRole(String userRole) => _userRole = userRole;

  set setPhysicianId(String physicianId) => _physicianId = physicianId;

  set setPartnerId(String partnerId) => _partnerId = partnerId;

  set setCurrentChatPatientId(int patientId) =>
      _currentChatPatientId = patientId;

  set setBiometricEnable(bool biometric) => _isBiometricEnable = biometric;

  set setPinEnable(bool pinSet) => _isPinSet = pinSet;

  /// Method to set initial Values
  Future<void> setInitialValues() async {
    _timeZone = await FlutterTimezone.getLocalTimezone();
    _sessionId =
        (await getIt<StorageManager>().getData(AppConstants.sessionId) ?? '');
    debugPrint('Current Env is "${AppConfig.instance.currentEnv.name}"');
    await _setDeviceId();
    await _setPackageInfo();
    await _setVOIPToken();
    await _setAPNSToken();
    await _setFCMToken();
  }

  void _clearValues() {
    _sessionId = "";
    _accessToken = "";
    _fcmToken = "";
    _apnsToken = "";
    _voipToken = "";
    _userRole = "";
    _userId = "";
    _userName = "-";
    _userMail = "-";
    _physicianId = "";
    _partnerId = "";
  }

  Future<void> clearAllValues() async {
    _clearValues();
    final storageManager = getIt<StorageManager>();
    final bool isRememberMe =
        await storageManager.getBoolData(AppConstants.isRememberMe);
    final String email =
        await storageManager.getData(AppConstants.emailId) ?? '';
    final String password =
        await storageManager.getData(AppConstants.password) ?? '';
    try {
      //TODO: Uncomment this to use fcm token
      // await FirebaseMessaging.instance.deleteToken();
    } catch (e) {
      debugPrint("Error found in FirebaseMessaging.instance.deleteToken => $e");
    }
    await storageManager.clearData();
    await Future.wait([
      _setFCMToken(),
      _setAPNSToken(),
      _setVOIPToken(),
      if (isRememberMe) storageManager.saveData(AppConstants.emailId, email),
      if (isRememberMe)
        storageManager.saveData(AppConstants.password, password),
      if (isRememberMe)
        storageManager.saveBoolData(AppConstants.isRememberMe, isRememberMe),
    ]);
  }

  /// Set Device Id
  Future<void> _setDeviceId() async {
    if (_deviceId.isNotEmpty) return debugPrint("Device Id already assigned.");
    _deviceId = await getIt<PackageServices>().getDeviceId();
    debugPrint("Device Id is => $_deviceId");
  }

  /// Set FCM Token
  Future<void> _setFCMToken() async {
    if (_fcmToken.isNotEmpty) return debugPrint("FCM Token already assigned.");
    try {
      //TODO: Uncomment this to use fcm token
      // _fcmToken = (await FirebaseMessaging.instance.getToken() ?? '');
      debugPrint("FCM Token is => $_fcmToken");
    } catch (e) {
      debugPrint("Error found in _setFCMToken => $e");
      await _setFCMToken();
    }
  }

  /// Set APNS Token
  Future<void> _setAPNSToken() async {
    if (_apnsToken.isNotEmpty) {
      return debugPrint("APNS Token already assigned.");
    }
    try {
      //TODO: Uncomment this to use fcm token
      // _apnsToken = (await FirebaseMessaging.instance.getAPNSToken() ?? "");
      debugPrint("APNS Token is => $_apnsToken");
    } catch (e) {
      debugPrint("Error found in _setAPNSToken => $e");
      await Future.delayed(
          const Duration(seconds: 2), () async => await _setAPNSToken());
    }
  }

  ///  Set VOIP Token
  Future<void> _setVOIPToken() async {
    if (_voipToken.isNotEmpty) {
      return debugPrint("VOIP Token already assigned.");
    }
    try {
      // _voipToken = await FlutterCallkitIncoming.getDevicePushTokenVoIP();
      debugPrint("VOIP Token is => $_voipToken");
    } catch (e) {
      debugPrint("Error found in _setVOIPToken => $e");
      await _setVOIPToken();
    }
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
