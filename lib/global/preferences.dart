import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static SharedPreferences _prefInstance;

  bool get initialized => _prefInstance != null;

  Future<void> init() async {
    _prefInstance = await SharedPreferences.getInstance();
  }

  String get lockCode => _prefInstance?.getString(_lockKey);
  String get refreshToken => _prefInstance?.getString(_tokenKey);
  String get accessToken => _prefInstance?.getString(_accessTokenKey);
  bool get isLocked => _prefInstance?.getBool(_appLocked) ?? false;
  bool get biometricsEnabled => _prefInstance?.getBool(_biometricsEnabledKey) ?? false;

  Future<void> setRefreshToken(String token) async {
    if (token == null) {
      _prefInstance.remove(_tokenKey);
      return;
    }
    await _prefInstance.setString(_tokenKey, token);
  }

  Future<void> setAccessToken(String token) async {
    if (token == null) {
      _prefInstance.remove(_accessTokenKey);
      return;
    }
    await _prefInstance.setString(_accessTokenKey, token);
  }

  Future<void> setLockCode(String code) async {
    if (code == null) {
      _prefInstance.remove(_lockKey);
      return;
    }
    await _prefInstance.setString(_lockKey, code);
  }

  Future<void> toggleAppLock({bool locked}) async {
    await _prefInstance.setBool(_appLocked, locked);
  }

  Future<void> toggleBiometrics({bool value}) async {
    await _prefInstance.setBool(_biometricsEnabledKey, value);
  }
}

const String _lockKey = 'lockCode';
const String _biometricsEnabledKey = 'biometricsEnabled';
const String _tokenKey = 'tokenCode';
const String _accessTokenKey = 'accessToken';
const String _appLocked = 'appLocked';
