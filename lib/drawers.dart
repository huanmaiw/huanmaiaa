import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Shared/change_password.dart';
import 'Shared/pick_image.dart';
import 'User/Featuree/Favorite/favorite.dart';
import 'User/Featuree/Fuature_user/history_buy.dart';
import 'User/Featuree/Fuature_user/history_card.dart';
import 'User/Featuree/Fuature_user/home_user.dart';
import 'User/Featuree/Fuature_user/maihuan.dart';
import 'User/Featuree/Fuature_user/money_user.dart';
import 'User/Featuree/Fuature_user/policy.dart';
import 'User/Featuree/Provider/balence.dart';

class Drawers extends StatefulWidget {
  const Drawers({super.key});
  @override
  State<Drawers> createState() => _DrawersState();
}

class _DrawersState extends State<Drawers> {
  int currentIndex = 0;
  List<Widget> screens = const [
    HomeScreen(),
    Favorite(),
    Napcard(),
    PurchaseHistoryScreen(),
    TopUpHistoryScreen(),
    Maihuan(),
    Chinhsachbaomat(),
    ChangePasswordScreen(),
  ];

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Drawers()), // Thay thế LoginScreen() bằng màn hình đăng nhập của bạn
            (Route<dynamic> route) => false,
      );
    } catch (e) {
      print('Lỗi đăng xuất: $e');
    }
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận đăng xuất'),
          content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Không'),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
            ),
            TextButton(
              child: const Text('Có'),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
                _signOut(context); // Gọi hàm đăng xuất
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Welcome to Mai Shop'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 200,
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Mai',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'ID: 4826', // Replace with your ID
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Consumer<BalanceProvider>(
                          builder: (context, balanceProvider, child) {
                            return Text(
                              'Số tiền: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'VND', decimalDigits: 0).format(balanceProvider.balance)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 70,
                      //backgroundColor: Colors.blue,
                      child: AccountPage(),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Trang chủ'),
              onTap: () {
                setState(() {
                  currentIndex = 0;
                });
                Navigator.pop(context); // Close the drawer
              },
              selected: currentIndex == 0,
            ),
            ListTile(
              leading: const Icon(Icons.favorite_border),
              title: const Text('Yêu thích'),
              onTap: () {
                setState(() {
                  currentIndex = 1;
                });
                Navigator.pop(context); // Close the drawer
              },
              selected: currentIndex == 1,
            ),
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: const Text('Nạp tiền'),
              onTap: () {
                setState(() {
                  currentIndex = 2;
                });
                Navigator.pop(context); // Close the drawer
              },
              selected: currentIndex == 2,
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag),
              title: const Text('Lịch sử mua hàng'),
              onTap: () {
                setState(() {
                  currentIndex = 3;
                });
                Navigator.pop(context); // Close the drawer
              },
              selected: currentIndex == 3,
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Lịch sử nạp tiền'),
              onTap: () {
                setState(() {
                  currentIndex = 4;
                });
                Navigator.pop(context); // Close the drawer
              },
              selected: currentIndex == 4,
            ),
            ListTile(
              leading: const Icon(Icons.call),
              title: const Text('CSKH 24/7'),
              onTap: () {
                setState(() {
                  currentIndex = 5;
                });
                Navigator.pop(context); // Close the drawer
              },
              selected: currentIndex == 5,
            ),
            ListTile(
              leading: const Icon(Icons.checklist),
              title: const Text('Chính sách và điều khoản'),
              onTap: () {
                setState(() {
                  currentIndex = 6;
                });
                Navigator.pop(context); // Close the drawer
              },
              selected: currentIndex == 6,
            ),
            ListTile(
              leading: const Icon(Icons.password),
              title: const Text('Đổi mật khẩu'),
              onTap: () {
                setState(() {
                  currentIndex = 7;
                });
                Navigator.pop(context); // Close the drawer
              },
              selected: currentIndex == 7,
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Đăng xuất'),
              onTap: () {
                _showLogoutConfirmationDialog(context); // Hiển thị hộp thoại xác nhận
              },
              selected: currentIndex == 8,
            ),
          ],
        ),
      ),
      body: screens[currentIndex],
    );
  }
}