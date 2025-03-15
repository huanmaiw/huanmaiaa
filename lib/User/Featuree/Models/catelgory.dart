class Category {
  final String title;
  final String image;

  Category({
    required this.title,
    required this.image,
  });
}

final List<Category> categoriesList = [
  Category(
    title: "Hot",
    image: "images/category/cate1.png",
  ),
  Category(
    title: "Acc Reg",
    image: "images/category/cate2.png",
  ),
  Category(
    title: "Random \nVIP 1",
    image: "images/category/cate3.png",
  ),
  Category(
    title: "Random \nSơ Cấp",
    image: "images/category/cate4.png",
  ),
  Category(
    title: "Random \nSiêu Cấp",
    image: "images/category/cate5.png",
  ),
];