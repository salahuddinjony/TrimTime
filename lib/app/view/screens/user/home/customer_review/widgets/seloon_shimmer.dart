import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SeloonShimmer extends StatelessWidget {
  const SeloonShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 233,
        width: 326,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey.shade200,
        ),
        child: Stack(
          children: [
            // Background image shimmer
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                height: 145,
                width: double.infinity,
                color: Colors.white,
              ),
            ),
            // Discount shimmer (top right)
            Positioned(
              top: 30,
              right: 20,
              child: Container(
                width: 60,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            // Bottom details shimmer
            Positioned(
              top: 150,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title shimmer
                  Container(
                    height: 16,
                    width: 120,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  // Rating shimmer
                  Container(
                    height: 16,
                    width: 60,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // Location icon shimmer
                      Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      // Location text shimmer
                      Container(
                        height: 16,
                        width: 80,
                        color: Colors.white,
                      ),
                      const Spacer(),
                      // Save icon shimmer
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.favorite,
                          color: Colors.grey.shade300,
                          size: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
