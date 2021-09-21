import 'package:flutter_riverpod/flutter_riverpod.dart';

enum HomeTabs { favorites, portfolio, wallet, settings }

final tabControllerProvider =
    StateNotifierProvider<TabControllerViewModel>((ref) => TabControllerViewModel());

class TabControllerViewModel extends StateNotifier<HomeTabs> {
  TabControllerViewModel([HomeTabs state]) : super(state ?? HomeTabs.wallet);

  void changeTab(HomeTabs newTab) {
    state = newTab;
  }
}
