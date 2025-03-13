import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chỉnh sửa thông tin')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Ảnh đại diện
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Wrap(
                      children: [
                        ListTile(
                          leading: Icon(Icons.photo),
                          title: Text('Chọn từ thư viện'),
                          onTap: () {
                            Navigator.pop(context);
                            _pickImage(ImageSource.gallery);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.camera),
                          title: Text('Chụp ảnh'),
                          onTap: () {
                            Navigator.pop(context);
                            _pickImage(ImageSource.camera);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: CircleAvatar(
                radius: 40,
                backgroundImage: _image != null
                    ? FileImage(_image!)
                    : AssetImage('images/category/fr0.jpg') as ImageProvider,
              ),
            ),
            SizedBox(height: 20),

            // Nhập tên
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Tên',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),

            // Nhập email
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'ID Người Dùng',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Nút Lưu
            ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
              onPressed: () {
                String newName = _nameController.text;
                String newEmail = _emailController.text;

                Navigator.pop(context, {'name': newName, 'email': newEmail, 'image': _image});
              },
              child: Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }
}
