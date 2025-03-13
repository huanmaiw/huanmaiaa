import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PurchaseHistoryScreen extends StatelessWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Lịch sử mua hàng")),
        body: const Center(
          child: Text("Bạn chưa đăng nhập! Hãy đăng nhập để xem lịch sử mua hàng."),
        ),
      );
    }

    String userId = user.uid;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Lịch sử mua hàng"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('history')
            .orderBy('purchaseDate', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Không có lịch sử mua hàng."));
          }

          var historyList = snapshot.data!.docs;

          return ListView.builder(
            itemCount: historyList.length,
            itemBuilder: (context, index) {
              var data = historyList[index];

              return Card(
                child: ListTile(
                  leading: const Icon(Icons.shopping_bag),
                  title: Text(data['productName']),
                  subtitle: Text("Giá: ${data['price']} VND"),
                  trailing: Text(
                    "${(data['purchaseDate'] as Timestamp).toDate()}",
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

}
