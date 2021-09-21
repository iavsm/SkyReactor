import 'package:auto_size_text/auto_size_text.dart';
import 'package:copy_trading/models/payment_response.dart';
import 'package:copy_trading/router/route_names.dart';
import 'package:copy_trading/screens/wallet/wallet_view_model.dart';
import 'package:copy_trading/screens/wallet/widgets/form_sheet_view_model.dart';
import 'package:copy_trading/shared_widgets/call_to_action_button.dart';
import 'package:copy_trading/shared_widgets/custom_text_field.dart';
import 'package:copy_trading/shared_widgets/result_sheet.dart';
import 'package:copy_trading/util/constants.dart';
import 'package:copy_trading/util/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PinSheet extends StatefulWidget {
  final TransactionType type;

  const PinSheet({
    @required this.type,
  });

  @override
  _PinSheetState createState() => _PinSheetState();
}

class _PinSheetState extends State<PinSheet> {
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
        final sheetViewModel = watch(formSheetProvider(widget.type));
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: AutoSizeText(
                "Please enter your pin to continue",
                textAlign: TextAlign.center,
                style: textTheme.subtitle2.copyWith(height: 1.6, color: kColorGrey, fontSize: 13),
              ),
            ),
            const Sizer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: CustomTextFormField(
                label: 'Pin',
                hint: 'Pin',
                controller: sheetViewModel.pinController,
                onChange: (value) => sheetViewModel.setInputValue('pin', value),
              ),
            ),
            Sizer.vertical24(),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 30, right: 30, bottom: 30),
              child: CallToActionButton(
                onPressed: () async {
                  final PaymentResponse response =
                      await sheetViewModel.submitWithdraw(withOtp: true);
                  if (response.success) {
                    Navigator.pop(context);
                  }
                  _showResultSheet(response);
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
