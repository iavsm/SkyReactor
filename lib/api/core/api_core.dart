import 'package:copy_trading/global/device_info.dart';
import 'package:copy_trading/global/preferences.dart';
import 'package:copy_trading/locator/locator.dart';
import 'package:http/http.dart' show Client;
export 'dart:convert';

class ApiCore {
  final apiClient = Client();
  final prefs = locator<Preferences>();
  final deviceInfo = locator<DeviceInfo>();
  String get token => prefs.accessToken;

  Map<String, String> get authHeaders {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Device-Id': deviceInfo.deviceId,
      'Authorization': 'Bearer $token',
      'Phone-Type': deviceInfo.phoneType,
      'App-Version': deviceInfo.appVersion,
      'System-Version': deviceInfo.osVersion,
      'resolution': deviceInfo.resolution,
      'Platform': deviceInfo.platform,
      'Manufacturer': deviceInfo.manufacturer,
      'Ip-Address': deviceInfo.ip,
    };
  }

  Map<String, String> get defaultHeaders {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Device-Id': deviceInfo.deviceId,
      'Phone-Type': deviceInfo.phoneType,
      'App-Version': deviceInfo.appVersion,
      'System-Version': deviceInfo.osVersion,
      'resolution': deviceInfo.resolution,
      'Platform': deviceInfo.platform,
      'Manufacturer': deviceInfo.manufacturer,
      'Ip-Address': deviceInfo.ip,
    };
  }

  Map<String, String> get formHeaders {
    return {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'Device-Id': deviceInfo.deviceId,
      'Phone-Type': deviceInfo.phoneType,
      'App-Version': deviceInfo.appVersion,
      'System-Version': deviceInfo.osVersion,
      'resolution': deviceInfo.resolution,
      'Platform': deviceInfo.platform,
      'Manufacturer': deviceInfo.manufacturer,
      'Ip-Address': deviceInfo.ip,
    };
  }

  void dispose() {
    apiClient.close();
  }
}
