import 'package:flutter/material.dart';
import 'package:maishop/User/Featuree/Provider/top_up.dart';

class BalanceProvider with ChangeNotifier {
  double _balance = 0; // Số dư ban đầu
  final TopUpHistoryProvider _topUpHistoryProvider = TopUpHistoryProvider();

  double get balance => _balance;
  TopUpHistoryProvider get topUpHistoryProvider => _topUpHistoryProvider;

  void updateBalance(double newBalance) {
    _balance = newBalance;
    notifyListeners();
  }

  void deductBalance(double amount) {
    _balance -= amount;
    notifyListeners();
  }
}