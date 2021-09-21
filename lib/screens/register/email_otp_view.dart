import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:copy_trading/screens/register/register_view_model.dart';
import 'package:copy_trading/util/constants.dart';
import 'package:copy_trading/util/sizer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

import 'resend_button_view_model.dart';

class EmailOTPView extends StatefulWidget {
  @override
  _EmailOTPViewState createState() => _EmailOTPViewState();
}

class _EmailOTPViewState extends State<EmailOTPView> {
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Consumer(
      builder: (cxt, watch, _) {
        final resendViewModel = watch(resendButtonProvider(OTPType.email));
        final registerViewModel = watch(registerProvider);
        return Column(
          children: [
            Flexible(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: AutoSizeText(
                  "Enter the One-time password sent to your registered Email ID",
                  textAlign: TextAlign.center,
                  style: textTheme.headline4.copyWith(height: 1.6, fontSize: 18),
                ),
              ),
            ),
            const Spacer(flex: 2),
            PinCodeTextField(
              autofocus: true,
              controller: registerViewModel.emailOTPController,
              highlight: true,
              highlightColor: kColorPrimary,
              defaultBorderColor: kColorGrey,
              maxLength: registerViewModel.otpLength,
              hasTextBorderColor: kColorAccent,
              onDone: (String mobileToken) {
                debugPrint('mobileToken => $mobileToken');
                registerViewModel.goNextStep();
              },
              wrapAlignment: WrapAlignment.center,
              pinBoxDecoration: ProvidedPinBoxDecoration.underlinedPinBoxDecoration,
              pinBoxRadius: 8,
              pinBoxWidth: min(40, (MediaQuery.of(context).size.width - 70) / 6),
              pinBoxOuterPadding: const EdgeInsets.symmetric(horizontal: 5),
              pinTextStyle: const TextStyle(
                color: kColorPrimary,
                fontSize: 38.0,
                fontWeight: FontWeight.w500,
              ),
              pinTextAnimatedSwitcherTransition: ProvidedPinBoxTextAnimation.defaultNoTransition,
            ),
            Sizer.vertical24(),
            Text('Did not receive the code? Click here to', style: textTheme.bodyText2),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: 'resend',
                  style: const TextStyle(color: kColorAccent, decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      if (resendViewModel.counter == 0) {
                        await registerViewModel.requestOtp(resend: true);
                        resendViewModel.resetTimer();
                      }
                    }),
              TextSpan(text: ' new code', style: textTheme.bodyText2),
            ])),
            const Spacer(),
            Text(
              resendViewModel.counterText,
              style: textTheme.headline6.copyWith(fontSize: 30, fontWeight: FontWeight.normal),
            ),
            Sizer.vertical24(),
          ],
        );
      },
    );
  }
}
