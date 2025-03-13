import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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
  double _discountAmount = 0; // Số tiền giảm giá
  double _finalPrice = 0; // Tổng tiền sau khi giảm giá

  @override
  void initState() {
    super.initState();
    _finalPrice = widget.totalPrice; // Khởi tạo tổng tiền sau khi giảm giá bằng tổng tiền ban đầu
  }

  @override
  void dispose() {
    _discountCodeController.dispose();
    super.dispose();
  }

  void _applyDiscountCode() {
    if (_formKey.currentState!.validate()) {
      String discountCode = _discountCodeController.text;
      // Kiểm tra mã giảm giá (trong trường hợp này, giảm 10% cho tất cả mã)
      if (discountCode.isNotEmpty) {
        setState(() {
          _discountAmount = widget.totalPrice * 0.1; // Giảm 10%
          _finalPrice = widget.totalPrice - _discountAmount; // Tính lại tổng tiền
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

  void _handlePayment() {
    // Lấy BalanceProvider từ context
    final balanceProvider = Provider.of<BalanceProvider>(context, listen: false);

    // Kiểm tra số dư
    if (balanceProvider.balance >= _finalPrice) {
      // Trừ tiền
      balanceProvider.deductBalance(_finalPrice);

      // Thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thanh toán thành công')),
      );

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const OrderSuccessScreen()));
    } else {
      // Thông báo thất bại
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Số dư không đủ')),
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
                // Hiển thị số dư hiện tại
                Consumer<BalanceProvider>(
                  builder: (context, balanceProvider, child) {
                    return Text(
                      'Số dư hiện tại: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'VND', decimalDigits: 0).format(balanceProvider.balance)}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    );
                  },
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
                // Hiển thị tổng tiền sau khi giảm giá
                Text(
                  'Tổng tiền cần thanh toán: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'VND', decimalDigits: 0).format(_finalPrice)}',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
                const SizedBox(height: 30),
                // Nút thanh toán
                Center(
                  child: ElevatedButton(
                    onPressed: _handlePayment,
                    child: const Text('Thanh toán'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}