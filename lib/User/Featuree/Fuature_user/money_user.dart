import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Provider/balence.dart';
import '../Provider/top_up.dart';

class Napcard extends StatefulWidget {
  const Napcard({Key? key}) : super(key: key);
  @override
  State<Napcard> createState() => _NapcardState();
}

class _NapcardState extends State<Napcard> {
  String? selectedValue;
  String? selectedValue1;
  List<String> items = ['Viettel', 'Vinaphone', 'Mobifone', 'Vietnamobile'];
  List<String> itemss = ['10000', '20000', '50000', '100000', '200000', '500000'];
  final _serialController = TextEditingController();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _serialController.dispose();
    _codeController.dispose();
    super.dispose();
  }


  Future<void> _handleTopUp(BuildContext context) async {
    final balanceProvider = Provider.of<BalanceProvider>(context, listen: false);
    final topUpHistoryProvider = Provider.of<TopUpHistoryProvider>(context, listen: false);

    if (selectedValue == null || selectedValue1 == null ||
        _serialController.text.isEmpty || _codeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin')),
      );
      return;
    }

    String apiUrl = 'https://thesieure.com/api/napthe';
    String apiKey = '08ae9b5e16006e6edf743470e44dc995';

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'telco': selectedValue,
          'amount': selectedValue1,
          'serial': _serialController.text,
          'code': _codeController.text,
          'api_key': apiKey,
        }),
      );

      var data = jsonDecode(response.body);

      // Xử lý khi nạp thành công
      if (data['status'] == 'success') {
        double topUpAmount = double.parse(selectedValue1!);
        String userId = "user123"; // Lấy ID người dùng thực tế

        // Cập nhật số dư Firestore
        DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(userId);
        DocumentSnapshot userSnapshot = await userRef.get();
        double currentBalance = userSnapshot.exists ? (userSnapshot['balance'] ?? 0).toDouble() : 0;
        double newBalance = currentBalance + topUpAmount;
        await userRef.set({'balance': newBalance}, SetOptions(merge: true));
        balanceProvider.updateBalance(newBalance);

        // Lưu lịch sử giao dịch
        await FirebaseFirestore.instance.collection('top_up_history').add({
          'userId': userId,
          'amount': topUpAmount,
          'telcoProvider': selectedValue,
          'serial': _serialController.text,
          'code': _codeController.text,
          'status': 'Thành công',
          'date': Timestamp.now(),
        });

        topUpHistoryProvider.addTransaction(
          TopUpTransaction(
            dateTime: DateTime.now(),
            amount: topUpAmount,
            cardType: selectedValue ?? '',
            status: 'Thành công',
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎉 Nạp thẻ thành công! Số tiền đã được cộng vào tài khoản.'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Xử lý khi nạp thất bại
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(' Lỗi: ${data['message']}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      // Xử lý lỗi kết nối hoặc lỗi khác
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập đúng mã thẻ và seri!',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                DropdownButton<String>(
                  value: selectedValue,
                  hint: const Text('-Chọn loại thẻ-'),
                  items: items.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue;
                    });
                  },
                ),
                DropdownButton<String>(
                  value: selectedValue1,
                  hint: const Text('-Chọn mệnh giá-'),
                  items: itemss.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue1 = newValue;
                    });
                  },
                ),
                TextFormField(
                  controller: _serialController,
                  decoration: const InputDecoration(
                    hintText: "Nhập serial thẻ",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _codeController,
                  decoration: const InputDecoration(
                    hintText: "Nhập mã thẻ",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () => _handleTopUp(context),
                  child: const Text("Nạp thẻ"),
                ),
                Image.asset("images/tech.jpg"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}