import 'package:flutter/material.dart';

class Description extends StatefulWidget {
  final String description;
  const Description({super.key, required this.description});

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Row(
                  children: [
                    Container(
                      width: 180,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "Thông tin tài khoản",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: isExpanded ? null : 50,
            child: Text(
              widget.description,
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,fontWeight: FontWeight.bold
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: isExpanded ? null : 3,
            ),
          ),
          if (!isExpanded)
            Center(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    isExpanded = true;
                  });
                },
                child: const Text("Xem thêm"),
              ),
            ),
        ],
      ),
    );
  }
}