import 'package:flutter_setup/utils/services/package_services.dart';
import 'package:get_it/get_it.dart';

import 'api_controller.dart';
import 'storage_manager.dart';

GetIt getIt = GetIt.instance;

Future<void> initializeGetItDependencies() async {
  getIt.registerSingleton<APIController>(APIController());
  getIt.registerSingleton<StorageManager>(StorageManager());
  getIt.registerSingleton<PackageServices>(PackageServices());
}
