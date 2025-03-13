import 'package:flutter/material.dart';
class BankMain extends StatefulWidget {
  const BankMain({super.key});

  @override
  State<BankMain> createState() => _BankMainState();
}

class _BankMainState extends State<BankMain> {
  final List<CardRecharge>  _cardRecharges = [
    CardRecharge(
        id: '1',
        telcoProvider: 'Viettel',
        amount: 100000,
        status: 'Thành Công',
        date: DateTime.now()
    ),
    CardRecharge(
        id: '2',
        telcoProvider: 'Mobifone',
        amount: 50000,
        status: 'Thành Công',
        date: DateTime.now().subtract(Duration(days: 1))
    ),
  ];

  final List<MoneyTransfer> _moneyTransfers = [
    MoneyTransfer(
        id: '1',
        recipientName: 'Nguyễn Văn A',
        bankName: 'Vietcombank',
        amount: 500000,
        status: 'Thành Công',
        date: DateTime.now()
    ),
    MoneyTransfer(
        id: '2',
        recipientName: 'Trần Thị B',
        bankName: 'BIDV',
        amount: 300000,
        status: 'Thành Công',
        date: DateTime.now().subtract(Duration(days: 2))
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Quản Lý Ngân Hàng'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Nạp Thẻ'),
              Tab(text: 'Chuyển Khoản'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Trang Nạp Thẻ
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _cardRecharges.length,
                    itemBuilder: (context, index) {
                      final recharge = _cardRecharges[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.green.shade100,
                          child: Icon(Icons.phone_android, color: Colors.green),
                        ),
                        title: Text(recharge.telcoProvider),
                        subtitle: Text('${recharge.amount.toString()} VND'),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              recharge.status,
                              style: TextStyle(
                                color: recharge.status == 'Thành Công'
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            Text(
                              '${recharge.date.day}/${recharge.date.month}/${recharge.date.year}',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _moneyTransfers.length,
                    itemBuilder: (context, index) {
                      final transfer = _moneyTransfers[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: Icon(Icons.account_balance, color: Colors.blue),
                        ),
                        title: Text(transfer.recipientName),
                        subtitle: Text(transfer.bankName),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${transfer.amount.toString()} VND',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              transfer.status,
                              style: TextStyle(
                                color: transfer.status == 'Thành Công'
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            Text(
                              '${transfer.date.day}/${transfer.date.month}/${transfer.date.year}',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CardRecharge {
  final String id;
  final String telcoProvider;
  final int amount;
  final String status;
  final DateTime date;

  CardRecharge({
    required this.id,
    required this.telcoProvider,
    required this.amount,
    required this.status,
    required this.date,
  });
}

class MoneyTransfer {
  final String id;
  final String recipientName;
  final String bankName;
  final int amount;
  final String status;
  final DateTime date;

  MoneyTransfer({
    required this.id,
    required this.recipientName,
    required this.bankName,
    required this.amount,
    required this.status,
    required this.date,
  });
}