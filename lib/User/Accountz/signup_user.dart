import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Firebase/auth_service.dart';
import 'login_user.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Đăng Kí", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                SizedBox(height: 40,),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10,),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Mật khẩu',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10,),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nhập lại mật khẩu ',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 5,),
                Text("Bạn cần sử dụng email trong trường hợp đặt lại mật khẩu "
                  ,style: TextStyle(fontSize: 12, color:Colors.blue),),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: signup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // Làm tròn nhẹ các góc
                    ),
                    minimumSize: Size(double.infinity, 50), // Chiều rộng bằng chiều rộng của TextFormField
                  ),
                  child: _isLoading
                      ?  CircularProgressIndicator()
                      : const Text('Đăng ký'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen())); // Chuyển sang màn hình đăng nhập
                  },
                  child: const Text('Đã có tài khoản? Đăng nhập ngay'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void signup ()async{
    try {
      CollectionReference collRef = FirebaseFirestore.instance.collection("Account");
      await collRef.add({
        "Email": _emailController.text,
        "Pass": _passwordController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng kí thành công !')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      User? user = await AuthService().registerWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );
      setState(() {
        _isLoading = false;
      });
      if (user != null) {
        // Đăng ký thành công, chuyển sang màn hình chính
        Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
      } else {
        // Đăng ký thất bại, hiển thị thông báo lỗi
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đăng ký thành công')),
        );
      }
    }
  }
}