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
  List<String> items = [
    'Viettel',
    'Vinaphone',
    'Mobifone',
    'Vietnamoblie'
  ];
  List<String> itemss = [
    '10.000',
    '20.000',
    '50.000',
    '100.000',
    '200.000',
    '500.000'
  ];
  final _serialController = TextEditingController();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _serialController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _handleTopUp(BuildContext context) {
    // Lấy BalanceProvider và TopUpHistoryProvider từ context
    final balanceProvider = Provider.of<BalanceProvider>(context, listen: false);
    final topUpHistoryProvider = Provider.of<TopUpHistoryProvider>(context, listen: false);

    // Lấy mệnh giá thẻ từ selectedValue1
    String selectedAmount = selectedValue1 ?? '';
    double topUpAmount = 0;

    // Chuyển đổi mệnh giá thẻ thành số tiền
    if (selectedAmount.isNotEmpty) {
      topUpAmount = double.tryParse(selectedAmount.replaceAll('.', '')) ?? 0;
    }

    // Kiểm tra số tiền nạp có hợp lệ không
    if (topUpAmount > 0) {
      // Cộng tiền vào số dư
      balanceProvider.updateBalance(balanceProvider.balance + topUpAmount);

      // Thêm giao dịch vào lịch sử
      topUpHistoryProvider.addTransaction(
        TopUpTransaction(
          dateTime: DateTime.now(),
          amount: topUpAmount,
          cardType: selectedValue ?? '', // Truyền loại thẻ vào
          status: 'Thành công',
        ),
      );

      // Thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nạp tiền thành công')),
      );
    } else {
      // Thông báo thất bại
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
        title: const Text(''),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Loại thẻ ", style: TextStyle(fontSize: 18)),
                const SizedBox(height: 8.0),
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
                const SizedBox(height: 16.0),
                const Text("Mệnh giá: ", style: TextStyle(fontSize: 18)),
                const SizedBox(height: 8.0),
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
                const SizedBox(height: 16.0),
                const Text("Serial: ", style: TextStyle(fontSize: 18)),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _serialController,
                  decoration: const InputDecoration(
                    hintText: "Nhập seriel thẻ",
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text("Mã thẻ: ", style: TextStyle(fontSize: 18)),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _codeController,
                  decoration: const InputDecoration(
                    hintText: "Nhập mã thẻ",
                  ),
                ),
                const SizedBox(height: 15,),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title:const Text("Thông báo"),
                            content: const Text("Đang chờ xử lý..."),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _handleTopUp(context);
                                },
                                child: const Text("Đóng"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0), // Border radius
                      ),
                    ),
                    child: const Text("Nạp thẻ",style: TextStyle(color: Colors.white),),
                  ),
                ),
                const Text('Nạp qua ngân hàng'),
                Image.asset("images/tech.jpg", height: 500, width: 500,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}