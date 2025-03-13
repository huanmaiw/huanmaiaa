import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryMain extends StatefulWidget {
  const HistoryMain({super.key});

  @override
  State<HistoryMain> createState() => _HistoryMainState();
}

class _HistoryMainState extends State<HistoryMain> {
  final List<GameAccountPurchase> _purchaseHistory = [
    GameAccountPurchase(
      id: '1',
      gameName: 'Liên Quân Mobile',
      accountUsername: 'Player123',
      rank: 'Kim Cương',
      price: 500000,
      purchaseDate: DateTime(2024, 3, 15, 14, 30),
      buyerName: 'Nguyễn Văn A',
    ),
    GameAccountPurchase(
      id: '2',
      gameName: 'Free Fire',
      accountUsername: 'Shooter456',
      rank: 'Bạc',
      price: 200000,
      purchaseDate: DateTime(2024, 3, 10, 10, 15),
      buyerName: 'Trần Thị B',
    ),
    GameAccountPurchase(
      id: '3',
      gameName: 'PUBG Mobile',
      accountUsername: 'Sniper789',
      rank: 'Vàng',
      price: 350000,
      purchaseDate: DateTime(2024, 3, 5, 16, 45),
      buyerName: 'Lê Văn C',
    ),
  ];
  void _showPurchaseDetailsDialog(GameAccountPurchase purchase) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chi Tiết Mua Nick'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Mã Giao Dịch:', purchase.id),
              _buildDetailRow('Tên Game:', purchase.gameName),
              _buildDetailRow('Tài Khoản:', purchase.accountUsername),
              _buildDetailRow('Rank:', purchase.rank),
              _buildDetailRow('Giá Bán:', '${purchase.price.toString()} VND'),
              _buildDetailRow('Ngày Mua:', DateFormat('dd/MM/yyyy HH:mm').format(purchase.purchaseDate)),
              _buildDetailRow('Người Mua:', purchase.buyerName),
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

  // Hàm tạo hàng thông tin chi tiết
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Lịch Sử Mua Nick Game'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _purchaseHistory.length,
        itemBuilder: (context, index) {
          final purchase = _purchaseHistory[index];
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
                  Text('Nick: ${purchase.accountUsername}'),
                  Text('Rank: ${purchase.rank}'),
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
                    '${purchase.price.toString()} VND',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
      ),
    );
  }

  // Hàm chọn màu cho từng game
  Color _getGameColor(String gameName) {
    switch (gameName.toLowerCase()) {
      case 'liên quân mobile':
        return Colors.blue;
      case 'free fire':
        return Colors.red;
      case 'pubg mobile':
        return Colors.green;
      default:
        return Colors.purple;
    }
  }

  // Hàm hiển thị dialog lọc
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Lọc Lịch Sử'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Chọn Game',
                  border: OutlineInputBorder(),
                ),
                items: [
                  'Tất Cả',
                  'Liên Quân Mobile',
                  'Free Fire',
                  'PUBG Mobile'
                ].map((game) {
                  return DropdownMenuItem(
                    value: game,
                    child: Text(game),
                  );
                }).toList(),
                onChanged: (value) {
                  // Xử lý lọc
                },
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Áp dụng bộ lọc
                        Navigator.of(context).pop();
                      },
                      child: Text('Áp Dụng'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// Lớp lưu thông tin mua nick game
class GameAccountPurchase {
  final String id;
  final String gameName;
  final String accountUsername;
  final String rank;
  final int price;
  final DateTime purchaseDate;
  final String buyerName;

  GameAccountPurchase({
    required this.id,
    required this.gameName,
    required this.accountUsername,
    required this.rank,
    required this.price,
    required this.purchaseDate,
    required this.buyerName,
  });
}