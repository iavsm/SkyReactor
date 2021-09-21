import 'package:flutter/foundation.dart';

class TransactionsResponse {
  TransactionsResponse({
    @required this.balance,
    @required this.details,
  });

  final String balance;
  final TransactionsResponseDetails details;

  factory TransactionsResponse.fromMap(Map<String, dynamic> json) => TransactionsResponse(
        balance: json["balance"]?.toString() ?? '-',
        details: TransactionsResponseDetails.fromMap(json["details"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        "balance": balance,
        "details": details.toMap(),
      };
}

class TransactionsResponseDetails {
  TransactionsResponseDetails({
    @required this.currentPage,
    @required this.transactions,
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

  final int currentPage;
  final List<Transaction> transactions;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final String nextPageUrl;
  final String path;
  final int perPage;
  final String prevPageUrl;
  final int to;
  final int total;

  factory TransactionsResponseDetails.fromMap(Map<String, dynamic> json) {
    final List data = json['data'] as List;
    return TransactionsResponseDetails(
      currentPage: json["current_page"] as int,
      transactions: List<Transaction>.from(
        data.map(
          (x) => Transaction.fromMap(x as Map<String, dynamic>),
        ),
      ),
      firstPageUrl: json["first_page_url"]?.toString(),
      from: json["from"] as int,
      lastPage: json["last_page"] as int,
      lastPageUrl: json["last_page_url"]?.toString(),
      nextPageUrl: json["next_page_url"]?.toString(),
      path: json["path"]?.toString(),
      perPage: json["per_page"] as int,
      prevPageUrl: json["prev_page_url"]?.toString(),
      to: json["to"] as int,
      total: json["total"] as int,
    );
  }

  Map<String, dynamic> toMap() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(transactions.map((x) => x.toMap())),
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

class Transaction {
  Transaction({
    @required this.txnid,
    @required this.remarks,
    @required this.type,
    @required this.status,
    @required this.amount,
    @required this.txndate,
  });

  final String txnid;
  final String remarks;
  final String type;
  final String status;
  final String amount;
  final String txndate;

  factory Transaction.fromMap(Map<String, dynamic> json) => Transaction(
        txnid: json["txnid"]?.toString(),
        remarks: json["remarks"]?.toString(),
        type: json["type"]?.toString(),
        status: json["status"]?.toString(),
        amount: json["amount"]?.toString(),
        txndate: json["txndate"]?.toString(),
      );

  Map<String, dynamic> toMap() => {
        "txnid": txnid,
        "remarks": remarks,
        "type": type,
        "status": status,
        "amount": amount,
        "txndate": txndate,
      };
}
