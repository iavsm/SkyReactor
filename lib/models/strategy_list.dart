import 'package:copy_trading/models/strategy_details.dart';
import 'package:flutter/foundation.dart';

class StrategyList {
  final ListObject topGainers;
  final ListObject mostPopular;
  final ListObject commission;
  final ListObject drawdown;

  StrategyList(
      {@required this.topGainers,
      @required this.mostPopular,
      @required this.commission,
      @required this.drawdown});

  factory StrategyList.fromMap(Map<String, dynamic> json) {
    return StrategyList(
      topGainers: json['topgainers'] != null
          ? ListObject.fromMap(json['topgainers'] as Map<String, dynamic>)
          : null,
      mostPopular: json['mostpopular'] != null
          ? ListObject.fromMap(json['mostpopular'] as Map<String, dynamic>)
          : null,
      commission: json['commission'] != null
          ? ListObject.fromMap(json['commission'] as Map<String, dynamic>)
          : null,
      drawdown: json['drawdown'] != null
          ? ListObject.fromMap(json['drawdown'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ListObject {
  final String title;
  final List<StrategyDetails> strategies;

  ListObject({@required this.title, @required this.strategies});

  factory ListObject.fromMap(Map<String, dynamic> json) {
    final List<StrategyDetails> list = [];
    final data = json['data'] != null ? json['data'] as List : null;
    if (data?.isNotEmpty ?? false) {
      data.forEach((map) {
        final json = map as Map<String, dynamic>;
        list.add(StrategyDetails.fromMap(json));
      });
    }

    return ListObject(
      title: json['title']?.toString(),
      strategies: list,
    );
  }
}
