import 'package:flutter/foundation.dart';

class StatsResponse {
  StatsResponse({
    @required this.details,
  });

  final DataList details;

  factory StatsResponse.fromMap(Map<String, dynamic> json) => StatsResponse(
        details: DataList.fromMap(json["details"]['strategy'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        "details": {'strategy': details.toMap()},
      };
}

class DataList {
  DataList({
    @required this.data,
  });

  final List<StatsDetails> data;

  factory DataList.fromMap(Map<String, dynamic> json) {
    final data = json['data'] as List;
    return DataList(
      data: (data?.isNotEmpty ?? false)
          ? List<StatsDetails>.from(
              data.map((x) => StatsDetails.fromMap(x as Map<String, dynamic>)))
          : [],
    );
  }

  Map<String, dynamic> toMap() => {
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class StatsDetails {
  StatsDetails({
    @required this.gain,
    @required this.dailyGain,
    @required this.monthlyGain,
    @required this.drawdown,
    @required this.accountAge,
    @required this.balance,
    @required this.equity,
    @required this.profitLoss,
    @required this.deposit,
    @required this.withdrawal,
    @required this.trades,
    @required this.profitFactor,
    @required this.pips,
    @required this.lots,
    @required this.averageWin,
    @required this.averageLoss,
    @required this.shortLongPosition,
    @required this.shortLongWon,
    @required this.averageTradeLength,
  });

  final String gain;
  final String dailyGain;
  final String monthlyGain;
  final String drawdown;
  final String accountAge;
  final String balance;
  final String equity;
  final String profitLoss;
  final String deposit;
  final String withdrawal;
  final String trades;
  final String profitFactor;
  final String pips;
  final String lots;
  final String averageWin;
  final String averageLoss;
  final String shortLongPosition;
  final String shortLongWon;
  final String averageTradeLength;

  factory StatsDetails.fromMap(Map<String, dynamic> json) => StatsDetails(
        gain: json["gain"]?.toString() ?? '0',
        dailyGain: json["dailygain"]?.toString() ?? '0',
        monthlyGain: json["monthlygain"]?.toString() ?? '0',
        drawdown: json["drawdown"]?.toString() ?? '0',
        accountAge: json["accountage"]?.toString() ?? '0',
        balance: json["balance"]?.toString() ?? '0',
        equity: json["equity"]?.toString() ?? '0',
        profitLoss: json["profitloss"]?.toString() ?? '0',
        deposit: json["deposit"]?.toString() ?? '0',
        withdrawal: json["withdrawal"]?.toString() ?? '0',
        trades: json["trades"]?.toString() ?? '0',
        profitFactor: json["profitfactor"]?.toString() ?? '0',
        pips: json["pips"]?.toString() ?? '0',
        lots: json["lots"]?.toString() ?? '0',
        averageWin: json["averagewin"]?.toString() ?? '0',
        averageLoss: json["averageloss"]?.toString() ?? '0',
        shortLongPosition: json["shortlongposition"]?.toString() ?? '0',
        shortLongWon: json["shortlongwon"]?.toString() ?? '0',
        averageTradeLength: json["averagetradelength"]?.toString() ?? '0',
      );

  Map<String, dynamic> toMap() => {
        "gain": gain,
        "dailygain": dailyGain,
        "monthlygain": monthlyGain,
        "drawdown": drawdown,
        "accountage": accountAge,
        "balance": balance,
        "equity": equity,
        "profitloss": profitLoss,
        "deposit": deposit,
        "withdrawal": withdrawal,
        "trades": trades,
        "profitfactor": profitFactor,
        "pips": pips,
        "lots": lots,
        "averagewin": averageWin,
        "averageloss": averageLoss,
        "shortlongposition": shortLongPosition,
        "shortlongwon": shortLongWon,
        "averagetradelength": averageTradeLength,
      };
}
