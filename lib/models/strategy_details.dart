import 'package:copy_trading/util/helpers.dart';
import 'package:meta/meta.dart';
import 'country.dart';

class StrategyDetailsResponse {
  const StrategyDetailsResponse({
    @required this.details,
  });

  final DataList details;

  factory StrategyDetailsResponse.fromMap(Map<String, dynamic> json) => StrategyDetailsResponse(
        details: DataList.fromMap(json["details"]['strategy'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        "details": details.toMap(),
      };
}

class DataList {
  const DataList({
    @required this.data,
  });

  final List<StrategyDetails> data;

  factory DataList.fromMap(Map<String, dynamic> json) {
    final data = json['data'] as List;
    if (data != null && data.isNotEmpty) {
      return DataList(
        data: List<StrategyDetails>.from(
            data.map((x) => StrategyDetails.fromMap(x as Map<String, dynamic>))),
      );
    }
    return const DataList(data: []);
  }

  Map<String, dynamic> toMap() => {
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class StrategyDetails {
  const StrategyDetails({
    @required this.about,
    @required this.strategyImage,
    @required this.nickname,
    @required this.country,
    @required this.details,
  });

  final String about;
  final String strategyImage;
  final String nickname;
  final Country country;
  final Details details;

  factory StrategyDetails.fromMap(Map<String, dynamic> json) => StrategyDetails(
        about: json["about"]?.toString(),
        strategyImage: json["strategyimage"]?.toString(),
        nickname: json["nickname"]?.toString(),
        country: Country.fromMap(json["country"] as Map<String, dynamic>),
        details: Details.fromMap(json["details"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        "about": about,
        "strategyimage": strategyImage,
        "nickname": nickname,
        "country": country.toMap(),
        "details": details.toMap(),
      };
}

class Details {
  const Details({
    @required this.risk,
    @required this.drawdown,
    @required this.totalPips,
    @required this.commission,
    @required this.totalGain,
    @required this.gainPercentage,
    @required this.overview,
  });

  final String risk;
  final String drawdown;
  final String totalPips;
  final String commission;
  final String totalGain;
  final String gainPercentage;
  final OverviewData overview;

  factory Details.fromMap(Map<String, dynamic> json) => Details(
        risk: json['risk']?.toString(),
        drawdown: formatDouble(json['drawdown']),
        totalPips: formatDouble(json['totalpips']),
        commission: formatDouble(json['commission']),
        totalGain: formatDouble(json['totalgain']),
        gainPercentage: formatDouble(json['gainpercentage']),
        overview: json['overview'] != null
            ? OverviewData.fromMap(json["overview"] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toMap() => {
        "risk": risk,
        "drawdown": drawdown,
        "totalpips": totalPips,
        "commission": commission,
        "totalgain": totalGain,
        "gainpercentage": gainPercentage,
        "overview": overview?.toMap(),
      };
}

class OverviewData {
  OverviewData({
    @required this.balance,
    @required this.equity,
    @required this.profitLoss,
    @required this.leverage,
    @required this.deposit,
  });

  final String balance;
  final String equity;
  final String profitLoss;
  final String leverage;
  final Deposit deposit;

  factory OverviewData.fromMap(Map<String, dynamic> json) => OverviewData(
        balance: json["balance"]?.toString(),
        equity: json["equity"]?.toString(),
        profitLoss: json["profitloss"]?.toString(),
        leverage: json["leverage"]?.toString(),
        deposit: Deposit.fromMap(json["deposit"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        "balance": balance,
        "equity": equity,
        "profitloss": profitLoss,
        "leverage": leverage,
        "deposit": deposit.toMap(),
      };
}

class Deposit {
  Deposit({
    @required this.minimum,
    @required this.recommended,
  });

  final String minimum;
  final String recommended;

  factory Deposit.fromMap(Map<String, dynamic> json) => Deposit(
        minimum: json["mininum "]?.toString(),
        recommended: json["recommended"]?.toString(),
      );

  Map<String, dynamic> toMap() => {
        "mininum ": minimum,
        "recommended": recommended,
      };
}
