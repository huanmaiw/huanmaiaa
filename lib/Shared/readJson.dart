import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;
import 'package:http/http.dart' as http;

Future<List<dynamic>> loadJsonData() async {
  final String jsonString = await rootBundle.rootBundle.loadString('images/account.json');
  final Map<String, dynamic> jsonData = json.decode(jsonString);
  return jsonData['acc']; // Trả về danh sách tài khoản
}

Future<List<dynamic>> fetchAccounts() async {
  final response = await http.get(Uri.parse('https://raw.githubusercontent.com/huanmaiw/my_json/main/account.json'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = json.decode(response.body);
    return jsonData['acc']; // Trả về danh sách tài khoản
  } else {
    throw Exception('Failed to load accounts');
  }
}
