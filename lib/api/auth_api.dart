import 'package:copy_trading/api/core/api_core.dart';
import 'package:copy_trading/api/core/api_links.dart';
import 'package:copy_trading/locator/locator.dart';
import 'package:copy_trading/models/country.dart';
import 'package:copy_trading/models/login_response.dart';
import 'package:copy_trading/models/register_input.dart';
import 'package:copy_trading/shared_widgets/phone_input_widget/intl_phone_number_input.dart';
import 'package:flutter/foundation.dart';

mixin AuthApi on ApiCore {
  final ApiLinks apiLinks = locator<ApiLinks>();

  Future requestOtp({@required String email, @required PhoneNumber phone}) async {
    try {
      final Uri uri = Uri.parse(apiLinks.registerVerify);
      final response = await apiClient.post(uri,
          body: {
            'email': email,
            'countrycode': phone.dialCode.substring(1),
            'mobile': phone.phoneNumber.substring(1)
          },
          headers: formHeaders);
      final json = jsonDecode(response.body);
      if (json['message'] == 'success') {
        return json['data']['success'] ?? 'OTP Sent successfully';
      } else if (json['errors'] != null) {
        throw json['errors'].values.first is String
            ? json['errors'].values.first
            : json['errors'].values.first.first;
      } else {
        return json;
      }
    } catch (e, stack) {
      debugPrint(e.toString());
      debugPrint(stack.toString());
      rethrow;
    }
  }

  Future register(RegisterInput input) async {
    try {
      final Uri uri = Uri.parse(apiLinks.register);
      final response =
          await apiClient.post(uri, body: jsonEncode(input.toMap()), headers: defaultHeaders);
      final json = jsonDecode(response.body);
      if (json['message'] == 'success') {
        return json['data']['success'] ?? 'Registered successfully';
      } else if (json['errors'] != null) {
        if (json['errors'].values.first is String) {
          throw json['errors'].values.first;
        } else {
          throw json['errors'].values.first.first;
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<LoginResponse> login(String email, String password) async {
    final input = {
      'username': email,
      'password': password,
      'client_id': 2,
      'client_secret': 'xci8ZwMgvBCdmrlYo57gy055viHdHZcMYOAJExeN',
      'grant_type': 'password',
    };
    try {
      print(apiLinks.login);
      final Uri uri = Uri.parse(apiLinks.login);
      final response = await apiClient.post(uri, body: jsonEncode(input), headers: defaultHeaders);
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return LoginResponse.fromMap(json);
    } catch (e, stack) {
      debugPrint(stack.toString());
      rethrow;
    }
  }

  Future<LoginResponse> refreshLogin(String token) async {
    final input = {
      'refresh_token': token,
      'client_id': 2,
      'client_secret': 'xci8ZwMgvBCdmrlYo57gy055viHdHZcMYOAJExeN',
      'grant_type': 'refresh_token',
    };
    try {
      final Uri uri = Uri.parse(apiLinks.login);
      final response = await apiClient.post(uri, body: jsonEncode(input), headers: defaultHeaders);
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return LoginResponse.fromMap(json);
    } catch (e) {
      rethrow;
    }
  }

  Future forgotPassword(String email) async {
    try {
      final Uri uri = Uri.parse(apiLinks.forgotPassword);
      final response =
          await apiClient.post(uri, body: jsonEncode({'email': email}), headers: defaultHeaders);
      final json = jsonDecode(response.body);
      if (json['message'] == 'success') {
        return json['data']['success'] ?? 'success';
      } else if (json['errors'] != null) {
        throw json['errors'].values.first.first;
      } else {
        return json;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future changePassword(
      {@required String email, @required String password, @required String token}) async {
    final input = {
      'token': token,
      'email': email,
      'password': password,
      'password_confirmation': password,
    };
    try {
      final Uri uri = Uri.parse(apiLinks.newPassword);
      final response = await apiClient.post(uri, body: jsonEncode(input), headers: defaultHeaders);
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (json['message'] == 'success') {
        return json['data']['success'] ?? 'success';
      } else if (json['errors'] != null) {
        throw json['errors'].values.first.first;
      } else {
        return json;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<RegistrationCountry>> getCountries() async {
    try {
      final Uri uri = Uri.parse(apiLinks.countries);
      final response = await apiClient.post(uri, headers: defaultHeaders);
      final json = jsonDecode(response.body);
      if (json != null && json is List) {
        final List<RegistrationCountry> list = [];
        json.forEach((element) {
          list.add(RegistrationCountry.fromMap(element as Map<String, dynamic>));
        });
        return list;
      } else if (json['errors'] != null) {
        throw json['errors'].values.first.first;
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<List<RegistrationState>> getStates(int countryId) async {
    try {
      final Uri uri = Uri.parse(apiLinks.states);
      final response = await apiClient.post(uri,
          body: jsonEncode({'country': countryId}), headers: defaultHeaders);
      final json = jsonDecode(response.body);
      if (json != null && json is List) {
        final List<RegistrationState> list = [];
        json.forEach((element) {
          list.add(RegistrationState.fromMap(element as Map<String, dynamic>));
        });
        return list;
      } else if (json['errors'] != null) {
        throw json['errors'].values.first.first;
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }
}
