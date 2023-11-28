import 'package:flutter/material.dart';
import 'package:flutter_application_1/login/views/LoginPage.dart';
import 'package:flutter_application_1/navigation/ui/pages/content_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token != null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Named Routes Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => FutureBuilder<bool>(
              future: isLoggedIn(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (snapshot.hasData && snapshot.data == true) {
                  return ContentPage();
                } else {
                  return LoginPage();
                }
              },
            ),
        '/second': (context) => FutureBuilder<bool>(
              future: isLoggedIn(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (snapshot.hasData && snapshot.data == true) {
                  return ContentPage(); // Changed from HomePage to ContentPage
                } else {
                  return LoginPage();
                }
              },
            ),
      },
    );
  }
}
