import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Product/product_models.dart';
class ItemsDetails extends StatelessWidget {
  final Product product;
  const ItemsDetails({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              product.title,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 22,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 170),
              child: Image.asset("images/logo.jpg",height: 70,width: 70,),
            ),
          ],
        ),
        Row(
          children: [
            Column(
              children: [
                Center(
                  child: Text(
                    "ATM/Card : ${NumberFormat.currency(
                        locale: 'vi_VN',
                        symbol: 'VND',
                        decimalDigits: 0).format(product.price)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

              ],
            ),
          ],
        )
      ],
    );
  }
}