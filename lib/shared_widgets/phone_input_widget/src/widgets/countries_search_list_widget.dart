import 'package:copy_trading/shared_widgets/phone_input_widget/src/models/country_model.dart';
import 'package:copy_trading/shared_widgets/phone_input_widget/src/utils/test/test_helper.dart';
import 'package:copy_trading/shared_widgets/phone_input_widget/src/utils/util.dart';
import 'package:flutter/material.dart';

// ignore_for_file: unnecessary_this
// ignore_for_file: prefer_final_locals
// ignore_for_file: prefer_const_constructors_in_immutables
// ignore_for_file: prefer_const_constructors
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: annotate_overrides
// ignore_for_file: overridden_fields
// ignore_for_file: constant_identifier_names
// ignore_for_file: type_annotate_public_apis
/// Creates a list of Countries with a search textfield.
class CountrySearchListWidget extends StatefulWidget {
  final List<Country> countries;
  final InputDecoration searchBoxDecoration;
  final String locale;
  final ScrollController scrollController;
  final bool autoFocus;
  final bool showFlags;
  final bool useEmoji;

  CountrySearchListWidget(this.countries, this.locale,
      {this.searchBoxDecoration,
      this.scrollController,
      this.showFlags,
      this.useEmoji,
      this.autoFocus = false});

  @override
  _CountrySearchListWidgetState createState() => _CountrySearchListWidgetState();
}

class _CountrySearchListWidgetState extends State<CountrySearchListWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<Country> filteredCountries;

  @override
  void initState() {
    filteredCountries = filterCountries();
    super.initState();
  }

  @override
  void dispose() {
    _searchController?.dispose();
    super.dispose();
  }

  /// Returns [InputDecoration] of the search box
  InputDecoration getSearchBoxDecoration() {
    return widget.searchBoxDecoration ??
        InputDecoration(labelText: 'Search by country name or dial code');
  }

  /// Filters the list of Country by text from the search box.
  List<Country> filterCountries() {
    final value = _searchController.text.trim();

    if (value.isNotEmpty) {
      return widget.countries
          .where(
            (Country country) =>
                country.alpha3Code.toLowerCase().startsWith(value.toLowerCase()) ||
                country.name.toLowerCase().contains(value.toLowerCase()) ||
                getCountryName(country).toLowerCase().contains(value.toLowerCase()) ||
                country.dialCode.contains(value.toLowerCase()),
          )
          .toList();
    }

    return widget.countries;
  }

  /// Returns the country name of a [Country]. if the locale is set and translation in available.
  /// returns the translated name.
  String getCountryName(Country country) {
    if (widget.locale != null && country.nameTranslations != null) {
      String translated = country.nameTranslations[widget.locale];
      if (translated != null && translated.isNotEmpty) {
        return translated;
      }
    }
    return country.name;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            key: Key(TestHelper.CountrySearchInputKeyValue),
            decoration: getSearchBoxDecoration(),
            controller: _searchController,
            autofocus: widget.autoFocus,
            onChanged: (value) => setState(() => filteredCountries = filterCountries()),
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: widget.scrollController,
            shrinkWrap: true,
            itemCount: filteredCountries.length,
            itemBuilder: (BuildContext context, int index) {
              Country country = filteredCountries[index];
              if (country == null) return null;
              return ListTile(
                key: Key(TestHelper.countryItemKeyValue(country.alpha2Code)),
                leading:
                    widget.showFlags ? _Flag(country: country, useEmoji: widget.useEmoji) : null,
                title: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(getCountryName(country), textAlign: TextAlign.start)),
                subtitle: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(country?.dialCode ?? '',
                        textDirection: TextDirection.ltr, textAlign: TextAlign.start)),
                onTap: () => Navigator.of(context).pop(country),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}

class _Flag extends StatelessWidget {
  final Country country;
  final bool useEmoji;

  const _Flag({Key key, this.country, this.useEmoji}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return country != null
        ? Container(
            child: useEmoji
                ? Text(
                    Utils.generateFlagEmojiUnicode(country?.alpha2Code ?? ''),
                    style: Theme.of(context).textTheme.headline5,
                  )
                : country?.flagUri != null
                    ? CircleAvatar(
                        backgroundImage: AssetImage(
                          country.flagUri,
                          package: 'intl_phone_number_input',
                        ),
                      )
                    : SizedBox.shrink(),
          )
        : SizedBox.shrink();
  }
}
