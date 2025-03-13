import 'package:flutter/material.dart';

class TopUpTransaction {
  final DateTime dateTime;
  final double amount;
  final String cardType; // Thêm trường loại thẻ
  final String status;

  TopUpTransaction({
    required this.dateTime,
    required this.amount,
    required this.cardType, // Khởi tạo trường loại thẻ
    required this.status,
  });
}

class TopUpHistoryProvider with ChangeNotifier {
  final List<TopUpTransaction> _transactions = [];

  List<TopUpTransaction> get transactions => _transactions;

  void addTransaction(TopUpTransaction transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }
}