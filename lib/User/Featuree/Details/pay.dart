
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Fuature_user/history_buy.dart';
import '../Product/product_models.dart';
import '../Provider/balence.dart';
import 'order.dart';
class PaymentScreen extends StatefulWidget {
  final List<Product> products;
  final double totalPrice;

  const PaymentScreen({
    Key? key,
    required this.products,
    required this.totalPrice,
  }) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _discountCodeController = TextEditingController();
  double _discountAmount = 0;
  double _finalPrice = 0;
  @override
  void initState() {
    super.initState();
    _finalPrice = widget.totalPrice;
  }

  @override
  void dispose() {
    _discountCodeController.dispose();
    super.dispose();
  }

  void _applyDiscountCode() {
    if (_formKey.currentState!.validate()) {
      String discountCode = _discountCodeController.text;

      if (discountCode=="shopmeo" || discountCode=="SHOPMEO") {
        setState(() {
          _discountAmount = widget.totalPrice * 0.1;
          _finalPrice = widget.totalPrice - _discountAmount;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã áp dụng giảm giá 10%')),
        );
      } else {
        setState(() {
          _discountAmount = 0; // Reset giảm giá
          _finalPrice = widget.totalPrice; // Reset tổng tiền
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mã giảm giá không hợp lệ')),
        );
      }
    }
  }

  void _handlePayment() async {
    final balanceProvider = Provider.of<BalanceProvider>(context, listen: false);
    await balanceProvider.fetchBalance();

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Chưa có giao dịch nào!")),
      );
      return;
    }

    String userId = user.uid;

    if (balanceProvider.balance >= _finalPrice) {
      balanceProvider.deductBalance(_finalPrice);

      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'balance': balanceProvider.balance,
      });

      // Lấy danh sách tài khoản có sẵn theo phân loại (ví dụ: "Hot")
      QuerySnapshot accountSnapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('Phan loai', isEqualTo: 'Hot') // Lọc theo loại tài khoản
          .limit(1)
          .get();

      if (accountSnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không còn tài khoản có sẵn!')),
        );
        return;
      }

      var selectedAccount = accountSnapshot.docs.first;

      // Lưu vào lịch sử mua hàng của user
      await FirebaseFirestore.instance.collection('users').doc(userId).collection('history').add({
        'username': selectedAccount['Tai khoan'],
        'password': selectedAccount['Mat khau'],
        'note': selectedAccount['Ghi chu'],
        'price': _finalPrice,
        'purchaseDate': Timestamp.now(),
      });

      // Lưu vào lịch sử bán của admin
      await FirebaseFirestore.instance.collection('admin').doc('history').collection('transactions').add({
        'buyerId': userId,
        'username': selectedAccount['Tai khoan'],
        'password': selectedAccount['Mat khau'],
        'note': selectedAccount['Ghi chu'],
        'price': _finalPrice,
        'saleDate': Timestamp.now(),
      });

      // Xóa tài khoản khỏi Firestore sau khi bán
      await FirebaseFirestore.instance.collection('user').doc(selectedAccount.id).delete();

      // Hiển thị hộp thoại chứa tài khoản và mật khẩu
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Thanh toán thành công!"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Tài khoản: ${selectedAccount['Tai khoan']}"),
                Text("Mật khẩu: ${selectedAccount['Mat khau']}"),
                Text("Ghi chú: ${selectedAccount['Ghi chu']}"),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => PurchaseHistoryScreen()),
                  );
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Số dư không đủ!')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thông tin sản phẩm
                const Text(
                  'Thông tin sản phẩm:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.products.length,
                  itemBuilder: (context, index) {
                    final product = widget.products[index];
                    return ListTile(
                      title: Text(product.title),
                      subtitle: Text(
                          'Giá: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'VND', decimalDigits: 0).format(product.price)}'),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  'Tổng tiền: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'VND', decimalDigits: 0).format(widget.totalPrice)}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),
                // Nhập mã giảm giá
                TextFormField(
                  controller: _discountCodeController,
                  decoration: const InputDecoration(
                    labelText: 'Nhập mã giảm giá',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                // Nút áp dụng mã giảm giá
                ElevatedButton(
                  onPressed: _applyDiscountCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Áp dụng mã giảm giá'),
                ),
                const SizedBox(height: 20),
                // Hiển thị số tiền giảm giá
                if (_discountAmount > 0)
                  Text(
                    'Giảm giá: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'VND', decimalDigits: 0).format(_discountAmount)}',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                const SizedBox(height: 10),
                Text(
                  'Tổng tiền cần thanh toán: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'VND', decimalDigits: 0).format(_finalPrice)}',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
                const SizedBox(height: 30),
                // Nút thanh toán
                Consumer<BalanceProvider>(
                  builder: (context, balanceProvider, child) {
                    bool isBalanceEnough = balanceProvider.balance >= _finalPrice;

                    return Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isBalanceEnough ? Colors.red : Colors.grey,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: isBalanceEnough
                            ? () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => OrderSuccessScreen()));
                          if (widget.products.isNotEmpty) {
                            _handlePayment();
                          }
                        }
                            : null, // Vô hiệu hóa nút nếu số dư không đủ
                        child: Text(isBalanceEnough ? 'Thanh toán' : 'Số dư không đủ'),
                      ),
                    );
                  },
                ),

              ],
            ),
          ),
        ),
      ),
    );

  }
}