import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ReviewShimmerCard extends StatelessWidget {
  const ReviewShimmerCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        padding: EdgeInsets.all(30.w),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: 44,
                height: 44,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Container(height: 14, color: Colors.white)),
                      const SizedBox(width: 8),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          SizedBox(
                              width: 60,
                              height: 12,
                              child: ColoredBox(color: Colors.white)),
                          SizedBox(height: 4),
                          SizedBox(
                              width: 36,
                              height: 12,
                              child: ColoredBox(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(height: 12, color: Colors.white),
                  const SizedBox(height: 8),
                  Container(height: 12, width: 100, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
