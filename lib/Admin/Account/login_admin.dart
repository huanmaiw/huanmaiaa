import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../User/Featuree/Fuature_user/policy.dart';
import '../home_admin_screen.dart';
class LoginAdmin extends StatefulWidget {
  const LoginAdmin({super.key});
  @override
  _LoginAdminState createState() => _LoginAdminState();
}
class _LoginAdminState extends State<LoginAdmin> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;
  bool isPasswordHidden = true;

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
                Text("Đăng Nhập ADMIN",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold),),
                SizedBox(height: 40,),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),),
                  ),
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
                  decoration: InputDecoration(labelText: 'Mật khẩu',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    suffixIcon: IconButton(
                      onPressed: (){
                        setState(() {
                          isPasswordHidden = !isPasswordHidden;
                        });
                      },
                      icon: Icon(
                        isPasswordHidden
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                  obscureText: isPasswordHidden,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed:// _login,
                  LoginAdmin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Đăng nhập'),
                ),
                SizedBox(height: 13,),
                RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(
                            text: "Điều Khoản Dịch Vụ ",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context)=>
                                            Chinhsachbaomat()));
                              },
                            style: TextStyle(color: Colors.blue,
                                fontWeight: FontWeight.bold)
                        ),
                        TextSpan(
                          text: "và",
                          style: TextStyle(color: Colors.grey),
                        ),
                        TextSpan(
                            text: " Chính Sách Bảo Mật",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context)=>
                                            Chinhsachbaomat()));
                              },
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)
                        ),
                      ]
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> LoginAdmin () async {
    if(_emailController.text == "adminmeo@gmail.com"
        && _passwordController.text=="maihuan")
    {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminApp()));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tài khỏan hoặc mật khẩu không chính xác"),
          ));
    }
  }
}