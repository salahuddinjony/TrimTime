import 'package:flutter/material.dart';

class CustomFeedBackCard extends StatelessWidget {
  const CustomFeedBackCard({
    super.key,
    this.onTap,
  });

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(),
    );
  }
}
