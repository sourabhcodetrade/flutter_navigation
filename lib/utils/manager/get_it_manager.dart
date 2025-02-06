import 'package:flutter_setup/utils/manager/local_notification_manager.dart';
import 'package:flutter_setup/utils/services/app_state.dart';
import 'package:flutter_setup/utils/services/custom_theme.dart';
import 'package:flutter_setup/utils/services/firebase_services.dart';
import 'package:get_it/get_it.dart';

import '../constants/apis.dart';
import '../constants/app_constants.dart';
import '../constants/color_constants.dart';
import '../services/package_services.dart';
import 'api_controller.dart';
import 'storage_manager.dart';

GetIt getIt = GetIt.instance;

Future<void> initializeGetItDependencies() async {
  // getIt.registerSingleton<FirebaseServices>(FirebaseServices());
  getIt.registerSingleton<LocalNotificationManager>(LocalNotificationManager());
  getIt.registerSingleton<APIController>(APIController());
  getIt.registerSingleton<CustomTheme>(CustomTheme());
  getIt.registerSingleton<AppState>(AppState());
  getIt.registerSingleton<StorageManager>(StorageManager());
  getIt.registerSingleton<PackageServices>(PackageServices());
  getIt.registerSingleton<ColorConstants>(ColorConstants());
  getIt.registerSingleton<AppConstants>(AppConstants());
  getIt.registerSingleton<APIS>(APIS());
}
