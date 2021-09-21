import 'package:copy_trading/api/core/api_exporter.dart';
import 'package:copy_trading/locator/locator.dart';
import 'package:copy_trading/models/payment_gateways_response.dart';
import 'package:copy_trading/providers/core/default_change_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../wallet_view_model.dart';

enum PaymentSheetStep { gateways, form, otp, pin }

final walletSheetProvider = ChangeNotifierProvider.family
    .autoDispose<WalletSheetViewModel, TransactionType>((ref, type) => WalletSheetViewModel(type));

class WalletSheetViewModel extends DefaultChangeNotifier {
  static const steps = [
    PaymentSheetStep.gateways,
    PaymentSheetStep.form,
    PaymentSheetStep.otp,
    PaymentSheetStep.pin,
  ];

  final ApiExporter api = locator<ApiExporter>();
  final TransactionType type;
  String selectedMethod;
  PaymentSheetStep currentStep = PaymentSheetStep.gateways;

  PaymentGatewaysResponse gatewaysResponse;

  WalletSheetViewModel(this.type) {
    fetchPaymentGateways();
  }

  Future fetchPaymentGateways() async {
    try {
      toggleLoadingOn(true);
      gatewaysResponse = await api.fetchGateways(type);
    } catch (e, stack) {
      debugPrint(e.toString());
      debugPrint(stack.toString());
      errorMessage = e.toString();
    } finally {
      toggleLoadingOn(false);
    }
  }

  void selectPaymentMethod(String selection) {
    selectedMethod = selection;
    currentStep = PaymentSheetStep.form;
    notifyListeners();
  }

  void changeStep(PaymentSheetStep step) {
    currentStep = step;
    notifyListeners();
  }

  void handleBackButton(BuildContext context) {
    if (currentStep == PaymentSheetStep.gateways) {
      Navigator.pop(context);
    } else {
      goBackStep();
    }
  }

  void goBackStep() {
    final currentStepIndex = steps.indexOf(currentStep);
    if (currentStepIndex > 0) {
      currentStep = steps[currentStepIndex - 1];
      notifyListeners();
    }
  }

  String titleForCurrentStep() {
    switch (currentStep) {
      case PaymentSheetStep.gateways:
        return 'Payment Gateways';
        break;
      case PaymentSheetStep.form:
        return selectedMethod ?? 'Complete data';
        break;
      case PaymentSheetStep.otp:
        return '';
        break;
      case PaymentSheetStep.pin:
        return '';
        break;
      default:
        return '';
        break;
    }
  }
}
