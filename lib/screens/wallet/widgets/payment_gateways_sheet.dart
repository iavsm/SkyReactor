import 'package:copy_trading/screens/wallet/wallet_view_model.dart';
import 'package:copy_trading/screens/wallet/widgets/wallet_sheet_view_model.dart';
import 'package:copy_trading/shared_widgets/default_loader.dart';
import 'package:copy_trading/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentGatewaysSheet extends ConsumerWidget {
  final TransactionType type;

  const PaymentGatewaysSheet(this.type);
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final sheetViewModel = watch(walletSheetProvider(type));
    return Column(
      children: [
        if ((sheetViewModel.gatewaysResponse?.gatewaysAvailable?.isEmpty ?? true) ||
            sheetViewModel.loading) ...[
          DefaultLoader()
        ] else ...[
          ...sheetViewModel.gatewaysResponse.gatewaysAvailable
              .map((e) => Column(
                    children: [
                      ListTile(
                        title: Text(
                          e.paymentgateway,
                          style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 13),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_sharp,
                          color: kColorPrimary,
                          size: 18,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                        onTap: () => sheetViewModel.selectPaymentMethod(e.paymentgateway),
                      ),
                      const Divider(indent: 20, endIndent: 20),
                    ],
                  ))
              .toList(),
        ],
      ],
    );
  }
}
