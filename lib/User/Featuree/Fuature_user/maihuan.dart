import 'package:flutter/material.dart';
class Maihuan extends StatelessWidget {
  const Maihuan({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(""),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          child: Column(
            children: [
              const Text(
                "Thông tin liên hệ\n"
                    "FaceBook : Kiệu Mai Huấn \n"
                    "Zalo 0393433084\n",
                style: TextStyle(fontSize: 18),
              ),
              const Text(
                "Link FB : https://www.facebook.com/profile.php?id=61560768990877", // Hiển thị liên kết Facebook
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blue,
                  decoration: TextDecoration.underline, // Gạch chân liên kết
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}