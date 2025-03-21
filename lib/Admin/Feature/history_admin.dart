import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryMain extends StatefulWidget {
  const HistoryMain({super.key});

  @override
  State<HistoryMain> createState() => _HistoryMainState();
}

class _HistoryMainState extends State<HistoryMain> {
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
      appBar: AppBar(title: const Text('Lịch sử bán'),automaticallyImplyLeading: false,),
      body: purchaseHistory.isEmpty
          ? const Center(child: Text('Chưa có lịch sử bán'))
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
                  Text('📅 Ngày: ${account['date']}'),
                  Text('💰 Giá: ${account['price']}'),
                  Text('📦 Ghi chú: ${account['note']}'),
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
}}
