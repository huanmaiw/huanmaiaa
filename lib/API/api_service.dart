import 'dart:convert';
import 'package:http/http.dart' as http;
import 'account.dart';

class ApiService {
  static const String apiUrl = 'https://raw.githubusercontent.com/huanmaiw/my_json/main/account.json'; // Thay bằng link API của bạn

  Future<List<Account>> fetchAccounts() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Account.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load accounts');
    }
  }
}