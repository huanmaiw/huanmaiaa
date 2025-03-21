import 'dart:math';
import 'package:flutter/material.dart';
import 'account.dart';
import 'api_service.dart';

class AccountProvider with ChangeNotifier {
  List<Account> _accounts = [];
  Account? _selectedAccount;

  List<Account> get accounts => _accounts;
  Account? get selectedAccount => _selectedAccount;

  final ApiService _apiService = ApiService();

  Future<void> loadAccounts() async {
    try {
      _accounts = await _apiService.fetchAccounts();
      notifyListeners();
    } catch (e) {
      print('Error loading accounts: $e');
    }
  }

  void processPayment() {
    if (_accounts.isNotEmpty) {
      final randomIndex = Random().nextInt(_accounts.length);
      _selectedAccount = _accounts[randomIndex];
      _accounts.removeAt(randomIndex); // Xóa tài khoản đã chọn
      notifyListeners();
    } else {
      _selectedAccount = null;
      notifyListeners();
    }
  }
}