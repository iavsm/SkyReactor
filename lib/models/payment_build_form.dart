import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

class PaymentBuildForm {
  PaymentBuildForm({
    @required this.form,
    @required this.txn,
  });

  final PaymentForm form;
  final String txn;

  factory PaymentBuildForm.fromMap(Map<String, dynamic> json) => PaymentBuildForm(
        form:
            json["form"] != null ? PaymentForm.fromMap(json["form"] as Map<String, dynamic>) : null,
        txn: json["txn"]?.toString(),
      );

  Map<String, dynamic> toMap() => {
        "form": form?.toMap(),
        "txn": txn,
      };
}

class PaymentForm {
  PaymentForm({
    @required this.mode,
    @required this.value,
    @required this.fields,
  });

  final String mode;
  final PaymentValue value;
  final List<PaymentField> fields;

  bool get isLocal => mode == 'local';

  factory PaymentForm.fromMap(Map<String, dynamic> json) => PaymentForm(
        mode: json["mode"]?.toString(),
        value: json["value"] != null
            ? PaymentValue.fromMap(json["value"] as Map<String, dynamic>)
            : null,
        fields: json["feilds"] != null
            ? List<PaymentField>.from((json["feilds"] as List)
                .map((x) => PaymentField.fromMap(x as Map<String, dynamic>)))
            : null,
      );

  Map<String, dynamic> toMap() => {
        "mode": mode,
        "value": value?.toMap(),
        "feilds": fields == null ? null : List<dynamic>.from(fields.map((x) => x.toMap())),
      };
}

class PaymentField {
  PaymentField({
    @required this.name,
    @required this.type,
    @required this.label,
    @required this.inputType,
    @required this.validations,
    @required this.value,
    @required this.options,
    this.controller,
  });

  final String name;
  final String type;
  final String label;
  final String inputType;
  final String value;
  final List<Validation> validations;
  final List<String> options;

  bool showError = false;
  TextEditingController controller;

  bool get isMultiSelection => type == 'select' && options.isNotEmpty;
  bool get isTextField => type == 'input';

  factory PaymentField.fromMap(Map<String, dynamic> json) => PaymentField(
        name: json["name"]?.toString(),
        type: json["type"]?.toString(),
        label: json["label"]?.toString(),
        inputType: json["inputType"]?.toString(),
        value: json["value"]?.toString(),
        validations: json["validations"] != null
            ? List<Validation>.from((json["validations"] as List)
                .map((x) => Validation.fromMap(x as Map<String, dynamic>)))
            : [],
        options: json["options"] != null
            ? List<String>.from((json["options"] as List).map((x) => x))
            : [],
        controller: json['type']?.toString() == 'select' ? TextEditingController() : null,
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "type": type,
        "label": label,
        "inputType": inputType,
        "validations":
            validations.isEmpty ? [] : List<dynamic>.from(validations.map((x) => x.toMap())),
      };
}

class Validation {
  Validation({
    @required this.name,
    @required this.message,
    @required this.validator,
  });

  final String name;
  final String message;
  final String validator; // required OR Regex

  factory Validation.fromMap(Map<String, dynamic> json) => Validation(
        name: json["name"]?.toString(),
        message: json["message"]?.toString(),
        validator: json["validator"]?.toString(),
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "message": message,
        "validator": validator,
      };
}

class PaymentValue {
  PaymentValue({
    @required this.id,
    @required this.rid,
    @required this.name,
    @required this.bcode,
    @required this.bname,
    @required this.bbranch,
    @required this.avalue,
    @required this.option,
  });

  final String id;
  final String rid;
  final String name;
  final String bcode;
  final String bname;
  final String bbranch;
  final String avalue;
  final List<String> option;

  factory PaymentValue.fromMap(Map<String, dynamic> json) => PaymentValue(
        id: json["id"]?.toString(),
        rid: json["rid"]?.toString(),
        name: json["name"]?.toString(),
        bcode: json["bcode"]?.toString(),
        bname: json["bname"]?.toString(),
        bbranch: json["bbranch"]?.toString(),
        avalue: json["avalue"]?.toString(),
        option:
            json["option"] != null ? List<String>.from((json["option"] as List).map((x) => x)) : [],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "rid": rid,
        "name": name,
        "bcode": bcode,
        "bname": bname,
        "bbranch": bbranch,
        "avalue": avalue,
        "option": List<dynamic>.from(option.map((x) => x)),
      };
}
