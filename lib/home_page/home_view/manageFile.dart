// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_application_1/home_page/home_view/Alert.dart';
import 'package:http/http.dart' as http;

import 'CommentPage.dart';

class manageFile extends StatefulWidget {
  final files;
  manageFile(this.files);

  @override
  _manageFileState createState() => _manageFileState(files);
}

class _manageFileState extends State<manageFile> {
  final files;
  _manageFileState(this.files);

  @override
  void initState() {
    super.initState();
    // fetchData(); // Gọi hàm lấy dữ liệu khi trang được tạo
  }

  Future<void> handleDelete(int id, int index) async {
    String url = 'https://haiton26062.pythonanywhere.com/image/delete/$id';

    try {
      var response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          files.removeAt(index); // Xóa file khỏi danh sách
        });
        showNotificationDialog(
          context,
          title: "Thành công",
          message: "File đã được xóa thành công!",
          isSuccess: true,
        );
      } else {
        showNotificationDialog(
          context,
          title: "Lỗi",
          message: "Lỗi khi xóa file: ${response.statusCode}",
          isSuccess: false,
        );
      }
    } catch (error) {
      showNotificationDialog(
        context,
        title: "Lỗi",
        message: "Lỗi khi thực hiện yêu cầu: $error",
        isSuccess: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quản lý file của bạn',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25, // Đặt kích thước chữ là 20
            fontWeight: FontWeight.bold, // Có thể thêm kiểu chữ in đậm nếu muốn
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true, // Đặt tiêu đề căn giữa
        elevation: 0, // Đặt độ nâng của AppBar là 0 để xóa gạch ngang phân cách
        iconTheme:
            IconThemeData(color: Colors.black), // Đặt màu của icon là đen
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Image.asset(
              'assets/images/manage.png', // Replace with your image path
              // width: 500, // Adjust width as needed
              height: 160, // Adjust height as needed
            ),
          ),
          Expanded(
            child: Container(
              child: ListView.builder(
                itemCount: files.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommentPage(files[index]['id']),
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
                                      files[index]['name'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      files[index]['school'],
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
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              await handleDelete(files[index]['id'],
                                  index); // Truyền index vào hàm handleDelete
                            },
                            tooltip: 'Delete',
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
