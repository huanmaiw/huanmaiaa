import 'package:flutter/material.dart';
import '../Models/catelgory.dart';
import '../Models/images_slider.dart';
import '../Product/product.dart';
import '../Product/product_models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentSlider = 0;
  int selectedIndex = 0;
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    List<List<Product>> selectcategories = [
      hot,
      pick,
      reg,
      random1,
      random2,
    ];

    List<Product> displayedProducts = selectcategories[selectedIndex];

    if (searchQuery.isNotEmpty) {
      displayedProducts = displayedProducts
          .where((product) => product.title.contains(searchQuery))
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Tìm kiếm theo ID...",
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value; // Cập nhật giá trị tìm kiếm
                  });
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.search), // Icon tìm kiếm
              onPressed: () {
                // Xử lý sự kiện khi nhấn vào icon tìm kiếm (nếu cần)
                print("Tìm kiếm: $searchQuery");
              },
            ),
          ],
        ),
      ),

      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              ImageSlider(),
              const SizedBox(height: 20),
              categoryItems(),
              const SizedBox(height: 20),
              if (selectedIndex == 0)
                const Center(
                  child: Text(
                    "Tài khoản đang sale",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
                  ),
                ),
              const SizedBox(height: 10),
              GridView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20),
                itemCount: displayedProducts.length,
                itemBuilder: (context, index) {
                  return ProductCard(product: displayedProducts[index]);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  SizedBox categoryItems() {
    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categoriesList.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                  searchQuery = ""; // Xóa tìm kiếm khi chọn danh mục khác
                });
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: selectedIndex == index
                      ? Colors.blue[200]
                      : Colors.transparent,
                ),
                child: Column(
                  children: [
                    Container(
                      height: 65,
                      width: 65,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage(categoriesList[index].image),
                            fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      categoriesList[index].title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
