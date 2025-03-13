
import 'package:flutter/material.dart';
class Chinhsachbaomat extends StatefulWidget {
  const Chinhsachbaomat({super.key});

  @override
  State<Chinhsachbaomat> createState() => _ChinhsachbaomatState();
}

class _ChinhsachbaomatState extends State<Chinhsachbaomat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(""),
      ),
      body: const Padding(
        padding:  EdgeInsets.all(15.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text("Chính Sách và Điều Khoản", style: TextStyle(fontSize: 25, color: Colors.red)),
                Text("Garena rất coi trọng việc bảo mật thông tin của bạn. Để bảo vệ các quyền của bạn một cách hiệu quả hơn, chúng tôi đã cung cấp Chính Sách Bảo Mật của Garena để giải thích chi tiết về các cách thức bảo mật thông tin của chúng tôi. Vui lòng xem Chính Sách Bảo Mật để hiểu được cách thức Garena thu thập và sử dụng thông tin liên kết với Tài Khoản của bạn và/hoặc việc bạn sử dụng Các Dịch Vụ. Bằng việc truy cập hoặc sử dụng Các Dịch Vụ hoặc đồng ý với các Điều Khoản Dịch Vụ này, bạn đồng ý cho phép Garena thu thập, sử dụng, tiết lộ, xử lý và/hoặc chuyển Nội Dung và dữ liệu cá nhân của bạn như mô tả trong Chính Sách Bảo Mật này.",style: TextStyle(fontSize: 18, color: Colors.black)),
                Text("Garena bảo lưu quyền chỉnh sửa các Điều Khoản Dịch Vụ này vào bất kỳ lúc nào hoặc trên cơ sở thông báo cho Người dùng, phù hợp với pháp luật hiện hành. Chúng tôi sẽ cập nhật định kỳ cho bạn bất kỳ sửa đổi nào đối với các Điều Khoản Dịch vụ này, bao gồm cả việc đăng các Điều Khoản Dịch vụ đã sửa đổi đó tại đây. Chúng tôi khuyến khích bạn kiểm tra trang này thường xuyên để ghi nhận bất kỳ thay đổi nào. Trong phạm vi tối đa được pháp luật cho phép, việc bạn tiếp tục truy cập hoặc sử dụng Dịch vụ sẽ được coi là sự chấp nhận không thể hủy ngang đối với những sửa đổi đó.",style: TextStyle(fontSize: 18, color: Colors.black)),
                Text("Bằng việc sử dụng hoặc truy cập Các Dịch Vụ, bạn đồng ý tuân thủ các quy định pháp luật về sở hữu trí tuệ hiện hành đối với vấn đề bảo hộ bản quyền, thương hiệu, nhãn hiệu dịch vụ, Các Dịch Vụ và Nội Dung của nó. Bạn đồng ý không sao chép, phát tán, tái xuất bản, gửi, trưng bày công khai, trình diễn công khai, điều chỉnh, sửa đổi, cho thuê, bán, hay tạo phó bản của bất kỳ phần nào của Các Dịch Vụ hoặc Nội Dung của nó. Nếu không có sự đồng ý trước bằng văn bản của chúng tôi, Bạn cũng không được nhân bản hoặc chỉnh sửa một phần hay toàn bộ Các Dịch Vụ trên máy chủ khác hoặc như một phần của bất kỳ trang web nào khác. Ngoài ra, bạn đồng ý rằng bạn sẽ không sử dụng bất kỳ công cụ robot, spider hay bất kỳ thiết bị tự động hay quy trình thủ công nào khác để theo dõi hay sao chép Nội Dung của chúng tôi, nếu không có sự đồng ý trước bằng văn bản của chúng tôi (thỏa thuận này áp dụng cho các công cụ tìm kiếm cơ bản trên các website kết nối người dùng trực tiếp đến website đó).",style: TextStyle(fontSize: 18, color: Colors.black)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
