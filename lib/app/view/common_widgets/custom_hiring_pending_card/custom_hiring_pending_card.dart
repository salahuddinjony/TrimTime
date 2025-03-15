import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomHiringCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String role;
  final double rating;
  final String location;
  final VoidCallback onHireTap;
  final bool? isMessage;

  const CustomHiringCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.role,
    required this.rating,
    required this.location,
    required this.onHireTap, this.isMessage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.secondary),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Image
          CustomNetworkImage(
            imageUrl: imageUrl, // Dynamic image URL
            height: 100,
            width: 62,
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name of the person
                CustomText(
                  text: name,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
                SizedBox(height: 8),
                // Role/Title of the person (e.g., Barber, Manager, etc.)
                CustomText(
                  text: role,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
                SizedBox(height: 8),
                // Rating Row
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 18,
                    ),
                    CustomText(
                      left: 8,
                      text: "($rating)",
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black,
                    ),
                  ],
                ),
                // Location Row
                Row(
                  children: [
                    const Icon(
                      Icons.place,
                      color: Colors.black,
                      size: 18,
                    ),
                    CustomText(
                      left: 8,
                      text: location,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black,
                    ),
                    const Spacer(),
                    // Hire Now Button
                    isMessage == false?
                    GestureDetector(
                      onTap: onHireTap, // Execute the callback when tapped
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.container, // Button color
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Assets.images.chartSelected.image()
                      ),
                    ):const SizedBox()
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
