import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../Shared/change_password.dart';
import '../../User/Accountz/login_user.dart';
import 'edit_info.dart';
class ProfileAdmin extends StatefulWidget {
  const ProfileAdmin({super.key});

  @override
  State<ProfileAdmin> createState() => _ProfileAdminState();
}
class _ProfileAdminState extends State<ProfileAdmin> {
  String _name = 'Admin Mai Huan';
  String _email = '482677';
  File? _image;
  bool isLoading = false;
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
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
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
            radius: 200,
            backgroundImage: _image != null
                ? FileImage(_image!)
                : AssetImage('images/category/cate1.png') as ImageProvider,
          ),
        ),
        SizedBox(height: 15),
        Center(
          child: Text(
            _name,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Center(
          child: Text("ID:${_email}",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        SizedBox(height: 20),

        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green,foregroundColor: Colors.white),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_)=>ChangePasswordScreen()));
          },
          child: Text('Thay Đổi Mật Khẩu'),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditProfileScreen()),
            );

            if (result != null) {
              setState(() {
                _name = result['name'] ?? _name;
                _email = result['email'] ?? _email;
                _image = result['image'] ?? _image;
              });
            }
          },
          child: Text('Sửa thông tin'),
        ),

        SizedBox(height: 10),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red,foregroundColor: Colors.white),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_)=>LoginScreen()));
          },
          child: Text('Đăng xuất'),
        ),
      ],
    );
  }
}
