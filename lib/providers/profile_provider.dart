import 'package:copy_trading/api/core/api_exporter.dart';
import 'package:copy_trading/locator/locator.dart';
import 'package:copy_trading/models/user_profile.dart';
import 'package:copy_trading/providers/token_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileProvider = ChangeNotifierProvider<ProfileProvider>((ref) {
  final tokenViewModel = ref.watch(tokenProvider);
  final profile = ProfileProvider(authenticated: tokenViewModel.authenticated);
  return profile;
});

class ProfileProvider extends ChangeNotifier {
  ProfileProvider({this.authenticated}) {
    fetchProfile();
  }
  UserProfile profile;
  final bool authenticated;
  final ApiExporter api = locator<ApiExporter>();

  Future fetchProfile() async {
    if (authenticated) {
      try {
        profile = await api.fetchUserInfo();
      } catch (e) {
        profile = null;
      }
    } else {
      profile = null;
    }
    notifyListeners();
  }
}
