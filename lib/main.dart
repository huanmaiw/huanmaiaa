import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:maishop/API/acc_provider.dart';
import 'package:provider/provider.dart';
import 'User/Accountz/login_user.dart';
import 'User/Featuree/Cart/cart_provider.dart';
import 'User/Featuree/Favorite/favorite_pro.dart';
import 'User/Featuree/Provider/balence.dart';
import 'User/Featuree/Provider/top_up.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(providers:[
      ChangeNotifierProvider(create: (context) => AccountProvider()),
      ChangeNotifierProvider(create: (context) => TopUpHistoryProvider()),
      ChangeNotifierProvider(create: (_)=>BalanceProvider()),
      ChangeNotifierProvider(create: (_)=>CartProvider()),
      ChangeNotifierProvider(create: (_) => FavoriteProvider()),
    ] ,
      child: MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
      LoginScreen(),
    );
  }
// Widget _getHomeScreen() {
//   if (AuthService().currentUser != null) {
//     return Drawers();
//   } else {
//     return LoginScreen();
//   }
// }
}