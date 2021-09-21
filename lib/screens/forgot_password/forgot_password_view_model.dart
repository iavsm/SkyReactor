import 'package:copy_trading/api/core/api_exporter.dart';
import 'package:copy_trading/locator/locator.dart';
import 'package:copy_trading/providers/core/default_change_notifier.dart';
import 'package:copy_trading/shared_widgets/result_sheet.dart';
import 'package:copy_trading/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final forgotPasswordProvider =
    ChangeNotifierProvider.autoDispose((ref) => ForgotPasswordViewModel());

class ForgotPasswordViewModel extends DefaultChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final FocusNode emailNode = FocusNode();
  final ApiExporter api = locator<ApiExporter>();

  String emailError;

  Future submit(BuildContext context) async {
    if (validate()) {
      try {
        toggleLoadingOn(true);
        await api.forgotPassword(emailController.text);
        displaySuccessSheet(context);
      } catch (e) {
        if (e is String) {
          errorMessage = e;
        }
      } finally {
        toggleLoadingOn(false);
      }
    }
  }

  bool validate() {
    if (emailController.text.isEmpty) {
      emailError = 'Please enter Email ID';
      notifyListeners();
      return false;
    }
    return true;
  }

  void displaySuccessSheet(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    showSuccessSheet(
        context: context,
        details: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: textTheme.bodyText2,
            children: [
              const TextSpan(text: 'Your activition link has been sent '),
              TextSpan(
                  text: 'successfully', style: textTheme.bodyText2.copyWith(color: kColorAccent)),
              const TextSpan(text: '\nsent to your registered Email ID.'),
            ],
          ),
        ),
        onConfirm: () async {
          Navigator.pop(context);
        });
  }
}
