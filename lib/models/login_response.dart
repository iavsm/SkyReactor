import 'package:meta/meta.dart';

class LoginResponse {
  LoginResponse({
    @required this.message,
    @required this.data,
    @required this.errorMessage,
  });

  final String message;
  final Data data;
  final String errorMessage;

  bool get success => errorMessage == null;

  factory LoginResponse.fromMap(Map<String, dynamic> json) => LoginResponse(
        message: json["message"]?.toString(),
        data: json['data'] == null ? null : Data.fromMap(json["data"] as Map<String, dynamic>),
        errorMessage: json['errors'] == null ? null : json['errors']['message']?.toString(),
      );

  Map<String, dynamic> toMap() => {
        "message": message,
        "data": data.toMap(),
      };
}

class Data {
  Data({
    @required this.successMessage,
    @required this.loginPassKey,
  });

  final String successMessage;
  final LoginPassKey loginPassKey;

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        successMessage: json["success"]?.toString(),
        loginPassKey: LoginPassKey.fromMap(json["login_pass_key"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        "success": successMessage,
        "login_pass_key": loginPassKey.toMap(),
      };
}

class LoginPassKey {
  LoginPassKey({
    @required this.tokenType,
    @required this.expiresIn,
    @required this.accessToken,
    @required this.refreshToken,
  });

  final String tokenType;
  final int expiresIn;
  final String accessToken;
  final String refreshToken;

  factory LoginPassKey.fromMap(Map<String, dynamic> json) => LoginPassKey(
        tokenType: json["token_type"]?.toString(),
        expiresIn: int.tryParse((json["expires_in"]?.toString()) ?? '0'),
        accessToken: json["access_token"]?.toString(),
        refreshToken: json["refresh_token"]?.toString(),
      );

  Map<String, dynamic> toMap() => {
        "token_type": tokenType,
        "expires_in": expiresIn,
        "access_token": accessToken,
        "refresh_token": refreshToken,
      };
}
