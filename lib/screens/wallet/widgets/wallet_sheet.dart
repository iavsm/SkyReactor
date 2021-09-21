import 'package:auto_size_text/auto_size_text.dart';
import 'package:copy_trading/screens/wallet/wallet_view_model.dart';
import 'package:copy_trading/screens/wallet/widgets/form_sheet.dart';
import 'package:copy_trading/screens/wallet/widgets/form_sheet_view_model.dart';
import 'package:copy_trading/screens/wallet/widgets/otp_sheet.dart';
import 'package:copy_trading/screens/wallet/widgets/payment_gateways_sheet.dart';
import 'package:copy_trading/screens/wallet/widgets/wallet_sheet_view_model.dart';
import 'package:copy_trading/util/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pin_sheet.dart';

class WalletSheet extends ConsumerWidget {
  final TransactionType type;

  const WalletSheet({
    Key key,
    @required this.type,
  }) : super(key: key);

  Widget _bodyForStep(PaymentSheetStep step) {
    switch (step) {
      case PaymentSheetStep.gateways:
        return PaymentGatewaysSheet(type);
        break;
      case PaymentSheetStep.form:
        return FormSheet(type: type);
        break;
      case PaymentSheetStep.otp:
        return OtpSheet(type: type);
        break;
      case PaymentSheetStep.pin:
        return PinSheet(type: type);
        break;
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final sheetViewModel = watch(walletSheetProvider(type));
    final bool firstStep = sheetViewModel.currentStep == PaymentSheetStep.gateways;
    return Container(
      margin: const EdgeInsets.only(top: 60),
      decoration: const ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)),
          ),
          color: Colors.white,
          shadows: [
            BoxShadow(
              spreadRadius: 3,
              blurRadius: 3,
              color: Colors.black12,
            ),
          ]),
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const Sizer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: GestureDetector(
                        onTap: () => sheetViewModel.handleBackButton(context),
                        child: Row(
                          children: [
                            if (!firstStep) ...[
                              const Icon(Icons.arrow_back_ios, size: 15),
                            ],
                            Flexible(
                                child: AutoSizeText(
                              firstStep ? 'Close' : 'Back',
                              maxLines: 1,
                            )),
                          ],
                        ),
                      ),
                    ),
                    if (sheetViewModel.titleForCurrentStep().isNotEmpty) ...[
                      Expanded(
                          flex: 5,
                          child: Align(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                sheetViewModel.titleForCurrentStep(),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 14),
                              ),
                            ),
                          )),
                    ],
                    if (sheetViewModel.currentStep == PaymentSheetStep.otp) ...[
                      GestureDetector(
                          onTap: () => context.read(formSheetProvider(type)).otpController.clear(),
                          child: const Text('Clear')),
                    ] else ...[
                      const Spacer(),
                    ],
                  ],
                ),
              ),
              const Sizer(),
              _bodyForStep(sheetViewModel.currentStep),
            ],
          ),
        ),
      ),
    );
  }
}
