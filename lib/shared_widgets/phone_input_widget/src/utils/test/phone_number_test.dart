import 'package:copy_trading/shared_widgets/phone_input_widget/src/models/country_list.dart';
import 'package:copy_trading/shared_widgets/phone_input_widget/src/utils/phone_number/phone_number_util.dart';
import 'package:flutter/foundation.dart';

// ignore_for_file: unnecessary_this
// ignore_for_file: prefer_final_locals
// ignore_for_file: prefer_const_constructors_in_immutables
// ignore_for_file: prefer_const_constructors
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: annotate_overrides
// ignore_for_file: overridden_fields
// ignore_for_file: constant_identifier_names
// ignore_for_file: type_annotate_public_apis
class PhoneNumberTest {
  final String phoneNumber;
  final String dialCode;
  final String isoCode;

  PhoneNumberTest({this.phoneNumber, this.dialCode, this.isoCode});

  @override
  String toString() {
    return phoneNumber;
  }

  static Future<PhoneNumberTest> getRegionInfoFromPhoneNumber(
    String phoneNumber, [
    String isoCode = '',
  ]) async {
    assert(isoCode != null);
    RegionInfo regionInfo =
        await PhoneNumberUtil.getRegionInfo(phoneNumber: phoneNumber, isoCode: isoCode);

    String internationalPhoneNumber = await PhoneNumberUtil.normalizePhoneNumber(
      phoneNumber: phoneNumber,
      isoCode: regionInfo.isoCode ?? isoCode,
    );

    return PhoneNumberTest(
        phoneNumber: internationalPhoneNumber,
        dialCode: regionInfo.regionPrefix,
        isoCode: regionInfo.isoCode);
  }

  static Future<String> getParsableNumber(PhoneNumberTest phoneNumber) async {
    assert(phoneNumber != null);
    if (phoneNumber.isoCode != null) {
      PhoneNumberTest number = await getRegionInfoFromPhoneNumber(
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
      debugPrint('ISO Code is "${phoneNumber.isoCode}"');
      return '';
    }
  }

  String parseNumber() {
    return this.phoneNumber.replaceAll(RegExp('^([\\+]?${this.dialCode}[\\s]?)'), '');
  }

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
}
