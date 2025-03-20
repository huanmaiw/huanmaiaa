import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Shared/readJson.dart';
class AdminMain extends StatefulWidget {
  const AdminMain({super.key});
  @override
  State<AdminMain> createState() => _AdminMainState();
}
class _AdminMainState extends State<AdminMain> {
  @override
  void initState() {
    loadJsonData();
    super.initState();
  }
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _noteController = TextEditingController();
  String? _selectedAccountId;
  String _selectedCategory = 'Hot';
  final List<String> _categories = ['Hot','Random','Reg'];

  final CollectionReference accountsCollection =
  FirebaseFirestore.instance.collection('user');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Quản Lý Tài Khoản'),
      ),
      body: Column(
        children: [

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: accountsCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Lỗi tải dữ liệu'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final accounts = snapshot.data!.docs;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('Tài Khoản')),
                      DataColumn(label: Text('Mật khẩu')),
                      DataColumn(label: Text('Ghi chú')),
                      DataColumn(label: Text('Phân loại')),
                    ],
                    rows: accounts.map((account) {
                      final data = account.data() as Map<String, dynamic>?;
                      final isSelected = _selectedAccountId == account.id;
                      return DataRow(
                        selected: isSelected,
                        onSelectChanged: (selected) {
                          if (selected == true) {
                            setState(() {
                              _selectedAccountId = account.id;
                              _usernameController.text = data?['Tai khoan'] ?? '';
                              _passwordController.text = data?['Mat khau'] ?? '';
                              _noteController.text = data?['Ghi chu'] ?? '';
                              _selectedCategory = data?['Phan loai'] ?? '';
                            });
                          }
                        },
                        cells: [
                          DataCell(Text(data?['Tai khoan'] ?? 'Không có tài khoản')),
                          DataCell(Text(data?['Mat khau'] ?? '******')),
                          DataCell(Text(data?['Ghi chu'] ?? 'Không có ghi chú')),
                          DataCell(Text(data?['Phan loai'] ?? 'Không có phân loại')),
                        ],
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                onPressed: () {
                  _selectedAccountId = null;
                  _usernameController.clear();
                  _passwordController.clear();
                  _noteController.clear();
                  _selectedCategory = 'Hot';
                  showDialog(
                    context: context,
                    builder: (context) => _buildDialog(context, false),
                  );
                },
                child: Text('Thêm Tài Khoản'),
              ),
              ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent, foregroundColor: Colors.white),
                onPressed: () {
                  if (_selectedAccountId != null) {
                    showDialog(
                      context: context,
                      builder: (context) => _buildDialog(context, true),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Vui lòng chọn tài khoản để sửa')),
                    );
                  }
                },
                child: Text('Sửa Tài Khoản'),
              ),
              ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                onPressed: () {
                  if (_selectedAccountId != null) {
                    _confirmDeleteAccount(_selectedAccountId!);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Vui lòng chọn tài khoản để xóa')),
                    );
                  }
                },
                child: Text('Xóa Tài Khoản'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDialog(BuildContext context, bool isEditing) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(isEditing ? 'Sửa Tài Khoản' : 'Thêm Tài Khoản'),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Tài khoản'),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Mật khẩu'),
              ),
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(labelText: 'Ghi chú'),
              ),
              DropdownButtonFormField(
                value: _selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value.toString();
                  });
                },
                decoration: InputDecoration(labelText: 'Phân loại'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (isEditing) {
                      _updateAccount();
                    } else {
                      _addAccount();
                    }
                    Navigator.of(context).pop();
                  }
                },
                child: Text(isEditing ? 'Lưu Thay Đổi' : 'Thêm'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addAccount() async {
    await accountsCollection.add({
      'Tai khoan': _usernameController.text,
      'Mat khau': _passwordController.text,
      'Ghi chu': _noteController.text,
      'Phan loai': _selectedCategory,
    });
  }

  void _updateAccount() async {
    if (_selectedAccountId != null) {
      await accountsCollection.doc(_selectedAccountId).update({
        'Tai khoan': _usernameController.text,
        'Mat khau': _passwordController.text,
        'Ghi chu': _noteController.text,
        'Phan loai': _selectedCategory,
      });
    }
  }

  void _confirmDeleteAccount(String accountId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xác nhận'),
        content: Text('Bạn có chắc chắn muốn xóa tài khoản này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              accountsCollection.doc(accountId).delete();
              Navigator.of(context).pop();
            },
            child: Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
