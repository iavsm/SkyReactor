import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Direction { up, down }

final infoPositionProvider = ChangeNotifierProvider((ref) => InfoPositionProvider());

class InfoPositionProvider extends ChangeNotifier {
  TapUpDetails tapUpDetails;
  Direction direction = Direction.down;
  String info;

  bool get shouldShowBubble => info != null && tapUpDetails != null;

  void showBubble(TapUpDetails tapUpDetails, String info, Direction direction) {
    this.info = info;
    this.tapUpDetails = tapUpDetails;
    this.direction = direction;
    notifyListeners();
  }

  void removeBubble() {
    info = null;
    tapUpDetails = null;
    direction = Direction.down;
    notifyListeners();
  }
}
