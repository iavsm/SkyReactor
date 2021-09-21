import 'package:copy_trading/api/core/api_core.dart';
import 'package:copy_trading/locator/locator.dart';
import 'package:copy_trading/models/user_profile.dart';

import 'core/api_links.dart';

mixin UserApi on ApiCore {
  final ApiLinks apiLinks = locator<ApiLinks>();
  Future<UserProfile> fetchUserInfo() async {
    try {
      final Uri uri = Uri.parse(apiLinks.profile);
      final response = await apiClient.post(
        uri,
        headers: authHeaders,
      );
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (json['details'] != null) {
        return UserProfile.fromMap(json);
      } else if (json['errors'] != null) {
        throw json['errors'].values.first.first;
      } else {
        throw 'Error in UserAPI - Response: $json';
      }
    } catch (e) {
      rethrow;
    }
  }
}
