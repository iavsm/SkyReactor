import 'package:copy_trading/api/core/api_exporter.dart';
import 'package:copy_trading/api/core/api_links.dart';
import 'package:copy_trading/global/device_info.dart';
import 'package:copy_trading/global/lock_manager.dart';
import 'package:copy_trading/global/preferences.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => Preferences());
  locator.registerLazySingleton(() => ApiLinks());
  locator.registerLazySingleton(() => ApiExporter());
  locator.registerLazySingleton(() => LockManager());
  locator.registerLazySingleton(() => DeviceInfo());
}
