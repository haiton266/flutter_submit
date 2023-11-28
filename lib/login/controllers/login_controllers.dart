import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginController {
  Future<bool> loginUser(String email, String password) async {
    final String apiUrl = 'https://haiton26062.pythonanywhere.com/user/login';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      final responseData = jsonDecode(response.body);
      prefs.setString('phone', responseData['phone'].toString());
      prefs.setString('address', responseData['address'].toString());
      prefs.setString('email', responseData['email'].toString());
      prefs.setString('username', responseData['username'].toString());
      prefs.setString('id', responseData['id'].toString());
      prefs.setString('token', responseData['access_token'].toString());
      return true;
    } else {
      print('Failed to post data. Error code: ${response.statusCode}');
      return false;
    }
  }
}
