import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home2Admin extends StatefulWidget {
  const Home2Admin({super.key});

  @override
  _Home2AdminState createState() => _Home2AdminState();
}

class _Home2AdminState extends State<Home2Admin> {
  List<dynamic> accounts = [];

  Future<void> fetchAccounts() async {
    final response = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/huanmaiw/my_json/refs/heads/main/account.json'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      setState(() {
        accounts = jsonData['acc'];
      });
    } else {
      throw Exception('Failed to load accounts');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAccounts();
  }

  void addAccount() {
    TextEditingController userController = TextEditingController();
    TextEditingController passController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Thêm tài khoản mới'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: userController, decoration: InputDecoration(labelText: 'User')),
              TextField(controller: passController, decoration: InputDecoration(labelText: 'Mật khẩu')),
              TextField(controller: noteController, decoration: InputDecoration(labelText: 'Ghi chú')),
              TextField(controller: priceController, decoration: InputDecoration(labelText: 'Giá'), keyboardType: TextInputType.number),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Hủy')),
            TextButton(
              onPressed: () {
                setState(() {
                  accounts.add({
                    'id': (accounts.length + 1).toString(),
                    'user': userController.text,
                    'pass': passController.text,
                    'note': noteController.text,
                    'price': int.tryParse(priceController.text) ?? 0,
                  });
                });
                Navigator.pop(context);
              },
              child: Text('Thêm'),
            ),
          ],
        );
      },
    );
  }

  void editAccount(int index) {
    TextEditingController userController = TextEditingController(text: accounts[index]['user']);
    TextEditingController passController = TextEditingController(text: accounts[index]['pass']);
    TextEditingController priceController = TextEditingController(text: accounts[index]['price'].toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Chỉnh sửa tài khoản'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: userController, decoration: InputDecoration(labelText: 'User')),
              TextField(controller: passController, decoration: InputDecoration(labelText: 'Mật khẩu')),
              TextField(controller: priceController, decoration: InputDecoration(labelText: 'Giá'), keyboardType: TextInputType.number),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Hủy')),
            TextButton(
              onPressed: () {
                setState(() {
                  accounts[index]['user'] = userController.text;
                  accounts[index]['pass'] = passController.text;
                  accounts[index]['price'] = int.tryParse(priceController.text) ?? 0;
                });
                Navigator.pop(context);
              },
              child: Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  void deleteAccount(int index) {
    setState(() {
      accounts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    Set categories = accounts.map((account) => account['note']).toSet();

    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách tài khoản'),
        actions: [
          IconButton(icon: Icon(Icons.add), onPressed: addAccount),
        ],
      ),
      body: accounts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView(
        children: categories.map((category) {
          List<dynamic> filteredAccounts = accounts.where((account) => account['note'] == category).toList();
          return ExpansionTile(
            title: Text(category, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            children: filteredAccounts.map((account) {
              int index = accounts.indexOf(account);
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(child: Text(account['id'][0])),
                  title: Text('User: ${account['user']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mật khẩu: ${account['pass']}'),
                      Text('Ghi chú: ${account['note']}'),
                      Text('Giá: ${account['price']} VND'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: Icon(Icons.edit, color: Colors.blue), onPressed: () => editAccount(index)),
                      IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () => deleteAccount(index)),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}
