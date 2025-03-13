import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Admin/Account/login_admin.dart';
import '../../Firebase/auth_service.dart';
import '../../drawers.dart';
import '../Featuree/Fuature_user/policy.dart';
import 'forget_user.dart';
import 'signup_user.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool isPasswordHidden= true;

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
                Text("Đăng Nhập", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
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
                  decoration:  InputDecoration(labelText: 'Mật khẩu',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    suffixIcon: IconButton(onPressed: (){
                      setState(() {
                        isPasswordHidden = !isPasswordHidden;
                      });
                    },
                      icon: Icon(
                          isPasswordHidden
                              ? Icons.visibility_off
                              : Icons.visibility
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
                  onPressed: _login,style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Đăng nhập'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context)=>ForgotPasswordScreen()));
                      },
                      child: const Text('Quên mật khẩu '),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context)=>RegisterScreen()));
                  },
                  child: const Text('Chưa có tài khoản? Đăng kí ngay'),
                ),
                SizedBox(height: 10,),
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
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>Chinhsachbaomat()));
                            },
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)
                      ),
                    ],

                  ),
                ),
                SizedBox(height: 18,),
                Padding(
                  padding: const EdgeInsets.only(left: 300.0),
                  child: FloatingActionButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>LoginAdmin()));
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35.0),),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(35.0),
                      child: Image.asset('images/logo.jpg',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      User? user = await AuthService().loginWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );
      setState(() {
        _isLoading = false;
      });
      if (user != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Drawers()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tài khoản hoặc mật khẩu không chính xác')),
        );
      }
    }
  }
}