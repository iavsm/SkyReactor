import 'package:flutter/foundation.dart';

abstract class DefaultChangeNotifier extends ChangeNotifier {
  bool loading = false;
  String errorMessage;

  // ignore: avoid_positional_boolean_parameters
  void toggleLoadingOn(bool on) {
    loading = on;
    notifyListeners();
  }

  void setErrorMessage(String value) {
    errorMessage = value;
    notifyListeners();
  }
}
