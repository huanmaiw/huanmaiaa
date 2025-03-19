import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
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
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Nạp Thẻ'),
              Tab(text: 'Doanh Thu'),
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

            // Trang Doanh Thu (Giao diện đẹp hơn)
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('top_up_history').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("Chưa có giao dịch nào"));
                }

                // Tính tổng tiền nạp
                double totalRevenue = snapshot.data!.docs
                    .where((doc) => doc['status'] == 'Thành công') // Chỉ tính giao dịch thành công
                    .fold(0, (sum, doc) => sum + (doc['amount'] as num));

                // Danh sách giao dịch thành công
                var successfulTransactions = snapshot.data!.docs
                    .where((doc) => doc['status'] == 'Thành công')
                    .toList();

                return Column(
                  children: [
                    // Card Hiển thị tổng doanh thu
                    Card(
                      margin: EdgeInsets.all(16),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            const Text(
                              'Tổng Doanh Thu',
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${NumberFormat("#,###").format(totalRevenue)} VND',
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Chi tiết giao dịch',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    Expanded(
                      child: ListView.builder(
                        itemCount: successfulTransactions.length,
                        itemBuilder: (context, index) {
                          var data = successfulTransactions[index].data() as Map<String, dynamic>;
                          return Card(
                            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue.shade100,
                                child: Icon(Icons.attach_money, color: Colors.blue),
                              ),
                              title: Text(
                                '${data['telcoProvider']} - ${NumberFormat("#,###").format(data['amount'])} VND',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                'Ngày: ${DateFormat('dd/MM/yyyy HH:mm').format((data['date'] as Timestamp).toDate())}',
                                style: TextStyle(color: Colors.grey),
                              ),
                              trailing: Text(
                                data['status'],
                                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
