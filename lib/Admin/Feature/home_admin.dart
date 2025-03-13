import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class AdminMain extends StatefulWidget {
  const AdminMain({super.key});

  @override
  State<AdminMain> createState() => _AdminMainState();
}

class _AdminMainState extends State<AdminMain> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedAccountId;

  final CollectionReference accountsCollection =
  FirebaseFirestore.instance.collection('accounts');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Quản Lý Tài Khoản Game'),
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

                return ListView.builder(
                  itemCount: accounts.length,
                  itemBuilder: (context, index) {
                    var account = accounts[index];
                    return ListTile(
                      title: Text(account['username']),
                      subtitle: Text(account['email']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _selectedAccountId = account.id;
                              _usernameController.text = account['username'];
                              _emailController.text = account['email'];
                              _passwordController.text = account['password'];
                              showDialog(
                                context: context,
                                builder: (context) => _buildDialog(context, true),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deleteAccount(account.id);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _selectedAccountId = null;
              _usernameController.clear();
              _emailController.clear();
              _passwordController.clear();
              showDialog(
                context: context,
                builder: (context) => _buildDialog(context, false),
              );
            },
            child: Text('Thêm Tài Khoản'),
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
                decoration: InputDecoration(
                  labelText: 'Tên Người Chơi',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Vui lòng nhập tên' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Vui lòng nhập email' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Mật Khẩu',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Vui lòng nhập mật khẩu' : null,
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
      'username': _usernameController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
    });
  }
  void _updateAccount() async {
    if (_selectedAccountId != null) {
      await accountsCollection.doc(_selectedAccountId).update({
        'username': _usernameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
      });
    }
  }

  void _deleteAccount(String accountId) async {
    await accountsCollection.doc(accountId).delete();
  }
}
