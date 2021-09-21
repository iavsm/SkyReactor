import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum OTPType { phone, email }

final resendButtonProvider = ChangeNotifierProvider.autoDispose
    .family<ResendButtonViewModel, OTPType>((ref, type) => ResendButtonViewModel(type));

class ResendButtonViewModel extends ChangeNotifier {
  OTPType type;

  Timer _timer;
  int counter = 120;
  String get counterText {
    final int minutes = (counter / 60).truncate();
    final String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    final int seconds = counter - (minutes * 60);
    final String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }

  bool get enabled => counter == 0;

  ResendButtonViewModel(OTPType type) {
    if (type != this.type) {
      this.type = type;
      resetTimer();
    }
  }

  void resetTimer() {
    counter = 120;
    notifyListeners();
    startTimer();
  }

  void startTimer() {
    _timer?.cancel();
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (counter == 0) {
          timer.cancel();
        } else {
          counter--;
          notifyListeners();
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
