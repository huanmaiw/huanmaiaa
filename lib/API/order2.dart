import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../drawers.dart';

class OrderSuccessScreen2 extends StatefulWidget {
  const OrderSuccessScreen2({super.key});

  @override
  _OrderSuccessScreen2State createState() => _OrderSuccessScreen2State();
}

class _OrderSuccessScreen2State extends State<OrderSuccessScreen2> {
  Map<String, dynamic>? purchasedAccount;

  Future<void> buyNow() async {
    try {
      // 1️⃣ Gọi API để lấy tài khoản ngẫu nhiên
      final response = await http.get(Uri.parse('https://yourapi.com/get_account'));

      if (response.statusCode == 200) {
        var account = json.decode(response.body);

        // 2️⃣ Gửi thông tin đơn hàng lên API để lưu vào lịch sử
        await http.post(
          Uri.parse('https://yourapi.com/save_order'),
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            "user": account['user'],
            "pass": account['pass'],
            "price": account['price'],
            "time": DateTime.now().toIso8601String(),
          }),
        );

        // 3️⃣ Cập nhật state để hiển thị tài khoản đã mua
        setState(() {
          purchasedAccount = account;
        });
      } else {
        throw Exception('Không thể lấy tài khoản');
      }
    } catch (e) {
      print('Lỗi: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    buyNow(); // Gọi hàm mua ngay khi vào màn hình này
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: purchasedAccount == null
            ? const CircularProgressIndicator() // Hiển thị loading khi đang lấy tài khoản
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              'Đơn hàng của bạn đã được thanh toán thành công!',
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
                    Text('🔑 **Thông tin tài khoản:**',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text('👤 User: ${purchasedAccount!['user']}'),
                    Text('🔑 Pass: ${purchasedAccount!['pass']}'),
                    Text('💰 Giá: ${purchasedAccount!['price']} VND'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, foregroundColor: Colors.white),
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
