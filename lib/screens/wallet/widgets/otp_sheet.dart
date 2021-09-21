import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:copy_trading/models/payment_response.dart';
import 'package:copy_trading/router/route_names.dart';
import 'package:copy_trading/screens/register/resend_button_view_model.dart';
import 'package:copy_trading/screens/wallet/wallet_view_model.dart';
import 'package:copy_trading/screens/wallet/widgets/form_sheet_view_model.dart';
import 'package:copy_trading/screens/wallet/widgets/wallet_sheet_view_model.dart';
import 'package:copy_trading/shared_widgets/call_to_action_button.dart';
import 'package:copy_trading/shared_widgets/result_sheet.dart';
import 'package:copy_trading/util/constants.dart';
import 'package:copy_trading/util/sizer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

class OtpSheet extends StatefulWidget {
  final TransactionType type;

  const OtpSheet({
    @required this.type,
  });

  @override
  _OtpSheetState createState() => _OtpSheetState();
}

class _OtpSheetState extends State<OtpSheet> {
  void _showResultSheet(PaymentResponse response) {
    if (response != null) {
      showResultSheet(
          context: context,
          success: response.success,
          title: response.successHead ?? response.errorHead ?? response.errorMessage,
          details: (response.successSubhead == null && response.errorSubhead == null)
              ? null
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    response.successSubhead ?? response.errorSubhead,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
          onConfirm: () {
            context.read(walletProvider)
              ..changeType(widget.type)
              ..fetchList(refresh: true);
            if (response.success) {
              Navigator.pop(context);
            }
          });
      if (response.fullUrl != null) {
        Navigator.pushNamed(context, Routes.paymentWebview, arguments: response.fullUrl);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (cxt, watch, _) {
        final textTheme = Theme.of(context).textTheme;
        final resendViewModel = watch(resendButtonProvider(OTPType.phone));
        final mainSheetViewModel = watch(walletSheetProvider(widget.type));
        final sheetViewModel = watch(formSheetProvider(widget.type));
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: AutoSizeText(
                "Enter the One-time password to continue",
                textAlign: TextAlign.center,
                style: textTheme.subtitle2.copyWith(height: 1.6, color: kColorGrey, fontSize: 13),
              ),
            ),
            const Sizer(),
            PinCodeTextField(
              autofocus: true,
              controller: sheetViewModel.otpController,
              highlight: true,
              highlightColor: kColorPrimary,
              defaultBorderColor: kColorGrey,
              maxLength: 6,
              hasTextBorderColor: kColorAccent,
              onDone: (String mobileToken) async {
                debugPrint('mobileToken => $mobileToken');
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
            Text('Did not receive the code? Click here to',
                style: textTheme.subtitle2.copyWith(color: kColorGrey, fontSize: 12)),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: 'resend',
                  style: const TextStyle(color: kColorAccent, decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      if (resendViewModel.counter == 0) {
                        await sheetViewModel.sendOtp();
                        resendViewModel.resetTimer();
                      }
                    }),
              TextSpan(
                  text: ' a new code',
                  style: textTheme.subtitle2.copyWith(color: kColorGrey, fontSize: 12)),
            ])),
            const Sizer(),
            Text(
              resendViewModel.counterText,
              style: textTheme.headline6
                  .copyWith(fontSize: 22, color: kColorGrey, fontWeight: FontWeight.normal),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 30, right: 30, bottom: 30),
              child: CallToActionButton(
                onPressed: () async {
                  if (sheetViewModel.showPinSheet == true) {
                    mainSheetViewModel.changeStep(PaymentSheetStep.pin);
                  } else {
                    final response = await sheetViewModel.submitWithdraw(withOtp: true);
                    if (response.success) {
                      Navigator.pop(context);
                    }
                    _showResultSheet(response);
                  }
                },
                loading: sheetViewModel.loading,
                title: 'Confirm',
              ),
            ),
          ],
        );
      },
    );
  }
}
