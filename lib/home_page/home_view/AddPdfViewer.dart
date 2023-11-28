import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_application_1/home_page/home_view/Alert.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddPdfViewer extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("add"));
  }

  @override
  _AddPdfViewerState createState() => _AddPdfViewerState();
}

class _AddPdfViewerState extends State<AddPdfViewer> {
  File? _selectedFile;
  String _pdfName = '';
  String _selectedSubject = "Lập trình";
  String _selectedSchool = "BKDN";

  Future<void> _uploadPdf(File? file) async {
    final prefs = await SharedPreferences.getInstance();
    if (file != null) {
      final url = Uri.parse('https://haiton26062.pythonanywhere.com/image/add');
      final request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath('image', file.path));
      request.fields['school'] = _selectedSchool;
      request.fields['name'] = _pdfName;
      request.fields['type'] = _selectedSubject;
      request.fields['username'] = prefs.getString('username') ?? '';
      try {
        final streamedResponse = await request.send();
        if (streamedResponse.statusCode == 200) {
          print('PDF uploaded successfully!');
          showNotificationDialog(
            context,
            title: "Success",
            message: "File PDF đã được tải lên thành công",
            isSuccess: true,
          );
        }
        if (streamedResponse.statusCode != 200) {
          print('Tải lên thất bại . mã lỗi: ${streamedResponse.statusCode}');
          showNotificationDialog(
            context,
            title: "Failure",
            message: "Tải lên thất bại. mã lỗi: ${streamedResponse.statusCode}",
            isSuccess: false,
          );
        }
      } catch (e) {
        // Error uploading PDF, show error message
        print('Error uploading PDF: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi tải : $e'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } else {
      // No PDF selected, show message
      print('No PDF selected');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Khồng có PDF được chọn'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thêm file PDF',
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
      body: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          // Add this
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 2.0), // Padding cho cả hai chiều
                      child: Text(
                        'Tên file',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 55,
                      // width: 300,
                      child: TextField(
                        onChanged: (value) {
                          _pdfName = value;
                        },
                        decoration: InputDecoration(
                          // labelText: 'Tên file',
                          hintText: 'Thêm tên file',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 2.0), // Padding cho cả hai chiều
                      child: Text(
                        'Trường',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 55,
                      // width: 300,
                      child: TextField(
                        onChanged: (value) {
                          _selectedSchool = value;
                        },
                        decoration: InputDecoration(
                          // labelText: 'Trường',
                          hintText: 'Thêm trường của bạn',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Dropdown chọn môn học
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 2.0), // Padding cho cả hai chiều
                    child: Text(
                      'Môn học',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Center(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey, // Màu viền
                                width: 1.0, // Độ rộng của viền
                              ),
                              borderRadius: BorderRadius.circular(
                                  5.0), // Độ bo cong của viền
                            ),
                            // child: Text('Môn học'),
                            child: DropdownButtonFormField(
                              isExpanded: true,
                              value: _selectedSubject,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    left: 10.0,
                                    right: 16.0), // Thêm padding ngang
                                // Các thiết lập khác cho InputDecoration nếu cần
                              ),
                              items: <String>[
                                'Lập trình',
                                'Giải tích',
                                'Vật lý',
                                'Nhúng',
                                'Viễn Thông',
                                'Điện tử'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedSubject = value!;
                                });
                              },
                            ));
                      },
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 2.0), // Đặt giá trị padding dọc ở đây
                child: Text(
                  'Tải lên file của bạn',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: GestureDetector(
                    onTap: () {
                      _pickPDF(
                          context); // Khi nhấp vào hình ảnh, mở cửa sổ chọn file
                    },
                    child: Image.asset('assets/images/upload.jpg', width: 320
                        // Các thuộc tính khác của hình ảnh có thể được điều chỉnh tại đây
                        ),
                  ),
                ),
              ),
              Center(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    if (_selectedFile != null)
                      Text(
                        'PDF đã chọn: ${_selectedFile!.path.split('/').last}',
                        style: TextStyle(fontSize: 16),
                      ),
                    // SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_selectedFile != null) {
                          _uploadPdf(_selectedFile);
                        } else {
                          print('No PDF selected');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors
                            .purple, // Đây là nơi bạn đặt màu cho nút (màu tím là Colors.purple)
                      ),
                      child: Text('Tải lên'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickPDF(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedFile = File(result.files.first.path!);
        });
        // Show SnackBar after selecting a file
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('PDF selected: ${_selectedFile!.path.split('/').last}'),
            duration: Duration(seconds: 2), // Thời gian hiển thị SnackBar
          ),
        );
      } else {
        print('No file selected');
      }
    } catch (e) {
      print('Error picking PDF: $e');
    }
  }
}
