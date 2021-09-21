import 'package:meta/meta.dart';

class ChartData {
  ChartData({
    @required this.dataList,
  });

  final ListData dataList;

  factory ChartData.fromMap(Map<String, dynamic> json) => ChartData(
        dataList: ListData.fromMap(json["strategy"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        "strategy": dataList.toMap(),
      };
}

class ListData {
  ListData({
    @required this.data,
  });

  final List<ChartPoint> data;

  factory ListData.fromMap(Map<String, dynamic> json) {
    final data = json['data'] is List ? json['data'] as List : null;
    return ListData(
      data: (data?.isNotEmpty ?? false)
          ? List<ChartPoint>.from(data.map((x) => ChartPoint.fromMap(x as Map<String, dynamic>)))
              .where((element) => element.hasAllValues())
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toMap() => {
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class ChartPoint {
  ChartPoint({
    @required this.value,
    @required this.date,
    @required this.pips,
  });

  final double value;
  final DateTime date;
  final double pips;

  factory ChartPoint.fromMap(Map<String, dynamic> json) => ChartPoint(
        value: double.tryParse(json["value"]?.toString() ?? '0'),
        date: DateTime.tryParse(json["date"]?.toString() ?? '0'),
        pips: double.tryParse(json["pips"]?.toString() ?? '0'),
      );

  bool hasAllValues() {
    return value != null && date != null && pips != null;
  }

  Map<String, dynamic> toMap() => {
        "value": value,
        "date": date.toIso8601String(),
        "pips": pips,
      };
}
