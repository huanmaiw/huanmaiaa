import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:async';
import '../Product/product_models.dart';
import 'appbar.dart';
import 'cart_details.dart';
import 'depcristion.dart';
import 'item.dart';
class DetailScreen extends StatefulWidget {
  final Product product;
  const DetailScreen({super.key, required this.product});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}
class _DetailScreenState extends State<DetailScreen> {
  int currentImage = 0;
  late PageController _pageController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    currentImage = 0;
    _pageController = PageController(initialPage: 0);
    _startAutoSlider();
  }
  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }
  void _startAutoSlider() {
    _timer?.cancel();
    if (widget.product.image != null && widget.product.image.isNotEmpty) {
      _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        if (mounted) {
          setState(() {
            currentImage = (currentImage + 1) % widget.product.image.length;
            _pageController.animateToPage(
              currentImage,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          });
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AddToCart(product: widget.product),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DetailAppBar(
                product: widget.product,
              ),
              SizedBox(
                height: 250,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.product.image.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentImage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Hero(
                      tag: widget.product.image[index],
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          widget.product.image[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),
              Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: widget.product.image.length,
                  effect: const WormEffect(
                    dotColor: Colors.grey,
                    activeDotColor: Colors.black,
                    dotWidth: 8.0,
                    dotHeight: 8.0,
                    spacing: 4.0,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40),
                  ),
                ),
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: 100,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ItemsDetails(product: widget.product),
                    const SizedBox(height: 25),
                    Description(
                      description: widget.product.description,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}