import 'package:auto_size_text/auto_size_text.dart';
import 'package:copy_trading/global/preferences.dart';
import 'package:copy_trading/locator/locator.dart';
import 'package:copy_trading/util/sizer.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'call_to_action_button.dart';

void showResultSheet(
    {@required BuildContext context,
    @required bool success,
    String title,
    Widget details,
    @required Function onConfirm}) {
  final TextTheme textTheme = Theme.of(context).textTheme;
  showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.only(topLeft: Radius.circular(22), topRight: Radius.circular(22)),
      ),
      clipBehavior: Clip.antiAlias,
      isDismissible: false,
      isScrollControlled: true,
      context: context,
      builder: (cxt) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 28),
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: Lottie.asset(
                      'assets/animations/${success ? 'success' : 'failure'}.json',
                      repeat: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AutoSizeText(
                      title ?? (success ? 'Success!' : 'Failure!'),
                      textAlign: TextAlign.center,
                      style: textTheme.headline6.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  if (details != null) ...[
                    Sizer.vertical24(),
                    details,
                  ],
                  Sizer.vertical32(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 75),
                    child: CallToActionButton(
                        title: success ? 'OK' : 'Try again',
                        onPressed: () async {
                          Navigator.pop(context);
                          await onConfirm();
                        }),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}

void showSuccessSheet(
    {@required BuildContext context, @required Widget details, @required Function onConfirm}) {
  showResultSheet(context: context, success: true, onConfirm: onConfirm, details: details);
}

void showBiometricsSheet({@required BuildContext context, Function onPop}) {
  final TextTheme textTheme = Theme.of(context).textTheme;
  showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.only(topLeft: Radius.circular(22), topRight: Radius.circular(22)),
      ),
      clipBehavior: Clip.antiAlias,
      isDismissible: true,
      context: context,
      builder: (cxt) {
        return WillPopScope(
          onWillPop: () async {
            debugPrint('Popping biometrics Sheet');
            onPop();
            return true;
          },
          child: SizedBox(
            height: 390,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 28),
              child: SafeArea(
                child: Column(
                  children: [
                    SizedBox(
                      height: 120,
                      width: 120,
                      child: Image.asset(
                        'assets/images/biometric_icon.png',
                      ),
                    ),
                    Sizer.vertical24(),
                    Text(
                      'Would you like to be able to unlock the app using Face ID or Fingerprints?',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyText2,
                    ),
                    const Sizer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 75),
                      child: CallToActionButton(
                          title: 'OK',
                          onPressed: () async {
                            await locator<Preferences>().toggleBiometrics(value: true);
                            Navigator.pop(context);
                            onPop();
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
}
