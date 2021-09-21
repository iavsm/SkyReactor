import 'package:copy_trading/screens/reset_password/reset_password_view_model.dart';
import 'package:copy_trading/shared_widgets/call_to_action_button.dart';
import 'package:copy_trading/shared_widgets/custom_text_field.dart';
import 'package:copy_trading/shared_widgets/light_app_bar.dart';
import 'package:copy_trading/util/constants.dart';
import 'package:copy_trading/util/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResetPasswordScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final resetViewModel = watch(resetPasswordProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const LightAppBar(
        title: 'Reset Password',
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    children: [
                      Sizer.vertical32(),
                      Text(
                        'Enter your registered\nEmail ID',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline4.copyWith(height: 1.6),
                      ),
                      Sizer.vertical32(),
                      CustomTextFormField(
                        label: 'Email',
                        controller: resetViewModel.emailController,
                        node: resetViewModel.emailNode,
                        error: resetViewModel.emailError,
                        autoFocus: true,
                        onFieldSubmitted: (_) {
                          resetViewModel.passNode.requestFocus();
                        },
                      ),
                      const Sizer(),
                      CustomTextFormField(
                        label: 'New Password',
                        controller: resetViewModel.passController,
                        node: resetViewModel.passNode,
                        error: resetViewModel.passError,
                        onFieldSubmitted: (_) {
                          resetViewModel.confirmPassNode.requestFocus();
                        },
                      ),
                      const Sizer(),
                      CustomTextFormField(
                        label: 'Confirm New Password',
                        controller: resetViewModel.confirmPassController,
                        node: resetViewModel.confirmPassNode,
                        error: resetViewModel.confirmPassError,
                        onFieldSubmitted: (_) {
                          resetViewModel.submit();
                        },
                      ),
                      const Sizer(),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '• Password should contain minimum 8 characters.',
                              textAlign: TextAlign.start,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(fontSize: 10, color: kColorGrey),
                            ),
                            Text(
                              '• Password should be a combination of numbers (0-9) and letters (a-z).',
                              textAlign: TextAlign.start,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(fontSize: 10, color: kColorGrey),
                            ),
                            Text(
                              '• Password should contain both UPPER and lowercase letters.',
                              textAlign: TextAlign.start,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(fontSize: 10, color: kColorGrey),
                            ),
                            Text(
                              '• Password should contain at least one special character.',
                              textAlign: TextAlign.start,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(fontSize: 10, color: kColorGrey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                child: CallToActionButton(
                  onPressed: () => resetViewModel.submit(),
                  loading: resetViewModel.loading,
                  title: 'Confirm',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
