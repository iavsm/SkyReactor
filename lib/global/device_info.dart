import 'dart:io';
import 'dart:ui';

import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';
import 'package:wifi/wifi.dart';

class DeviceInfo {
  String deviceId;
  bool isPhysicalDevice;
  String osVersion;
  String appVersion;
  String platform;
  String manufacturer;
  String resolution;
  String phoneType;
  String ip;
  // Manufacture Details: Apple, Resolution: 375*667, Type of the mobile: iOS, IP Address:

  Future<void> getInfo() async {
    ip = await Wifi.ip;
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;
    final size = window.physicalSize;
    resolution = '${size.width}*${size.height}';
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor;
      isPhysicalDevice = iosInfo.isPhysicalDevice;
      osVersion = iosInfo.systemVersion;
      manufacturer = 'Apple';
      phoneType = iosInfo.model;
      platform = iosInfo.systemName;
    }
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.androidId;
      isPhysicalDevice = androidInfo.isPhysicalDevice;
      osVersion = androidInfo.version.release;
      manufacturer = androidInfo.manufacturer;
      phoneType = androidInfo.type;
      platform = 'Android';
    }
  }
}
