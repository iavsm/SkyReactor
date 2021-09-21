import 'package:copy_trading/api/core/api_exporter.dart';
import 'package:copy_trading/locator/locator.dart';
import 'package:copy_trading/models/payment_build_form.dart';
import 'package:copy_trading/models/payment_response.dart';
import 'package:copy_trading/providers/core/default_change_notifier.dart';
import 'package:copy_trading/screens/wallet/wallet_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final formSheetProvider = ChangeNotifierProvider.family
    .autoDispose<FormSheetViewModel, TransactionType>(
        (ref, type) => FormSheetViewModel(ref.read, type));

class FormSheetViewModel extends DefaultChangeNotifier {
  final ApiExporter api = locator<ApiExporter>();
  final Reader read;
  final TransactionType type;

  final TextEditingController otpController = TextEditingController();
  final TextEditingController pinController = TextEditingController();

  PaymentBuildForm buildForm;
  bool showAmountError = false;
  bool showPinSheet = false;

  final Map<String, dynamic> inputMap = {};
  @override
  // ignore: overridden_fields
  bool loading = true;

  FormSheetViewModel(this.read, this.type);

  Future fetchBuildForm(String key) async {
    if (buildForm == null && errorMessage == null) {
      try {
        inputMap.putIfAbsent('payby', () => key);
        buildForm = await api.fetchPaymentBuildForm(type, key);
      } catch (e, stack) {
        debugPrint(e.toString());
        debugPrint(stack.toString());
        errorMessage = e.toString();
      } finally {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          toggleLoadingOn(false);
        });
      }
    }
  }

  Future refreshForm(TransactionType type, String key) async {
    errorMessage = null;
    return fetchBuildForm(key);
  }

  void setInputValue(String key, String value) {
    inputMap.update(key, (_) => value, ifAbsent: () => value);
  }

  Future<PaymentResponse> submitDeposit() async {
    if (validate()) {
      try {
        toggleLoadingOn(true);
        final PaymentResponse paymentResponse = buildForm.form.mode == 'local'
            ? await api.makeLocalDeposit(input: inputMap)
            : await api.makeUrlDeposit(input: inputMap);
        return paymentResponse;
      } catch (e) {
        errorMessage = e.toString();
        return null;
      } finally {
        toggleLoadingOn(false);
      }
    }
    return null;
  }

  Future<PaymentResponse> submitWithdraw({bool withOtp = false}) async {
    if (validate()) {
      if (withOtp) {
        inputMap.update('otps', (value) => otpController.text, ifAbsent: () => otpController.text);
        if (showPinSheet) {
          inputMap.update('pin', (value) => pinController.text, ifAbsent: () => pinController.text);
        }
      } else {
        inputMap.remove('otps');
        inputMap.remove('pin');
      }
      try {
        toggleLoadingOn(true);
        final PaymentResponse paymentResponse =
            await api.makeWithdrawalTransaction(input: inputMap);
        if (paymentResponse.showPin == true) {
          showPinSheet = true;
        } else {
          showPinSheet = false;
        }
        return paymentResponse;
      } catch (e) {
        errorMessage = e.toString();
        showPinSheet = false;
        return null;
      } finally {
        toggleLoadingOn(false);
      }
    }
    return null;
  }

  Future<PaymentResponse> sendOtp() async {
    if (validate()) {
      final response = await submitWithdraw();
      return response;
    }
    return null;
  }

  bool validate() {
    if (buildForm?.form?.fields?.isNotEmpty ?? false) {
      buildForm.form.fields.forEach((field) {
        if (field.validations.isNotEmpty) {
          if (field.validations.first.validator == 'required' &&
              (inputMap[field.name] == null || inputMap[field.name] == '')) {
            field.showError = true;
          } else if (inputMap[field.name] != null &&
              field.validations.first.validator != 'required' &&
              !RegExp(field.validations.first.validator).hasMatch(inputMap[field.name] as String)) {
            field.showError = true;
          } else {
            field.showError = false;
          }
        }
      });
      showAmountError = inputMap['amount'] == null || inputMap['amount'] == '';

      notifyListeners();
      if (buildForm.form.fields.firstWhere((element) => element.showError, orElse: () => null) !=
              null ||
          showAmountError) {
        return false;
      }
    }
    return true;
  }
}
