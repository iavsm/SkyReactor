import 'package:copy_trading/screens/wallet/wallet_view_model.dart';
import 'package:copy_trading/screens/wallet/widgets/transaction_cell.dart';
import 'package:copy_trading/screens/wallet/widgets/wallet_button.dart';
import 'package:copy_trading/screens/wallet/widgets/wallet_sheet.dart';
import 'package:copy_trading/shared_widgets/default_loader.dart';
import 'package:copy_trading/shared_widgets/profile_button.dart';
import 'package:copy_trading/shared_widgets/section_title_widget.dart';
import 'package:copy_trading/util/constants.dart';
import 'package:copy_trading/util/sizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final ScrollController _scrollController = ScrollController();
  Function reachedBottom = () {};

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      debugPrint('Reached the bottom');
      reachedBottom();
    }
    if (_scrollController.offset <= _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      debugPrint('Reached the top');
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  Widget _typeLabel(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title),
    );
  }

  void _showPaymentSheet(TransactionType type) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (cxt) {
          return WalletSheet(type: type);
        });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Consumer(
      builder: (cxt, watch, _) {
        final walletViewModel = watch(walletProvider);
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(
              MediaQuery.of(context).size.width,
              230,
            ),
            child: Container(
              color: kColorPrimary,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Sizer.vertical24(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Wallet',
                          style: textTheme.headline6.copyWith(color: Colors.white),
                        ),
                        ProfileButton(),
                      ],
                    ),
                    Sizer.vertical24(),
                    Text(
                      'Balance',
                      style: textTheme.caption.copyWith(
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: walletViewModel.firstBalancePart,
                            style: textTheme.headline4.copyWith(
                              color: Colors.white,
                              fontSize: 35,
                              height: 1.4,
                            ),
                          ),
                          if (walletViewModel.secondBalancePart != null) ...[
                            TextSpan(
                              text: walletViewModel.secondBalancePart,
                              style: textTheme.subtitle1.copyWith(
                                  color: Colors.white, fontSize: 24, fontWeight: FontWeight.w300),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const Sizer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        WalletButton(
                            text: 'Deposit',
                            onTap: () => _showPaymentSheet(TransactionType.deposit)),
                        Sizer.halfHorizontal(),
                        WalletButton(
                            text: 'Withdrawal',
                            onTap: () => _showPaymentSheet(TransactionType.withdrawal)),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 15, top: 20, left: 10),
                child: SectionTitleWidget(title: 'Transactions'),
              ),
              Container(
                width: double.infinity,
                height: 45,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: CupertinoSlidingSegmentedControl(
                  children: <TransactionType, Widget>{
                    TransactionType.deposit: _typeLabel('Deposit'),
                    TransactionType.withdrawal: _typeLabel('Withdrawal'),
                  },
                  onValueChanged: (TransactionType type) {
                    walletViewModel.changeType(type);
                  },
                  thumbColor: Colors.white,
                  groupValue: walletViewModel.transactionType,
                ),
              ),
              if (walletViewModel.targetTransactions.isNotEmpty) ...[
                Expanded(
                  child: walletViewModel.loading
                      ? DefaultLoader()
                      : ListView.separated(
                          padding: const EdgeInsets.only(top: 10, left: 28, right: 28, bottom: 50),
                          controller: _scrollController,
                          itemBuilder: (cxt, index) {
                            if (reachedBottom != () => walletViewModel.fetchList()) {
                              reachedBottom = () => walletViewModel.fetchList();
                            }
                            return TransactionCell(walletViewModel.targetTransactions[index]);
                          },
                          separatorBuilder: (cxt, index) => const Divider(
                            color: kColorLightGrey,
                            endIndent: 0,
                            indent: 0,
                          ),
                          itemCount: walletViewModel.targetTransactions.length,
                        ),
                ),
              ] else ...[
                const Expanded(
                  child: Center(
                    child: Text('No Records to Display'),
                  ),
                ),
              ],
              if (walletViewModel.loadingMore) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: CircularProgressIndicator(),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
