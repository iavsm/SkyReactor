import 'package:copy_trading/providers/core/default_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final resetPasswordProvider = ChangeNotifierProvider.autoDispose((ref) => ResetPasswordViewModel());

class ResetPasswordViewModel extends DefaultChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  final FocusNode emailNode = FocusNode();
  final FocusNode passNode = FocusNode();
  final FocusNode confirmPassNode = FocusNode();

  String emailError, passError, confirmPassError;

  Future submit() async {}
}
