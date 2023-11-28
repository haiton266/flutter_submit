import 'package:flutter/material.dart';
// import 'package:login_test/Profile.dart';
import 'Subject.dart';

import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  Widget build(BuildContext context) {
    return const Center(child: Text("Home"));
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<String> username;

  @override
  void initState() {
    super.initState();
    username = getUsername();
  }

  Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? '';
  }

  final Sbj = [
    {
      'code': 'giaitich',
      'text': 'Giải tích',
      'image': 'assets/images/giaitich.png'
    },
    {
      'code': 'laptrinh',
      'text': 'Lập trình',
      'image': 'assets/images/laptrinh.png'
    },
    {'code': 'dientu', 'text': 'Điện tử', 'image': 'assets/images/dientu.png'},
    {'code': 'vatly', 'text': 'Vật lý', 'image': 'assets/images/vatly.png'},
    {
      'code': 'vienthong',
      'text': 'Viễn thông',
      'image': 'assets/images/vienthong.png'
    },
    {'code': 'nhung', 'text': 'Nhúng', 'image': 'assets/images/nhung.png'}
  ];

  // int _currentIndex = 0;

  // final List<Widget> _destinations = [
  //   HomePage(),
  //   AddPdfViewer(),
  //   Profile(),
  // ];

  Future<String> getUsernameFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userName = prefs.getString('username') ?? '';
    setState(() {
      username = Future.value(userName);
    });
    return userName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String>(
        future: username,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return buildHomePage(snapshot.data);
          }
        },
      ),
    );
  }

  Widget buildHomePage(String? username) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(10, 25, 10, 10),
          child: Stack(
            children: <Widget>[
              Image.asset('assets/images/hello.png'),
              Positioned(
                top: 45,
                left: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ignore: prefer_const_constructors
                    Text(
                      'Xin chào',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      username ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Text(
          "Các môn hiện có",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 10),
        Expanded(
          child: GridView.count(
            padding: const EdgeInsets.all(10),
            crossAxisCount: 2,
            children: List.generate(Sbj.length, (index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Subject(
                        Sbj[index]['code']!,
                        Sbj[index]['text']!,
                        Sbj[index]['image']!,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        Sbj[index]['image']!,
                        height: 115,
                      ),
                      SizedBox(height: 10),
                      Text(
                        Sbj[index]['text']!,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
// Other methods...
}
