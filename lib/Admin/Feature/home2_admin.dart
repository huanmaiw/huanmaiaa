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

  void showAccountDialog({int? index}) {
    TextEditingController userController = TextEditingController(
        text: index != null ? accounts[index]['user'] : '');
    TextEditingController passController = TextEditingController(
        text: index != null ? accounts[index]['pass'] : '');
    TextEditingController priceController = TextEditingController(
        text: index != null ? accounts[index]['price'].toString() : '');
    TextEditingController noteController = TextEditingController(
        text: index != null ? accounts[index]['note'] : '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(index == null ? 'Thêm tài khoản' : 'Chỉnh sửa tài khoản'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(userController, 'User'),
              _buildTextField(passController, 'Mật khẩu'),
              _buildTextField(priceController, 'Giá', isNumber: true),
              _buildTextField(noteController, 'Ghi chú'),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Hủy')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                setState(() {
                  if (index == null) {
                    accounts.add({
                      'id': (accounts.length + 1).toString(),
                      'user': userController.text,
                      'pass': passController.text,
                      'price': int.tryParse(priceController.text) ?? 0,
                      'note': noteController.text,
                    });
                  } else {
                    accounts[index]['user'] = userController.text;
                    accounts[index]['pass'] = passController.text;
                    accounts[index]['price'] = int.tryParse(priceController.text) ?? 0;
                    accounts[index]['note'] = noteController.text;
                  }
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

  Widget _buildTextField(TextEditingController controller, String label, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
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
        title: Text('Danh sách tài khoản', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
        actions: [IconButton(icon: Icon(Icons.add,color: Colors.white,), onPressed: () => showAccountDialog())],
      ),
      body: accounts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView(
        children: categories.map((category) {
          List<dynamic> filteredAccounts = accounts.where((account) => account['note'] == category).toList();
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: ExpansionTile(
              title: Text(category, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              children: filteredAccounts.map((account) {
                int index = accounts.indexOf(account);
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Text(account['id'][0], style: TextStyle(color: Colors.white)),
                  ),
                  title: Text('User: ${account['user']}', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mật khẩu: ${account['pass']}'),
                      Text('Giá: ${account['price']} VND'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: Icon(Icons.edit, color: Colors.blue), onPressed: () => showAccountDialog(index: index)),
                      IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () => deleteAccount(index)),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }
}
