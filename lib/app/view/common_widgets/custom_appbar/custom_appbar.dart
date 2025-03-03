import 'package:flutter/material.dart';

class CustomSliverAppBar extends StatelessWidget {
  final String title;
  final String backgroundImage;

  const CustomSliverAppBar({
    super.key,
    required this.title,
    required this.backgroundImage,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.teal,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: LayoutBuilder(
          builder: (context, constraints) {
            double appBarHeight = constraints.biggest.height;
            bool isExpanded = appBarHeight > kToolbarHeight + 20; // Expanded হলে true

            return isExpanded
                ? const SizedBox.shrink() // ✅ এখানে null এর পরিবর্তে SizedBox.shrink() ব্যবহার করুন
                : Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
        background: Image.network(
          backgroundImage,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
