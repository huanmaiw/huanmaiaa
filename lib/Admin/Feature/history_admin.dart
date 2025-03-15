import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryMain extends StatefulWidget {
  const HistoryMain({super.key});

  @override
  State<HistoryMain> createState() => _HistoryMainState();
}

class _HistoryMainState extends State<HistoryMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Lịch Sử Bán Tài Khoản'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('user').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Chưa có giao dịch nào'));
          }

          // Lấy danh sách tài khoản từ Firebase
          var purchaseHistory = snapshot.data!.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            return GameAccountPurchase(
              id: doc.id,
              gameName: data['Phan loai'] ?? 'Không xác định',
              accountUsername: data['Tai khoan'] ?? 'Không có',
              rank: 'Không có',
              purchaseDate: DateTime.now(), // Nếu có thời gian thì cập nhật từ Firestore
              buyerName: data['Ghi chu'] ?? 'Không có',
            );
          }).toList();

          return ListView.builder(
            itemCount: purchaseHistory.length,
            itemBuilder: (context, index) {
              final purchase = purchaseHistory[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getGameColor(purchase.gameName),
                    child: Text(
                      purchase.gameName[0],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    purchase.gameName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tài khoản: ${purchase.accountUsername}'),
                      Text('Mật khẩu: ******'),
                      Text(
                        DateFormat('dd/MM/yyyy HH:mm').format(purchase.purchaseDate),
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        purchase.buyerName,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  onTap: () => _showPurchaseDetailsDialog(purchase),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showPurchaseDetailsDialog(GameAccountPurchase purchase) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chi Tiết Giao Dịch'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Mã Giao Dịch:', purchase.id),
              _buildDetailRow('Tài Khoản:', purchase.accountUsername),
              _buildDetailRow('Phân Loại:', purchase.gameName),
              _buildDetailRow('Ngày Mua:', DateFormat('dd/MM/yyyy HH:mm').format(purchase.purchaseDate)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Color _getGameColor(String gameName) {
    switch (gameName.toLowerCase()) {
      case 'hot':
        return Colors.red;
      case 'vip':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}

class GameAccountPurchase {
  final String id;
  final String gameName;
  final String accountUsername;
  final String rank;
  final DateTime purchaseDate;
  final String buyerName;

  GameAccountPurchase({
    required this.id,
    required this.gameName,
    required this.accountUsername,
    required this.rank,
    required this.purchaseDate,
    required this.buyerName,
  });
}
