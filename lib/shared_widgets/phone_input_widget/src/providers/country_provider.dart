import 'package:copy_trading/shared_widgets/phone_input_widget/src/models/country_model.dart';
import 'package:flutter/widgets.dart';

import '../models/country_list.dart';

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
const String PropertyName = 'alpha_2_code';

/// [CountryProvider] provides helper classes that involves manipulations.
/// of Countries from [Countries.countryList]
class CountryProvider {
  /// Get data of Countries.
  ///
  /// Returns List of [Country].
  ///
  ///  * If [countries] is `null` or empty it returns a list of all [Countries.countryList].
  ///  * If [countries] is not empty it returns a filtered list containing
  ///    counties as specified.
  static List<Country> getCountriesData({@required List<String> countries}) {
    List jsonList = Countries.countryList;

    if (countries == null || countries.isEmpty) {
      return jsonList.map((country) => Country.fromJson(country as Map<String, dynamic>)).toList();
    }
    List filteredList = jsonList.where((country) {
      return countries.contains(country[PropertyName]);
    }).toList();

    return filteredList
        .map((country) => Country.fromJson(country as Map<String, dynamic>))
        .toList();
  }
}
