import 'package:auto_size_text/auto_size_text.dart';
import 'package:copy_trading/models/transaction_response.dart';
import 'package:copy_trading/util/constants.dart';
import 'package:copy_trading/util/sizer.dart';
import 'package:flutter/material.dart';

class TransactionCell extends StatelessWidget {
  final Transaction transaction;

  const TransactionCell(this.transaction, {Key key}) : super(key: key);

  Color _colorForStatus() {
    return transaction.status == 'Success' ? Colors.green : Colors.red;
  }

  String _modeOfTransaction() {
    final List<String> parts = transaction.remarks.split(' ');
    final moneyPartIndex = parts.indexWhere((element) => element.substring(0, 1) == '\$');
    if (moneyPartIndex != -1) {
      final partsToUse = parts.getRange(0, moneyPartIndex);
      return partsToUse.join(' ');
    } else {
      return parts.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transaction ID:',
                      style: textTheme.caption
                          .copyWith(color: Colors.grey.shade700, fontWeight: FontWeight.w300),
                    ),
                    Text(
                      transaction.txnid ?? '-',
                      style: textTheme.bodyText2.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AutoSizeText(
                      '\$${transaction.amount}',
                      style: textTheme.headline6.copyWith(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      transaction.status ?? '-',
                      style: textTheme.bodyText2.copyWith(
                        color: _colorForStatus(),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Sizer.half(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mode:',
                    style: textTheme.caption.copyWith(
                      color: kColorGrey,
                      fontWeight: FontWeight.w300,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    _modeOfTransaction(),
                    style: textTheme.bodyText2.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Text(
                transaction.txndate ?? '',
                style: textTheme.caption.copyWith(color: Colors.grey.shade700),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
