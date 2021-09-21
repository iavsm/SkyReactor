import 'package:copy_trading/api/core/api_core.dart';
import 'package:copy_trading/locator/locator.dart';
import 'package:copy_trading/models/payment_build_form.dart';
import 'package:copy_trading/models/payment_gateways_response.dart';
import 'package:copy_trading/models/payment_response.dart';
import 'package:copy_trading/models/transaction_response.dart';
import 'package:copy_trading/screens/wallet/wallet_view_model.dart';
import 'package:flutter/foundation.dart';

import 'core/api_links.dart';

mixin WalletApi on ApiCore {
  static const fileName = 'WalletApi';
  final ApiLinks apiLinks = locator<ApiLinks>();

  Future<TransactionsResponse> fetchDepositTransactions({int page = 1}) async {
    final Uri uri = Uri.parse('${apiLinks.depositTransactions}?page%5Bnumber%5D=$page');
    final response = await apiClient.post(uri, headers: authHeaders);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      final TransactionsResponse res = TransactionsResponse.fromMap(json);
      return res;
    } else {
      throw json['error'] ?? 'Error in $fileName';
    }
  }

  Future<TransactionsResponse> fetchWithdrawTransactions({int page = 1}) async {
    final Uri uri = Uri.parse('${apiLinks.withdrawalTransactions}?page%5Bnumber%5D=$page');
    final response = await apiClient.post(uri, headers: authHeaders);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      final TransactionsResponse res = TransactionsResponse.fromMap(json);
      return res;
    } else {
      throw json['error'] ?? 'Error in $fileName';
    }
  }

  Future<PaymentGatewaysResponse> fetchGateways(TransactionType type) async {
    final Uri uri = Uri.parse(
        type == TransactionType.deposit ? apiLinks.depositDashboard : apiLinks.withdrawDashboard);
    final response = await apiClient.post(uri, headers: authHeaders);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      final PaymentGatewaysResponse res = PaymentGatewaysResponse.fromMap(json);
      return res;
    } else {
      throw json['error'] ?? 'Error in $fileName';
    }
  }

  Future<PaymentBuildForm> fetchPaymentBuildForm(TransactionType type, String key) async {
    final Uri uri = Uri.parse(
        type == TransactionType.deposit ? apiLinks.depositBuildForm : apiLinks.withdrawalBuildForm);
    final response = await apiClient.post(
      uri,
      body: jsonEncode({'payby': key}),
      headers: authHeaders,
    );
    final json = jsonDecode(response.body);
    if (response.statusCode == 200 && json is List) {
      final PaymentBuildForm res = PaymentBuildForm.fromMap(json.first as Map<String, dynamic>);
      return res;
    } else {
      throw json['error'] ?? 'Error in $fileName';
    }
  }

  Future<PaymentResponse> makeLocalDeposit({@required Map<String, dynamic> input}) async {
    try {
      final parameters = {
        'platform': 'MT4',
        'type': 2,
      };
      parameters.addAll(input);
      debugPrint('Parameters: $parameters');
      final Uri uri = Uri.parse(apiLinks.depositLocalTransfer);
      final response = await apiClient.post(
        uri,
        body: jsonEncode(parameters),
        headers: authHeaders,
      );
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      debugPrint(json.toString());
      final PaymentResponse res = PaymentResponse.fromMap(json);
      return res;
    } catch (e, stack) {
      debugPrint(e.toString());
      debugPrint(stack.toString());
      rethrow;
    }
  }

  Future<PaymentResponse> makeUrlDeposit({@required Map<String, dynamic> input}) async {
    try {
      final parameters = {
        'platform': 'EWA',
        'type': 2,
      };
      parameters.addAll(input);
      debugPrint('Parameters: $parameters');
      final Uri uri = Uri.parse(apiLinks.depositWallet);
      final response = await apiClient.post(
        uri,
        body: jsonEncode(parameters),
        headers: authHeaders,
      );
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      debugPrint(json.toString());
      final PaymentResponse res = PaymentResponse.fromMap(json);
      return res;
    } catch (e, stack) {
      debugPrint(e.toString());
      debugPrint(stack.toString());
      rethrow;
    }
  }

  Future<PaymentResponse> makeWithdrawalTransaction({@required Map<String, dynamic> input}) async {
    try {
      final parameters = {
        'platform': 'EWA',
        'type': 2,
      };
      parameters.addAll(input);
      debugPrint('Parameters: $parameters');
      final Uri uri = Uri.parse(apiLinks.withdrawWallet);
      print(apiLinks.withdrawWallet);
      final response = await apiClient.post(
        uri,
        body: jsonEncode(parameters),
        headers: authHeaders,
      );
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      debugPrint(json.toString());
      final PaymentResponse res = PaymentResponse.fromMap(json);
      return res;
    } catch (e, stack) {
      debugPrint(e.toString());
      debugPrint(stack.toString());
      rethrow;
    }
  }
}
