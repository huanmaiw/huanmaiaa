import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

// Hàm tạo mật khẩu ngẫu nhiên
String generateRandomPassword() {
  const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  Random rnd = Random();
  return String.fromCharCodes(Iterable.generate(
      12, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
}

// Hàm gửi email (cần tùy chỉnh theo dịch vụ email)
Future<void> sendEmail(String email, String newPassword, String apiKey) async {
  final url = Uri.parse('YOUR_SENDGRID_API_ENDPOINT'); // Thay thế bằng endpoint của dịch vụ bạn dùng
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey',
  };
  final body = jsonEncode({
    'to': email,
    'subject': 'Mật khẩu mới của bạn',
    'content': 'Mật khẩu mới của bạn là: $newPassword',
  });

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    print('Email đã được gửi thành công');
  } else {
    print('Lỗi khi gửi email: ${response.body}');
  }
}

// Hàm lấy lại mật khẩu
Future<void> resetPassword(String email, String apiKey) async {
  try {
    // 1. Tạo mật khẩu mới ngẫu nhiên
    String newPassword = generateRandomPassword();

    // 2. Cập nhật mật khẩu trên Firebase Authentication
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

    // 3. Gửi email chứa mật khẩu mới
    await sendEmail(email, newPassword, apiKey);

    print('Mật khẩu đã được đặt lại và gửi về email');
  } catch (error) {
    print('Lỗi khi đặt lại mật khẩu: $error');
  }
}