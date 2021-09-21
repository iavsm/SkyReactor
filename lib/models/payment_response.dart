import 'package:flutter/foundation.dart';

class PaymentResponse {
  final String message;
  final String errorHead;
  final String errorSubhead;
  final String errorMessage;
  final String successHead;
  final String successSubhead;
  final String fullUrl;
  final bool showPin;

  bool get success => message == 'success';

  PaymentResponse({
    @required this.message,
    @required this.errorHead,
    @required this.errorSubhead,
    @required this.errorMessage,
    @required this.successHead,
    @required this.successSubhead,
    @required this.fullUrl,
    @required this.showPin,
  });

  factory PaymentResponse.fromMap(Map<String, dynamic> json) {
    final errorsMap = json['errors'];
    final dataMap = json['data'];
    final successMap = dataMap == null ? null : dataMap['success'];
    return PaymentResponse(
      message: json['message']?.toString(),
      errorHead: errorsMap == null ? null : errorsMap['head']?.toString(),
      errorSubhead: errorsMap == null ? null : errorsMap['subhead']?.toString(),
      errorMessage: errorsMap == null ? null : errorsMap['error']?.toString(),
      successHead: successMap == null ? null : successMap['head']?.toString(),
      successSubhead: successMap == null ? null : successMap['subhead']?.toString(),
      showPin: successMap == null ? null : successMap['pinVerification'] == true,
      fullUrl: dataMap == null ? null : dataMap['fullURL']?.toString(),
    );
  }

  Map<String, dynamic> toMap() => {
        'message': message,
        'errorHead': errorHead,
        'errorSubhead': errorSubhead,
        'errorMessage': errorMessage,
        'successHead': successHead,
        'successSubhead': successSubhead,
        'pinVerification': showPin,
        'fullUrl': fullUrl,
      };
}
