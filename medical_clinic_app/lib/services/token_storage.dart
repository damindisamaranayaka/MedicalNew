import 'package:shared_preferences/shared_preferences.dart';

/// Save the JWT token to local storage
Future<void> saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('jwt_token', token);
}

/// Retrieve the JWT token from local storage
Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('jwt_token');
}

/// Clear the stored JWT token
Future<void> clearToken() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('jwt_token');
}
