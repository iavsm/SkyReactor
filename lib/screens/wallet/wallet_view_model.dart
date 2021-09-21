import 'package:copy_trading/api/core/api_exporter.dart';
import 'package:copy_trading/locator/locator.dart';
import 'package:copy_trading/models/transaction_response.dart';
import 'package:copy_trading/providers/core/default_change_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TransactionType { deposit, withdrawal }

final walletProvider = ChangeNotifierProvider.autoDispose((ref) => WalletViewModel());

class WalletViewModel extends DefaultChangeNotifier {
  final ApiExporter api = locator<ApiExporter>();
  TransactionType transactionType = TransactionType.deposit;

  WalletViewModel() {
    fetchList(refresh: true);
  }

  bool loadingMore = false;

  String balance = '-';
  String get firstBalancePart => '${balance.split('.').first}.';
  String get secondBalancePart {
    final parts = balance.split('.');
    String result;
    if (parts.length > 1) {
      result = '${parts[1]} USD';
    }
    return result;
  }

  List<Transaction> get targetTransactions =>
      transactionType == TransactionType.deposit ? depositTransactions : withdrawalTransactions;
  final List<Transaction> depositTransactions = [];
  final List<Transaction> withdrawalTransactions = [];

  TransactionsResponse latestDepositResponse;
  TransactionsResponse latestWithdrawalResponse;

  Future fetchList({bool refresh = false}) async {
    try {
      if (refresh) {
        toggleLoadingOn(true);
      } else {
        toggleLoadingMore(on: true);
      }
      TransactionsResponse response;
      switch (transactionType) {
        case TransactionType.deposit:
          int page = latestDepositResponse?.details?.currentPage ?? 0;
          if (page == latestDepositResponse?.details?.lastPage) {
            return;
          }
          page = refresh ? 1 : page + 1;
          response = await api.fetchDepositTransactions(page: page);
          latestDepositResponse = response;
          if (refresh) {
            depositTransactions.clear();
          }
          depositTransactions.addAll(response.details.transactions);
          break;
        case TransactionType.withdrawal:
          int page = latestWithdrawalResponse?.details?.currentPage ?? 0;
          if (page == latestWithdrawalResponse?.details?.lastPage) {
            return;
          }
          page = refresh ? 1 : page + 1;
          response = await api.fetchWithdrawTransactions(page: page);
          latestWithdrawalResponse = response;
          if (refresh) {
            withdrawalTransactions.clear();
          }
          withdrawalTransactions.addAll(response.details.transactions);
          break;
      }
      balance = response?.balance ?? '-';
    } catch (e, stack) {
      debugPrint(e.toString());
      debugPrint(stack.toString());
      errorMessage = e.toString();
    } finally {
      loadingMore = false;
      toggleLoadingOn(false);
    }
  }

  void changeType(TransactionType type) {
    transactionType = type;
    _checkForTransactions();
    notifyListeners();
  }

  void _checkForTransactions() {
    switch (transactionType) {
      case TransactionType.deposit:
        if (latestDepositResponse == null && !loading) {
          fetchList(refresh: true);
        }
        break;
      case TransactionType.withdrawal:
        if (latestWithdrawalResponse == null) {
          fetchList(refresh: true);
        }
        break;
    }
  }

  void toggleLoadingMore({bool on}) {
    loadingMore = on;
    notifyListeners();
  }
}
