import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../drawers.dart';

class OrderSuccessScreen2 extends StatefulWidget {
  const OrderSuccessScreen2({super.key});

  @override
  _OrderSuccessScreen2State createState() => _OrderSuccessScreen2State();
}

class _OrderSuccessScreen2State extends State<OrderSuccessScreen2> {
  Map<String, dynamic>? purchasedAccount;
  String? errorMessage;
  Future<void> saveToPurchaseHistory(Map<String, dynamic> account) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('purchase_history') ?? [];

    // Chuyển Map thành JSON string để lưu
    history.add(json.encode(account));

    await prefs.setStringList('purchase_history', history);
  }

  Future<void> buyNow() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> history = prefs.getStringList('purchase_history') ?? [];

      final response = await http.get(
        Uri.parse('https://raw.githubusercontent.com/huanmaiw/my_json/main/account.json'),
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData is Map<String, dynamic> && jsonData.containsKey('acc')) {
          var accountList = jsonData['acc'];

          if (accountList is List && accountList.isNotEmpty) {
            // Lọc ra danh sách tài khoản chưa từng mua
            List<Map<String, dynamic>> availableAccounts = accountList
                .map((e) => e as Map<String, dynamic>)
                .where((account) => !history.contains(json.encode(account)))
                .toList();

            if (availableAccounts.isNotEmpty) {
              final randomAccount = (availableAccounts..shuffle()).first;

              setState(() {
                purchasedAccount = randomAccount;
              });

              await saveToPurchaseHistory(randomAccount);
            } else {
              throw Exception('Không còn tài khoản mới để mua.');
            }
          } else {
            throw Exception('Danh sách tài khoản trống hoặc không hợp lệ');
          }
        } else {
          throw Exception('Dữ liệu API không hợp lệ');
        }
      } else {
        throw Exception('Lỗi API: Không thể lấy dữ liệu (status: ${response.statusCode})');
      }
    } catch (e) {
      print('❌ Lỗi: $e');
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    buyNow(); // Gọi API khi vào màn hình

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: errorMessage != null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 50),
            const SizedBox(height: 10),
            Text(
              'Lỗi: $errorMessage',
              style: const TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        )
            : purchasedAccount == null
            ? const CircularProgressIndicator() // Hiển thị loading khi đang lấy tài khoản
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.green, size: 100),
            const SizedBox(height: 20),
            const Text(
              'Đơn hàng của bạn đã thanh toán thành công!',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(' Thông tin tài khoản', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text('💰 id: ${purchasedAccount?['id'] ?? 'Không có'}'),
                    Text('👤 User: ${purchasedAccount!['user']}'),
                    Text('🔑 Pass: ${purchasedAccount!['pass']}'),
                    IconButton(
                      icon: Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: purchasedAccount?['user'] ?? ''));
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đã sao chép tài khoản')));
                      },
                    ),

                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Drawers()),
                      (route) => false,
                );
              },
              child: const Text('Về trang chủ'),
            ),
          ],
        ),
      ),
    );
  }
}
