import 'package:flutter/material.dart';
import 'package:flutter_application_1/home_page/home_view/Alert.dart';
import 'package:flutter_application_1/login/views/LoginPage.dart';
import 'package:flutter_application_1/sigup/controllers/SigupControlers.dart';
import 'package:flutter_application_1/sigup/models/models.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final SigupController controller = SigupController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isObscure = true; // Declare _isObscure here

  bool isEmailValid(String email) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    return emailValid;
  }

  bool isVietnamesePhoneNumber(String number) {
    // Kiểm tra số điện thoại có bắt đầu bằng +84 hoặc 0 và có 10 hoặc 11 chữ số
    RegExp regExp =
        RegExp(r'(^\+84[1-9]\d{8}$)|(^(09|03|07|08|05)+([0-9]{8})$)');
    return regExp.hasMatch(number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng ký'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên đăng nhập';
                  }
                  return null;
                },
              ),
              TextFormField(
                obscureText: _isObscure,
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.mail),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập địa chỉ email';
                  }
                  if (!isEmailValid(value)) {
                    return 'Vui lòng nhập đúng email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Địa chỉ',
                  prefixIcon: Icon(Icons.home),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập địa chỉ';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Số điện thoại',
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số điện thoai';
                  } else if (!isVietnamesePhoneNumber(value)) {
                    return 'Nhập đúng định dạng số điện thoại';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    SignUpModel user = SignUpModel(
                      username: _usernameController.text,
                      password: _passwordController.text,
                      email: _emailController.text,
                      address: _addressController.text,
                      phone: _phoneController.text,
                    );

                    bool signUpSuccess = await controller.registerUser(user);

                    if (signUpSuccess) {
                      // If sign-up is successful
                      showNotificationDialog(
                        context,
                        title: "Thành công",
                        message: "Đăng ký thành công.",
                        isSuccess: true,
                      );
                    } else {
                      // If sign-up fails
                      showNotificationDialog(
                        context,
                        title: "Đăng ký thất bại",
                        message: "Vui lòng thử lại .",
                        isSuccess: false,
                      );
                    }
                  }
                },
                child: Text('Đăng ký'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
