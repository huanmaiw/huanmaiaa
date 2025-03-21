import 'dart:async';
import 'package:flutter/material.dart';
import 'Firebase/auth_service.dart';
import 'User/Accountz/login_user.dart';
import 'drawers.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => _getHomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red, // Đổi màu nền theo ý bạn
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           // Icon(Icons.music_note, size: 80, color: Colors.white), // Icon logo
           CircleAvatar(
             radius: 150,
               backgroundImage: AssetImage(
                 "images/goku.webp",
               ),
               backgroundColor: Colors.transparent,
           ),
            SizedBox(height: 20),
            Text(
              "Shop Nick Huan Mai",
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
   Widget _getHomeScreen() {
  if (AuthService().currentUser != null) {
    return Drawers();
  } else {
    return LoginScreen();
  }
}
}
