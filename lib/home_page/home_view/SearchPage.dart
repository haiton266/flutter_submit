import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'CommentPage.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _data = []; // List để lưu trữ dữ liệu từ API

  Future<void> fetchData() async {
    var response = await http.get(Uri.parse('https://haiton26062.pythonanywhere.com/image/all'));
    if (response.statusCode == 200) {
      setState(() {
        _data = jsonDecode(response.body);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData(); // Gọi hàm để lấy dữ liệu từ API khi trang được tạo
  }
  String removeDiacritics(String input) {
    return input.replaceAll(RegExp(r'[àáạảãâầấậẩẫăằắặẳẵ]'), 'a')
        .replaceAll(RegExp(r'[èéẹẻẽêềếệểễ]'), 'e')
        .replaceAll(RegExp(r'[ìíịỉĩ]'), 'i')
        .replaceAll(RegExp(r'[òóọỏõôồốộổỗơờớợởỡ]'), 'o')
        .replaceAll(RegExp(r'[ùúụủũưừứựửữ]'), 'u')
        .replaceAll(RegExp(r'[ỳýỵỷỹ]'), 'y')
        .replaceAll(RegExp(r'[đ]'), 'd')
        .replaceAll(RegExp(r'[ÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴ]'), 'A')
        .replaceAll(RegExp(r'[ÈÉẸẺẼÊỀẾỆỂỄ]'), 'E')
        .replaceAll(RegExp(r'[ÌÍỊỈĨ]'), 'I')
        .replaceAll(RegExp(r'[ÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠ]'), 'O')
        .replaceAll(RegExp(r'[ÙÚỤỦŨƯỪỨỰỬỮ]'), 'U')
        .replaceAll(RegExp(r'[ỲÝỴỶỸ]'), 'Y')
        .replaceAll(RegExp(r'[Đ]'), 'D');
  }

  List<dynamic> _searchResults(String query) {
    String formattedQuery = removeDiacritics(query.toLowerCase());

    return _data.where((item) {
      String formattedName = removeDiacritics(item['name'].toString().toLowerCase());
      return formattedName.contains(formattedQuery);
    }).toList();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 50, 20),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.purple, // Thay đổi màu tím ở đây
                  ),
                  hintText: 'Nhập để tìm kiếm...',
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _searchController.text.isEmpty ? _data.length : _searchResults(_searchController.text).length,
                itemBuilder: (context, index) {
                  final List<dynamic> searchData = _searchController.text.isEmpty
                      ? _data
                      : _searchResults(_searchController.text);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CommentPage(searchData[index]['id']),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/images/pdf.png', // Replace with your icon image path
                                  width: 52,
                                  height: 52,
                                ),
                                SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      searchData[index]['name'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      searchData[index]['school'],
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}