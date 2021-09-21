import 'package:copy_trading/api/core/api_exporter.dart';
import 'package:copy_trading/global/lock_manager.dart';
import 'package:copy_trading/locator/locator.dart';
import 'package:copy_trading/models/login_response.dart';
import 'package:copy_trading/providers/core/default_change_notifier.dart';
import 'package:copy_trading/providers/token_provider.dart';
import 'package:copy_trading/router/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginProvider = ChangeNotifierProvider.autoDispose((ref) => LoginViewModel(ref.read));

class LoginViewModel extends DefaultChangeNotifier {
  final LockManager lockManager = locator<LockManager>();
  final ApiExporter api = locator<ApiExporter>();
  final Reader read;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FocusNode emailNode = FocusNode();
  final FocusNode passwordNode = FocusNode();

  String emailError, passwordError;

  bool passwordShowing = false;

  LoginViewModel(this.read);

  Future login(BuildContext context) async {
    try {
      toggleLoadingOn(true);
      final LoginResponse response = await api.login(emailController.text, passwordController.text);
      if (!response.success) {
        errorMessage = response.errorMessage;
        return;
      } else {
        await read(tokenProvider).setTokens(
            accessToken: response.data.loginPassKey.accessToken,
            refreshToken: response.data.loginPassKey.refreshToken);
        await lockManager.lockApp(
            context: context,
            onUnlocked: () {
              Navigator.popAndPushNamed(context, Routes.tabController);
            });

        return 'success';
      }
    } catch (e) {
      if (e is String) {
        errorMessage = e;
      }
    } finally {
      toggleLoadingOn(false);
    }
  }

  void toggleShowPassword() {
    passwordShowing = !passwordShowing;
    notifyListeners();
  }
}
