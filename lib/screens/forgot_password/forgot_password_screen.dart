import 'package:auto_size_text/auto_size_text.dart';
import 'package:copy_trading/screens/forgot_password/forgot_password_view_model.dart';
import 'package:copy_trading/shared_widgets/call_to_action_button.dart';
import 'package:copy_trading/shared_widgets/custom_text_field.dart';
import 'package:copy_trading/shared_widgets/error_dialog.dart';
import 'package:copy_trading/shared_widgets/light_app_bar.dart';
import 'package:copy_trading/util/constants.dart';
import 'package:copy_trading/util/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPasswordScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final forgotPassViewModel = watch(forgotPasswordProvider);
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: const LightAppBar(
            title: 'Forgot Password',
          ),
          body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => FocusScope.of(context).unfocus(),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    Sizer.vertical32(),
                    Expanded(
                      child: AutoSizeText(
                        'Enter your registered Email ID',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline4.copyWith(height: 1.6),
                      ),
                    ),
                    const Spacer(),
                    CustomTextFormField(
                      label: 'Email ID',
                      controller: forgotPassViewModel.emailController,
                      node: forgotPassViewModel.emailNode,
                      error: forgotPassViewModel.emailError,
                      autoFocus: true,
                    ),
                    Sizer.qtr(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'An activation link will be sent to your registered Email ID',
                        textAlign: TextAlign.end,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(fontSize: 10, color: kColorGrey),
                      ),
                    ),
                    const Spacer(flex: 3),
                    CallToActionButton(
                      onPressed: () => forgotPassViewModel.submit(context),
                      loading: forgotPassViewModel.loading,
                      title: 'Confirm',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (forgotPassViewModel.errorMessage != null) ...[
          ErrorDialog(
            onDismiss: () {
              forgotPassViewModel.setErrorMessage(null);
            },
            error: forgotPassViewModel.errorMessage,
          ),
        ]
      ],
    );
  }
}
