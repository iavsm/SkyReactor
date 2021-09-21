import 'package:flutter/foundation.dart';

class RegisterInput {
  final String email;
  final String countryCode;
  final String phone;
  final String firstName;
  final String lastName;
  final String emailOtp;
  final String phoneOtp;
  final int countryId;
  final int stateId;

  RegisterInput({
    @required this.email,
    @required this.countryCode,
    @required this.phone,
    @required this.firstName,
    @required this.lastName,
    @required this.emailOtp,
    @required this.phoneOtp,
    @required this.countryId,
    @required this.stateId,
  });

  Map<String, dynamic> toMap() => {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'countrycode': countryCode,
        'mobile': phone,
        'ecode': emailOtp,
        'mcode': phoneOtp,
        'country': countryId,
        'state': stateId,
        'registration': 'socialtrading',
        'groupcode': 11,
        'tnc': 'true',
      };
}
