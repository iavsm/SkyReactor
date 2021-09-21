import 'package:copy_trading/global/preferences.dart';
import 'package:copy_trading/locator/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'global/device_info.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await locator<DeviceInfo>().getInfo();

  final Preferences prefs = locator<Preferences>();
  await prefs.init();
  runApp(
    ProviderScope(
      child: App(),
    ),
  );
}
