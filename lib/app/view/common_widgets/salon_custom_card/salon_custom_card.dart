import 'package:flutter/material.dart';

class SalonCustomCard extends StatelessWidget {
  const SalonCustomCard({
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
