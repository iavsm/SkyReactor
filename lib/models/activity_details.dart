import 'package:meta/meta.dart';

class ActivityResponse {
  ActivityResponse({
    @required this.responseData,
  });

  final ActivityResponseData responseData;

  factory ActivityResponse.fromMap(Map<String, dynamic> json) => ActivityResponse(
        responseData:
            ActivityResponseData.fromMap(json["strategy"]['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        "strategy": {
          'data': responseData.toMap(),
        },
      };
}

class ActivityResponseData {
  ActivityResponseData({
    @required this.currentPage,
    @required this.activities,
    @required this.firstPageUrl,
    @required this.from,
    @required this.lastPage,
    @required this.lastPageUrl,
    @required this.nextPageUrl,
    @required this.path,
    @required this.perPage,
    @required this.prevPageUrl,
    @required this.to,
    @required this.total,
  });

  final String currentPage;
  final List<ActivityDetails> activities;
  final String firstPageUrl;
  final String from;
  final String lastPage;
  final String lastPageUrl;
  final String nextPageUrl;
  final String path;
  final String perPage;
  final String prevPageUrl;
  final String to;
  final String total;

  factory ActivityResponseData.fromMap(Map<String, dynamic> json) {
    final data = json['data'] as List;
    return ActivityResponseData(
      currentPage: json["current_page"]?.toString(),
      activities: (data?.isNotEmpty ?? false)
          ? List<ActivityDetails>.from(
              data.map((x) => ActivityDetails.fromMap(x as Map<String, dynamic>)))
          : [],
      firstPageUrl: json["first_page_url"]?.toString(),
      from: json["from"]?.toString(),
      lastPage: json["last_page"]?.toString(),
      lastPageUrl: json["last_page_url"]?.toString(),
      nextPageUrl: json["next_page_url"]?.toString(),
      path: json["path"]?.toString(),
      perPage: json["per_page"]?.toString(),
      prevPageUrl: json["prev_page_url"]?.toString(),
      to: json["to"]?.toString(),
      total: json["total"]?.toString(),
    );
  }

  Map<String, dynamic> toMap() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(activities.map((x) => x.toMap())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class ActivityDetails {
  ActivityDetails({
    @required this.ticket,
    @required this.login,
    @required this.openPrice,
    @required this.type,
    @required this.size,
    @required this.symbol,
    @required this.commission,
    @required this.swaps,
    @required this.profit,
    @required this.sl,
    @required this.tp,
    @required this.date,
    @required this.comment,
  });

  final String ticket;
  final String login;
  final String openPrice;
  final String type;
  final String size;
  final String symbol;
  final String commission;
  final String swaps;
  final String profit;
  final String sl;
  final String tp;
  final DateTime date;
  final String comment;

  factory ActivityDetails.fromMap(Map<String, dynamic> json) => ActivityDetails(
        ticket: json["ticket"]?.toString(),
        login: json["login"]?.toString(),
        openPrice: json["open_price"]?.toString(),
        type: json["type"]?.toString(),
        size: json["size"]?.toString(),
        symbol: json["item"]?.toString(),
        commission: json["commission"]?.toString(),
        swaps: json["swaps"]?.toString(),
        profit: json["profit"]?.toString(),
        sl: json["SL"]?.toString(),
        tp: json["TP"]?.toString(),
        date: DateTime.tryParse(json["date"]?.toString() ?? ''),
        comment: json["comment"]?.toString(),
      );

  Map<String, dynamic> toMap() => {
        "ticket": ticket,
        "login": login,
        "open_price": openPrice,
        "type": type,
        "size": size,
        "item": symbol,
        "commission": commission,
        "swaps": swaps,
        "profit": profit,
        "SL": sl,
        "TP": tp,
        "date": date.toIso8601String(),
        "comment": comment,
      };

  @override
  bool operator ==(Object other) {
    return other is ActivityDetails && other.ticket == ticket && other.login == login;
  }

  @override
  int get hashCode => super.hashCode;
}
