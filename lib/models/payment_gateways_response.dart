import 'package:meta/meta.dart';

class PaymentGatewaysResponse {
  PaymentGatewaysResponse({
    @required this.accountSelectionList,
    @required this.frequentTransactions,
    @required this.gatewaysAvailable,
    @required this.basicProfile,
    @required this.lastLoginActivity,
  });

  final AccountSelectionList accountSelectionList;
  final List<FrequentTransaction> frequentTransactions;
  final List<PaymentGateway> gatewaysAvailable;
  final BasicProfile basicProfile;
  final LastLoginActivity lastLoginActivity;

  factory PaymentGatewaysResponse.fromMap(Map<String, dynamic> json) => PaymentGatewaysResponse(
        accountSelectionList: AccountSelectionList.fromMap(
            json['details']["accountSelectionList"] as Map<String, dynamic>),
        frequentTransactions: List<FrequentTransaction>.from(
            (json['details']["frequentTrasactions"] as List)
                .map((x) => FrequentTransaction.fromMap(x as Map<String, dynamic>))),
        gatewaysAvailable: List<PaymentGateway>.from((json['details']["depositAvailable"] != null
                ? json['details']["depositAvailable"] as List
                : json['details']['withdrawAvailable'] as List)
            .map((x) => PaymentGateway.fromMap(x as Map<String, dynamic>))),
        basicProfile: BasicProfile.fromMap(json['details']["basicProfile"] as Map<String, dynamic>),
        lastLoginActivity:
            LastLoginActivity.fromMap(json['details']["lastLoginActivity"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        "accountSelectionList": accountSelectionList.toMap(),
        "frequentTrasactions": List<dynamic>.from(frequentTransactions.map((x) => x.toMap())),
        "depositAvailable": List<dynamic>.from(gatewaysAvailable.map((x) => x.toMap())),
        "basicProfile": basicProfile.toMap(),
        "lastLoginActivity": lastLoginActivity.toMap(),
      };
}

class AccountSelectionList {
  AccountSelectionList({
    @required this.platform,
  });

  final List<String> platform;

  factory AccountSelectionList.fromMap(Map<String, dynamic> json) => AccountSelectionList(
        platform: List<String>.from((json["platform"] as List).map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "platform": List<dynamic>.from(platform.map((x) => x)),
      };
}

class BasicProfile {
  BasicProfile({
    @required this.name,
    @required this.email,
    @required this.customerId,
    @required this.profileCompleteness,
    @required this.dateCreated,
    @required this.lastDeposit,
    @required this.lastWithdrawal,
  });

  final String name;
  final String email;
  final String customerId;
  final String profileCompleteness;
  final String dateCreated;
  final Last lastDeposit;
  final Last lastWithdrawal;

  factory BasicProfile.fromMap(Map<String, dynamic> json) => BasicProfile(
        name: json["name"]?.toString(),
        email: json["email"]?.toString(),
        customerId: json["customer_id"]?.toString(),
        profileCompleteness: json["profileCompleteness"]?.toString(),
        dateCreated: json["dateCreated"]?.toString(),
        lastDeposit: Last.fromMap(json["lastDeposit"] as Map<String, dynamic>),
        lastWithdrawal: Last.fromMap(json["lastWithdrawal"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "email": email,
        "customer_id": customerId,
        "profileCompleteness": profileCompleteness,
        "dateCreated": dateCreated,
        "lastDeposit": lastDeposit.toMap(),
        "lastWithdrawal": lastWithdrawal.toMap(),
      };
}

class Last {
  Last({
    @required this.amount,
    @required this.date,
  });

  final String amount;
  final String date;

  factory Last.fromMap(Map<String, dynamic> json) => Last(
        amount: json["amount"]?.toString(),
        date: json["date"]?.toString(),
      );

  Map<String, dynamic> toMap() => {
        "amount": amount,
        "date": date,
      };
}

class PaymentGateway {
  PaymentGateway({
    @required this.logo,
    @required this.paymentgateway,
    @required this.display,
    @required this.android,
    @required this.iOS,
  });

  final String logo;
  final String paymentgateway;
  final String display;
  final Map<String, String> android;
  final Map<String, String> iOS;

  factory PaymentGateway.fromMap(Map<String, dynamic> json) => PaymentGateway(
        logo: json["logo"]?.toString(),
        paymentgateway: json["paymentgateway"]?.toString(),
        display: json["display"]?.toString(),
        android: Map.from(json["Android"] as Map)
            .map((k, v) => MapEntry<String, String>(k as String, v as String)),
        iOS: Map.from(json["iOS"] as Map)
            .map((k, v) => MapEntry<String, String>(k as String, v as String)),
      );

  Map<String, dynamic> toMap() => {
        "logo": logo,
        "paymentgateway": paymentgateway,
        "display": display,
        "Android": Map.from(android).map((k, v) => MapEntry<String, dynamic>(k as String, v)),
        "iOS": Map.from(iOS).map((k, v) => MapEntry<String, dynamic>(k as String, v)),
      };
}

class FrequentTransaction {
  FrequentTransaction({
    @required this.id,
    @required this.logo,
    @required this.paymentgateway,
  });

  final String id;
  final String logo;
  final String paymentgateway;

  factory FrequentTransaction.fromMap(Map<String, dynamic> json) => FrequentTransaction(
        id: json["id"]?.toString(),
        logo: json["logo"]?.toString(),
        paymentgateway: json["paymentgateway"]?.toString(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "logo": logo,
        "paymentgateway": paymentgateway,
      };
}

class LastLoginActivity {
  LastLoginActivity({
    @required this.ipAddress,
    @required this.lastLoginDate,
  });

  final String ipAddress;
  final String lastLoginDate;

  factory LastLoginActivity.fromMap(Map<String, dynamic> json) => LastLoginActivity(
        ipAddress: json["ipAddress"]?.toString(),
        lastLoginDate: json["lastLoginDate"]?.toString(),
      );

  Map<String, dynamic> toMap() => {
        "ipAddress": ipAddress,
        "lastLoginDate": lastLoginDate,
      };
}
