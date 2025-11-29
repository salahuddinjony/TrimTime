import 'package:barber_time/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class FavoriteShimmerCard extends StatelessWidget {
  const FavoriteShimmerCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row (avatar + name + address)
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: SizedBox(
                            width: double.infinity,
                            height: 12,
                            child: ColoredBox(color: Colors.white)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0, top: 6.0),
                        child: SizedBox(
                            width: 160,
                            height: 12,
                            child: ColoredBox(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            // Large post image placeholder
            Container(
              height: 364,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
            ),
            const SizedBox(height: 8),
            // Post text placeholder
            const SizedBox(
                width: double.infinity,
                height: 14,
                child: ColoredBox(color: Colors.white)),
            const SizedBox(height: 10),
            // Bottom action row: favorite circle, rating, visit shop button
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                      color: AppColors.secondary, shape: BoxShape.circle),
                  child: const Icon(Icons.favorite_border, color: Colors.white),
                ),
                const SizedBox(width: 8),
                const SizedBox(
                    width: 80,
                    height: 14,
                    child: ColoredBox(color: Colors.white)),
                const Spacer(),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(color: AppColors.black),
                  child: const SizedBox(
                      width: 80,
                      height: 20,
                      child: ColoredBox(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
