import 'package:copy_trading/api/core/api_exporter.dart';
import 'package:copy_trading/global/preferences.dart';
import 'package:copy_trading/locator/locator.dart';
import 'package:copy_trading/models/login_response.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tokenProvider = ChangeNotifierProvider((ref) => TokenViewModel());

class TokenViewModel extends ChangeNotifier {
  final Preferences prefs = locator<Preferences>();
  final ApiExporter api = locator<ApiExporter>();

  String accessToken;
  bool get authenticated => accessToken != null;

  Future initialize() async {
    if (prefs.refreshToken != null) {
      final LoginResponse response = await api.refreshLogin(prefs.refreshToken);
      if (!response.success) {
        await prefs.setRefreshToken(null);
      } else {
        await prefs.setRefreshToken(response.data.loginPassKey.refreshToken);
        await prefs.setAccessToken(response.data.loginPassKey.accessToken);
        accessToken = response.data.loginPassKey.accessToken;
        notifyListeners();
      }
    }
  }

  Future setTokens({@required String accessToken, @required String refreshToken}) async {
    await prefs.setRefreshToken(refreshToken);
    await prefs.setAccessToken(accessToken);
    this.accessToken = accessToken;
    notifyListeners();
  }
}
