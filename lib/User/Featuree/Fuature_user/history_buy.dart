

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PurchaseHistoryScreen extends StatefulWidget {
  const PurchaseHistoryScreen({Key? key}) : super(key: key);

  @override
  _PurchaseHistoryScreenState createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Lịch sử mua tài khoản game')),
        body: Center(child: Text("Bạn chưa đăng nhập!")),
      );
    }

    return Scaffold(
        appBar: AppBar(title: Text('Lịch sử mua tài khoản game')),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('user')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Lỗi: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('Chưa có giao dịch nào'));
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                var data = document.data() as Map<String, dynamic>;

                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text("Tài khoản: ${data['Tai khoan'] ?? 'Không có'}",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Mật khẩu: ${data['Mat khau'] ?? 'Không có'}"),

                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        )
    );
  }  }