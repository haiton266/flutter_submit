import 'package:flutter/material.dart';
import 'ChangePasswordModal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'manageFile.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purple[50],
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          ProfileState(),
          Positioned(
            top: 110,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.purple, width: 4), // Thêm viền màu tím
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 60, // Tăng kích thước của ảnh
                backgroundImage: AssetImage('assets/images/anhdangnhap.jpg'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileState extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfileState> {
  bool isLoading = true; // Thêm biến isLoading vào _ProfileState
  String email = '';
  String phoneNumber = '';
  String username = '';
  String address = '';
  String uploadedFiles = '';
  var manageList = [];

  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email') ?? '';
      phoneNumber = prefs.getString('phone') ?? '';
      username = prefs.getString('username') ?? '';
      address = prefs.getString('address') ?? '';
    });

    final response = await http
        .get(Uri.parse('https://haiton26062.pythonanywhere.com/image/all'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var filteredList = data
          .where((x) => x['username'] == prefs.getString('username'))
          .toList();
      setState(() {
        uploadedFiles = 'Đã upload ${filteredList.length} files';
        isLoading =
            false; // Khi dữ liệu đã được tải hoàn tất, isLoading = false
        manageList = filteredList;
      });
    } else {
      print('Error GET');
      setState(() {
        isLoading =
            false; // Khi gặp lỗi, isLoading = false để ngừng hiển thị quay tròn chờ loading
      });
    }
  }

  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    prefs.remove('username');
    prefs.remove('address');
    prefs.remove('phone');
    prefs.remove('id');
    prefs.remove('token');

    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> _showLogoutConfirmation(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận đăng xuất'),
          content: Text('Bạn có chắc chắn muốn đăng xuất ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _logout(context);
              },
              child: Text('Đăng xuất'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hủy'),
            ),
          ],
        );
      },
    );
  }

  // @override
  // void initState() {
  //   super.initState();
  //   fetchUserData();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      body: Center(
        child: isLoading
            ? CircularProgressIndicator() // Hiển thị quay tròn chờ loading nếu đang tải dữ liệu
            : Container(
                height: 450.0,
                width: 300.0,
                padding: EdgeInsets.fromLTRB(41, 41, 41, 25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Column(
                        children: [
                          Text(
                            '$username',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(uploadedFiles),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 41,
                      width: 200,
                      padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2), // Thêm padding bên trong Container
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Email:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('$email'),
                          ]),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 41,
                      width: 200,
                      padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2), // Thêm padding bên trong Container
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Số điện thoại:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('$phoneNumber'),
                          ]),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 41,
                      width: 200,
                      padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2), // Thêm padding bên trong Container
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Địa chỉ: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('$address'),
                          ]),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ChangePasswordModal();
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side:
                                  BorderSide(color: Colors.purple, width: 2.0),
                            ),
                            primary: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            minimumSize: Size(35.0, 25.0),
                          ),
                          child: Text(
                            'Đổi mật khẩu',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _showLogoutConfirmation(context);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side:
                                  BorderSide(color: Colors.purple, width: 2.0),
                            ),
                            primary: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            minimumSize: Size(35.0, 25.0),
                          ),
                          child: Text(
                            'Đăng xuất',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Chuyển sang trang manageFile khi nút được nhấn
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => manageFile(
                                    manageList)), // Thay 'ManageFilePage' bằng tên trang bạn muốn chuyển đến
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: BorderSide(color: Colors.purple, width: 2.0),
                          ),
                          primary: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          minimumSize: Size(35.0, 25.0),
                        ),
                        child: Text(
                          'Quản lý file của bạn',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
