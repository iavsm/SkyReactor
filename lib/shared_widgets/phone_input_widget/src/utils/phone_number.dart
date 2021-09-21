import 'dart:math';

import 'package:copy_trading/shared_widgets/phone_input_widget/src/models/country_list.dart';
import 'package:equatable/equatable.dart';

import 'phone_number/phone_number_util.dart';

// ignore_for_file: unnecessary_this
// ignore_for_file: prefer_final_locals
// ignore_for_file: prefer_const_constructors_in_immutables
// ignore_for_file: prefer_const_constructors
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: annotate_overrides
// ignore_for_file: overridden_fields
// ignore_for_file: constant_identifier_names
// ignore_for_file: type_annotate_public_apis
// ignore_for_file: prefer_typing_uninitialized_variables
/// Type of phone numbers.
enum PhoneNumberType {
  FIXED_LINE, // : 0,
  MOBILE, //: 1,
  FIXED_LINE_OR_MOBILE, //: 2,
  TOLL_FREE, //: 3,
  PREMIUM_RATE, //: 4,
  SHARED_COST, //: 5,
  VOIP, //: 6,
  PERSONAL_NUMBER, //: 7,
  PAGER, //: 8,
  UAN, //: 9,
  VOICEMAIL, //: 10,
  UNKNOWN, //: -1
}

/// [PhoneNumber] contains detailed information about a phone number
class PhoneNumber extends Equatable {
  /// Either formatted or unformatted String of the phone number
  final String phoneNumber;

  /// The Country [dialCode] of the phone number
  final String dialCode;

  /// Country [isoCode] of the phone number
  final String isoCode;

  /// [_hash] is used to compare instances of [PhoneNumber] object.
  final int _hash;

  /// Returns an integer generated after the object was initialised.
  /// Used to compare different instances of [PhoneNumber]
  int get hash => _hash;

  @override
  List<Object> get props => [phoneNumber, dialCode];

  PhoneNumber({
    this.phoneNumber,
    this.dialCode,
    this.isoCode,
  }) : _hash = 1000 + Random().nextInt(99999 - 1000);

  @override
  String toString() {
    return phoneNumber;
  }

  /// Returns [PhoneNumber] which contains region information about
  /// the [phoneNumber] and [isoCode] passed.
  static Future<PhoneNumber> getRegionInfoFromPhoneNumber(
    String phoneNumber, [
    String isoCode = '',
  ]) async {
    assert(isoCode != null);
    RegionInfo regionInfo =
        await PhoneNumberUtil.getRegionInfo(phoneNumber: phoneNumber ?? '', isoCode: isoCode);

    String internationalPhoneNumber = await PhoneNumberUtil.normalizePhoneNumber(
      phoneNumber: phoneNumber,
      isoCode: regionInfo.isoCode ?? isoCode,
    );

    return PhoneNumber(
      phoneNumber: internationalPhoneNumber,
      dialCode: regionInfo.regionPrefix,
      isoCode: regionInfo.isoCode,
    );
  }

  /// Accepts a [PhoneNumber] object and returns a formatted phone number String
  static Future<String> getParsableNumber(PhoneNumber phoneNumber) async {
    assert(phoneNumber != null);
    if (phoneNumber.isoCode != null) {
      PhoneNumber number = await getRegionInfoFromPhoneNumber(
        phoneNumber.phoneNumber,
        phoneNumber.isoCode,
      );
      String formattedNumber = await PhoneNumberUtil.formatAsYouType(
        phoneNumber: number.phoneNumber,
        isoCode: number.isoCode,
      );
      return formattedNumber.replaceAll(
        RegExp('^([\\+]?${number.dialCode}[\\s]?)'),
        '',
      );
    } else {
      // ignore: avoid_print
      print('ISO Code is "${phoneNumber.isoCode}"');
      return '';
    }
  }

  /// Returns a String of [phoneNumber] without [dialCode]
  String parseNumber() {
    return this.phoneNumber.replaceAll(this.dialCode, '');
  }

  /// For predefined phone number returns Country's [isoCode] from the dial code,
  /// Returns null if not found.
  static String getISO2CodeByPrefix(String prefix) {
    if (prefix != null && prefix.isNotEmpty) {
      // ignore: parameter_assignments
      prefix = prefix.startsWith('+') ? prefix : '+$prefix';
      var country = Countries.countryList
          .firstWhere((country) => country['dial_code'] == prefix, orElse: () => null);
      if (country != null && country['alpha_2_code'] != null) {
        return country['alpha_2_code']?.toString();
      }
    }
    return null;
  }

  /// Returns [PhoneNumberType] which is the type of phone number
  /// Accepts [phoneNumber] and [isoCode] and r
  static Future<PhoneNumberType> getPhoneNumberType(String phoneNumber, String isoCode) async {
    PhoneNumberType type =
        await PhoneNumberUtil.getNumberType(phoneNumber: phoneNumber, isoCode: isoCode);

    return type;
  }
}
