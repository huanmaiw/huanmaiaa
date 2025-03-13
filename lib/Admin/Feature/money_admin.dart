import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BankMain extends StatefulWidget {
  const BankMain({super.key});

  @override
  State<BankMain> createState() => _BankMainState();
}

class _BankMainState extends State<BankMain> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Quản Lý Ngân Hàng'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Nạp Thẻ'),
              Tab(text: 'Chuyển Khoản'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Trang Nạp Thẻ
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('top_up_history').orderBy('date', descending: true).snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("Chưa có giao dịch nào"));
                }
                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green.shade100,
                        child: const Icon(Icons.phone_android, color: Colors.green),
                      ),
                      title: Text('${data['telcoProvider']} - ${data['amount']} VND'),
                      subtitle: Text('Serial: ${data['serial']} - Mã: ${data['code']}'),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            data['status'],
                            style: TextStyle(
                              color: data['status'] == 'Thành công' ? Colors.green : Colors.red,
                            ),
                          ),
                          Text(
                            '${(data['date'] as Timestamp).toDate()}',
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            // Trang Chuyển Khoản (Chưa làm)
            const Center(child: Text("Chuyển khoản đang cập nhật...")),
          ],
        ),
      ),
    );
  }
}
