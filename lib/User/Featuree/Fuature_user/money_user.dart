import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  List<String> itemss = ['10.000', '20.000', '50.000', '100.000', '200.000', '500.000'];
  final _serialController = TextEditingController();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _serialController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _handleTopUp(BuildContext context) async {
    final balanceProvider = Provider.of<BalanceProvider>(context, listen: false);
    final topUpHistoryProvider = Provider.of<TopUpHistoryProvider>(context, listen: false);

    String selectedAmount = selectedValue1 ?? '';
    double topUpAmount = double.tryParse(selectedAmount.replaceAll('.', '')) ?? 0;

    if (topUpAmount > 0) {
      String userId = "user123";

      // Lấy số dư hiện tại từ Firestore
      DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(userId);
      DocumentSnapshot userSnapshot = await userRef.get();

      double currentBalance = userSnapshot.exists ? (userSnapshot['balance'] ?? 0).toDouble() : 0;
      double newBalance = currentBalance + topUpAmount;
      await userRef.set({'balance': newBalance}, SetOptions(merge: true));
      balanceProvider.updateBalance(newBalance);
      await FirebaseFirestore.instance.collection('top_up_history').add({
        'userId': 'user123',
        'amount': topUpAmount,
        'telcoProvider': selectedValue,
        'serial': _serialController.text,
        'code': _codeController.text,
        'status': 'Thành công',
        'date': Timestamp.now(),
      });

      // Cập nhật lịch sử trong ứng dụng
      topUpHistoryProvider.addTransaction(
        TopUpTransaction(
          dateTime: DateTime.now(),
          amount: topUpAmount,
          cardType: selectedValue ?? '',
          status: 'Thành công',
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nạp tiền thành công')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn mệnh giá thẻ')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
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
                  decoration:  InputDecoration(
                      hintText: "Nhập serial thẻ",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 5,),
                TextFormField(
                  controller: _codeController,
                  decoration:  InputDecoration(hintText: "Nhập mã thẻ",
                  border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10,),
                ElevatedButton(style: ElevatedButton.styleFrom(foregroundColor: Colors.white,backgroundColor: Colors.blue),
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
