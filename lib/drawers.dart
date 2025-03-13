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
        MaterialPageRoute(builder: (context) => const Drawers()),
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
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Có'),
              onPressed: () {
                Navigator.of(context).pop();
                _signOut(context);
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
        title: const Text('Shop HuanMai', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        elevation: 5,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.lightBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children:[
              CircleAvatar(
                radius: 45,
                backgroundImage: AssetImage('images/category/fr0.jpg'),
              ),
                      Positioned(
                        bottom: -15,
                        right: -5,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                            onPressed: () {
                              AccountPage();
                            },
                          ),
                        ),
                      ),
              ] ,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Mai Shop',
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Consumer<BalanceProvider>(
                    builder: (context, balanceProvider, child) {
                      return Text(
                        'Số tiền: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'VND', decimalDigits: 0).format(balanceProvider.balance)}',
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      );
                    },
                  ),
                ],
              ),
            ),

            const Divider(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(Icons.home, 'Trang chủ', 0),
                  _buildDrawerItem(Icons.favorite_border, 'Yêu thích', 1),
                  _buildDrawerItem(Icons.attach_money, 'Nạp tiền', 2),
                  _buildDrawerItem(Icons.shopping_bag, 'Lịch sử mua hàng', 3),
                  _buildDrawerItem(Icons.history, 'Lịch sử nạp tiền', 4),
                  _buildDrawerItem(Icons.call, 'CSKH 24/7', 5),
                  _buildDrawerItem(Icons.checklist, 'Chính sách & Điều khoản', 6),
                  _buildDrawerItem(Icons.password, 'Đổi mật khẩu', 7),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.logout,color: Colors.white,),
                label: const Text('Đăng xuất'),
                onPressed: () => _showLogoutConfirmationDialog(context),
              ),
            ),
          ],
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: screens[currentIndex],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon, color: currentIndex == index ? Colors.blueAccent : Colors.black54),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: currentIndex == index ? Colors.blueAccent : Colors.black87,
        ),
      ),
      selected: currentIndex == index,
      //selectedTileColor: Colors.grey.shade100,
      onTap: () {
        setState(() {
          currentIndex = index;
        });
        Navigator.pop(context);
      },
    );
  }
}
