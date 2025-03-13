import 'package:flutter/material.dart';
import '../../Shared/change_password.dart';
import '../../User/Accountz/login_user.dart';
import '../../Shared/pick_image.dart';
class ProfileAdmin extends StatefulWidget {
  const ProfileAdmin({super.key});

  @override
  State<ProfileAdmin> createState() => _ProfileAdminState();
}

class _ProfileAdminState extends State<ProfileAdmin> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        CircleAvatar(
          radius: 75,
          backgroundColor: Colors.blue,
          child: AccountPage(),
        ),
        SizedBox(height: 15),
        Center(
          child: Text(
            'Admin Mai Huan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 20),

        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red,foregroundColor: Colors.white),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_)=>ChangePasswordScreen()));
          },
          child: Text('Thay Đổi Mật Khẩu'),
        ),
        SizedBox(height: 10),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red,foregroundColor: Colors.white),
          onPressed: () {

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
