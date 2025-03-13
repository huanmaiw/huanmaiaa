import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BalanceProvider with ChangeNotifier {
  double _balance = 0;

  double get balance => _balance;

  // Lấy số dư từ Firestore
  Future<void> fetchBalance() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (userId.isEmpty) return;

    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userSnapshot.exists) {
      _balance = (userSnapshot['balance'] ?? 0).toDouble();
      notifyListeners();
    }
  }

  // Cập nhật số dư khi nạp tiền hoặc thanh toán
  void updateBalance(double newBalance) {
    _balance = newBalance;
    notifyListeners();
  }

  // Trừ tiền khi thanh toán
  void deductBalance(double amount) {
    if (_balance >= amount) {
      _balance -= amount;
      notifyListeners();
    }
  }
}
