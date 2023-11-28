import 'package:dio/dio.dart';
import 'package:flutter_application_1/sigup/models/models.dart';

class SigupController {
  final Dio _dio = Dio();

  Future<bool> registerUser(SignUpModel user) async {
    final String apiUrl =
        'https://haiton26062.pythonanywhere.com/user/register';

    try {
      final response = await _dio.post(
        apiUrl,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
        data: {
          'username': user.username,
          'password': user.password,
          'email': user.email,
          'address': user.address,
          'phone': user.phone,
        },
      );

      if (response.statusCode == 200) {
        // Registration successful
        return true;
      } else {
        // Registration failed
        print('Failed to register. Error code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Failed to register. Error: $e');
      return false;
    }
  }
}
