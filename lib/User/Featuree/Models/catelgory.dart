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
    image: "images/category/fe3.jpg",
  ),
  Category(
    title: "Acc Reg",
    image: "images/category/fr0.jpg",
  ),
  Category(
    title: "Random \nVIP 1",
    image: "images/category/fr1.jpg",
  ),
  Category(
    title: "Random \nSơ Cấp",
    image: "images/category/fr2.jpg",
  ),
  Category(
    title: "Random \nSiêu Cấp",
    image: "images/category/fr4.jpg",
  ),
];