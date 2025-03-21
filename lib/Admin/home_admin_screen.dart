import 'package:flutter/material.dart';
import 'Feature/history_admin.dart';
import 'Feature/home2_admin.dart';
import 'Feature/money_admin.dart';
import 'Feature/profile_admin.dart';
class AdminApp extends StatefulWidget {
  const AdminApp({super.key});

  @override
  State<AdminApp> createState() => _AdminAppState();
}
class _AdminAppState extends State<AdminApp> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.red[200],
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Trang Chủ',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.history)),
            label: 'Lịch Sử Bán',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.attach_money)),
            label: 'QL Nạp Tiền',
          ),
          NavigationDestination(
            icon: Badge(label: Text('2'), child: Icon(Icons.account_circle_rounded)),
            label: 'Tài Khoản',
          ),
        ],
      ),
      body: [
        Home2Admin(),
        HistoryMain(),
        BankMain(),
        ProfileAdmin(),
      ][currentPageIndex],
    );
  }

}
