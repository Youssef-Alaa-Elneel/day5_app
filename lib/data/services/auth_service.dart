import 'package:day5_app/data/api/Loginapi.dart';

class AuthService {
  final ApiClient _api = ApiClient();

  Future<Map<String, dynamic>?> login(String username, String password) async {
    final response = await _api.postUser('/auth/login', {
      "username": username,
      "password": password,
    });

    if (response.statusCode == 200) {
      return response.data;
    }

    return null;
  }
}
