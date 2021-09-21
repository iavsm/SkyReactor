import 'package:copy_trading/screens/register/country_view.dart';
import 'package:copy_trading/screens/register/email_view.dart';
import 'package:copy_trading/screens/register/name_view.dart';
import 'package:copy_trading/screens/register/email_otp_view.dart';
import 'package:copy_trading/screens/register/phone_otp_view.dart';
import 'package:copy_trading/screens/register/phone_view.dart';
import 'package:copy_trading/screens/register/register_view_model.dart';
import 'package:copy_trading/shared_widgets/call_to_action_button.dart';
import 'package:copy_trading/shared_widgets/error_dialog.dart';
import 'package:copy_trading/util/constants.dart';
import 'package:copy_trading/util/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  Widget _viewForStep(RegisterSteps step) {
    switch (step) {
      case RegisterSteps.email:
        return EmailView();
        break;
      case RegisterSteps.mobile:
        return PhoneView();
        break;
      case RegisterSteps.name:
        return NameView();
        break;
      case RegisterSteps.country:
        return CountryView();
        break;
      case RegisterSteps.emailOtp:
        return EmailOTPView();
        break;
      case RegisterSteps.phoneOtp:
        return PhoneOTPView();
        break;
      default:
        return EmailView();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (cxt, watch, _) {
        final registerViewModel = watch(registerProvider);
        return WillPopScope(
          onWillPop: () async {
            if (registerViewModel.currentStepIndex == 0) {
              return true;
            } else {
              registerViewModel.goPreviousStep();
              return false;
            }
          },
          child: Stack(
            children: [
              Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  brightness: Brightness.light,
                  iconTheme: const IconThemeData(color: kColorPrimary),
                  elevation: 0,
                ),
                body: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 150),
                            child: _viewForStep(
                                RegisterViewModel.steps[registerViewModel.currentStepIndex]),
                          ),
                        ),
                        CallToActionButton(
                          onPressed: () async {
                            final result = await registerViewModel.goNextStep();
                            if (result == true) {
                              registerViewModel.displaySuccessSheet(context);
                            }
                          },
                          loading: registerViewModel.loading,
                          title: [
                            RegisterSteps.phoneOtp,
                            RegisterSteps.emailOtp
                          ].contains(RegisterViewModel.steps[registerViewModel.currentStepIndex])
                              ? 'Confirm'
                              : 'Next',
                        ),
                        const Sizer(),
                      ],
                    ),
                  ),
                ),
              ),
              if (registerViewModel.errorMessage != null) ...[
                ErrorDialog(
                    onDismiss: () => registerViewModel.setErrorMessage(null),
                    error: registerViewModel.errorMessage),
              ]
            ],
          ),
        );
      },
    );
  }
}
