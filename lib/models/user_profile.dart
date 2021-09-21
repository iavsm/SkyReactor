import 'package:meta/meta.dart';

import 'payment_gateways_response.dart';

class UserProfile {
  UserProfile({
    @required this.basicProfile,
    @required this.lastLoginActivity,
    @required this.userProfile,
  });

  final BasicProfile basicProfile;
  final LastLoginActivity lastLoginActivity;
  final ProfileDetails userProfile;

  factory UserProfile.fromMap(Map<String, dynamic> json) => UserProfile(
        basicProfile: BasicProfile.fromMap(json["details"]["basicProfile"] as Map<String, dynamic>),
        lastLoginActivity:
            LastLoginActivity.fromMap(json["details"]["lastLoginActivity"] as Map<String, dynamic>),
        userProfile: ProfileDetails.fromMap(json["details"]["userProfile"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        "basicProfile": basicProfile?.toMap(),
        "lastLoginActivity": lastLoginActivity?.toMap(),
        "userProfile": userProfile?.toMap(),
      };
}

class BasicProfile {
  BasicProfile({
    @required this.name,
    @required this.email,
    @required this.customerId,
    @required this.profileImg,
    @required this.profileCompleteness,
    @required this.dateCreated,
    @required this.lastDeposit,
    @required this.lastWithdrawal,
  });

  final String name;
  final String email;
  final String customerId;
  final String profileImg;
  final String profileCompleteness;
  final String dateCreated;
  final Last lastDeposit;
  final Last lastWithdrawal;

  factory BasicProfile.fromMap(Map<String, dynamic> json) => BasicProfile(
        name: json["name"]?.toString(),
        email: json["email"]?.toString(),
        customerId: json["customer_id"]?.toString(),
        profileImg: json["profile_img"]?.toString(),
        profileCompleteness: json["profileCompleteness"]?.toString(),
        dateCreated: json["dateCreated"]?.toString(),
        lastDeposit: Last.fromMap(json["lastDeposit"] as Map<String, dynamic>),
        lastWithdrawal: Last.fromMap(json["lastWithdrawal"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "email": email,
        "customer_id": customerId,
        "profile_img": profileImg,
        "profileCompleteness": profileCompleteness,
        "dateCreated": dateCreated,
        "lastDeposit": lastDeposit.toMap(),
        "lastWithdrawal": lastWithdrawal.toMap(),
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

class ProfileDetails {
  ProfileDetails({
    @required this.firstName,
    @required this.lastName,
    @required this.dob,
    @required this.email,
    @required this.mobile,
    @required this.nationality,
    @required this.addressLine1,
    @required this.addressLine2,
    @required this.city,
    @required this.state,
    @required this.zipcode,
    @required this.country,
    @required this.others,
    @required this.countryDetails,
  });

  final String firstName;
  final String lastName;
  final String dob;
  final String email;
  final String mobile;
  final String nationality;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String zipcode;
  final String country;
  final String others;
  final CountryDetails countryDetails;

  factory ProfileDetails.fromMap(Map<String, dynamic> json) => ProfileDetails(
        firstName: json["first_name"]?.toString(),
        lastName: json["last_name"]?.toString(),
        dob: json["dob"]?.toString(),
        email: json["email"]?.toString(),
        mobile: json["mobile"]?.toString(),
        nationality: json["nationality"]?.toString(),
        addressLine1: json["address_line1"]?.toString(),
        addressLine2: json["address_line2"]?.toString(),
        city: json["city"]?.toString(),
        state: json["state"]?.toString(),
        zipcode: json["zipcode"]?.toString(),
        country: json["country"]?.toString(),
        others: json["others"]?.toString(),
        countryDetails: CountryDetails.fromMap(json["country_details"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        "first_name": firstName,
        "last_name": lastName,
        "dob": dob,
        "email": email,
        "mobile": mobile,
        "nationality": nationality,
        "address_line1": addressLine1,
        "address_line2": addressLine2,
        "city": city,
        "state": state,
        "zipcode": zipcode,
        "country": country,
        "others": others,
        "country_details": countryDetails?.toMap(),
      };
}

class CountryDetails {
  CountryDetails({
    @required this.shortName,
    @required this.flag,
  });

  final String shortName;
  final String flag;

  factory CountryDetails.fromMap(Map<String, dynamic> json) => CountryDetails(
        shortName: json["shortname"]?.toString(),
        flag: json["flag"]?.toString(),
      );

  Map<String, dynamic> toMap() => {
        "shortname": shortName,
        "flag": flag,
      };
}
