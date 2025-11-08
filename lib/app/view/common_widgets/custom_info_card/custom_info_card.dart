import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';

class CustomInfoCard extends StatelessWidget {
  final String title;
  final String? value;
  final Widget? valueWidget; // Optional widget for custom value display (like shimmer)
  final Widget image;
  final VoidCallback onTap;

  // Constructor to accept dynamic content
  const CustomInfoCard({
    super.key,
    required this.title,
    this.value,
    this.valueWidget, 
    required this.image, 
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(6), // Adjusted for better space
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.8), // Opacity for smooth effect
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1), // Subtle shadow for depth
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3), // Shadow offset
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Dynamic image (you can pass different image URLs here)
            image,
            const SizedBox(height: 12), // Space between image and title
            CustomText(
              text: title, // Title passed dynamically
              fontWeight: FontWeight.w600,
              fontSize: 14.sp, // Responsive font size
              color: AppColors.black,
            ),
            const SizedBox(height: 4), // Space between title and value
            // Use valueWidget if provided, otherwise use value text
            valueWidget ?? CustomText(
              text: value ?? "...", // Value passed dynamically
              fontWeight: FontWeight.w700,
              fontSize: 20.sp, // Larger font size for the value
              color: AppColors.black,
            ),
          ],
        ),
      ),
    );
  }
}
