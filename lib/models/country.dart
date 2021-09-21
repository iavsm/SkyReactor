import 'package:flutter/foundation.dart';

class Country {
  final String flag;
  final String name;
  final String shortName;

  const Country({@required this.flag, @required this.name, @required this.shortName});

  factory Country.fromMap(Map<String, dynamic> map) {
    return Country(
      flag: map['flag']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      shortName: map['shortname']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        "shortname": shortName,
        "flag": flag,
        "name": name,
      };
}

class RegistrationCountry {
  final String name;
  final int id;
  final String shortName;

  RegistrationCountry({
    @required this.name,
    @required this.shortName,
    @required this.id,
  });

  factory RegistrationCountry.fromMap(Map<String, dynamic> map) {
    return RegistrationCountry(
      name: map['name']?.toString(),
      shortName: map['shortname']?.toString(),
      id: int.tryParse(map['id']?.toString() ?? '0'),
    );
  }
}

class RegistrationState {
  final String name;
  final int id;

  RegistrationState({@required this.name, @required this.id});

  factory RegistrationState.fromMap(Map<String, dynamic> map) {
    return RegistrationState(
      name: map['name']?.toString(),
      id: int.tryParse(map['id']?.toString() ?? '0'),
    );
  }
}
