import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PurchaseHistoryScreen extends StatefulWidget {
  @override
  _PurchaseHistoryScreenState createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen> {
  List<Map<String, dynamic>> purchaseHistory = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('purchase_history') ?? [];

    setState(() {
      purchaseHistory = history
          .map((item) => json.decode(item) as Map<String, dynamic>)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lịch sử mua hàng')),
      body: purchaseHistory.isEmpty
          ? const Center(child: Text('Chưa có lịch sử mua hàng'))
          : ListView.builder(
        itemCount: purchaseHistory.length,
        itemBuilder: (context, index) {
          final account = purchaseHistory[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text('ID: ${account['id']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('👤 User: ${account['user']}'),
                  Text('🔑 Pass: ${account['pass']}'),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.copy),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: account['user']));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Đã sao chép tài khoản')),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
