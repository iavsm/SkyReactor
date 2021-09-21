import 'package:copy_trading/models/payment_response.dart';
import 'package:copy_trading/router/route_names.dart';
import 'package:copy_trading/screens/wallet/wallet_view_model.dart';
import 'package:copy_trading/screens/wallet/widgets/form_sheet_view_model.dart';
import 'package:copy_trading/screens/wallet/widgets/wallet_sheet_view_model.dart';
import 'package:copy_trading/shared_widgets/call_to_action_button.dart';
import 'package:copy_trading/shared_widgets/custom_text_field.dart';
import 'package:copy_trading/shared_widgets/result_sheet.dart';
import 'package:copy_trading/shared_widgets/selection_field.dart';
import 'package:copy_trading/util/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FormSheet extends StatefulWidget {
  final TransactionType type;

  const FormSheet({
    @required this.type,
  });

  @override
  _FormSheetState createState() => _FormSheetState();
}

class _FormSheetState extends State<FormSheet> {
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
        final walletViewModel = watch(walletProvider);
        final mainSheetViewModel = watch(walletSheetProvider(widget.type));
        final sheetViewModel = watch(formSheetProvider(widget.type));
        sheetViewModel.fetchBuildForm(mainSheetViewModel.selectedMethod);
        final bool hasFields = sheetViewModel.buildForm?.form?.fields?.isNotEmpty ?? false;
        return Column(
          children: [
            if (hasFields) ...[
              ...sheetViewModel.buildForm.form.fields
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: e.isTextField
                          ? CustomTextFormField(
                              label: e.label,
                              hint: e.label,
                              error: e.showError ? e.validations.first.message : null,
                              onChange: (value) => sheetViewModel.setInputValue(e.name, value),
                            )
                          : SelectionField(
                              choices: e.options,
                              scrollControlled: false,
                              selectedIndex: (index) =>
                                  sheetViewModel.setInputValue(e.name, e.options[index]),
                              controller: e.controller,
                              title: e.label),
                    ),
                  )
                  .toList(),
            ],
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30, top: hasFields ? 30 : 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomTextFormField(
                    label: 'Amount',
                    hint: 'Amount',
                    error: sheetViewModel.showAmountError ? 'Amount is required' : null,
                    onChange: (value) => sheetViewModel.setInputValue('amount', value),
                  ),
                  if (sheetViewModel.buildForm?.txn != null) ...[
                    Sizer.half(),
                    Text('(${sheetViewModel.buildForm?.txn})'),
                  ],
                ],
              ),
            ),
            Sizer.vertical48(),
            Text(
              'Wallet Balance',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
            ),
            Sizer.half(),
            Text(
              walletViewModel.balance,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .copyWith(fontSize: 25, fontWeight: FontWeight.w700),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 30, right: 30, bottom: 30),
              child: CallToActionButton(
                onPressed: () async {
                  if (widget.type == TransactionType.deposit) {
                    final PaymentResponse response = await sheetViewModel.submitDeposit();
                    if (response != null) {
                      showResultSheet(
                          context: context,
                          success: response.success,
                          title:
                              response.successHead ?? response.errorHead ?? response.errorMessage,
                          details:
                              (response.successSubhead == null && response.errorSubhead == null)
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
                              if (response.fullUrl != null) {
                                Navigator.pushNamed(context, Routes.paymentWebview,
                                    arguments: response.fullUrl);
                              }
                            }
                          });
                    }
                  } else {
                    if (!sheetViewModel.validate()) {
                      return;
                    }
                    final response = await sheetViewModel.sendOtp();
                    if (response != null) {
                      if (response.success) {
                        mainSheetViewModel.changeStep(PaymentSheetStep.otp);
                      } else {
                        _showResultSheet(response);
                      }
                    }
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
