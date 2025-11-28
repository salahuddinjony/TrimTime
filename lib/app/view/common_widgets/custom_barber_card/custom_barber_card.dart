import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:barber_time/app/utils/app_colors.dart';

class CustomBarberCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String role;
  final String contact;
  final String? hourlyRate;

  const CustomBarberCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.role,
    required this.contact,
    this.hourlyRate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        color: AppColors.white50, // Light background color
        borderRadius: BorderRadius.all(Radius.circular(11)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Barber's Profile Image
          CustomNetworkImage(
            boxShape: BoxShape.circle, // Circle shape for image
            imageUrl: imageUrl, // Image URL passed from constructor
            height: 60.h, // ScreenUtil for responsive design
            width: 60.w, // ScreenUtil for responsive design
          ),
          const SizedBox(width: 12), // Space between image and text
          // Barber's Information Column
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomText(
                    left: 00,
                    text: name, // Barber's name passed from constructor
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                  if (hourlyRate != null) ...[
                    const SizedBox(width: 8),
                    CustomText(
                      left: 10,
                      text:
                          '(\$$hourlyRate/hr)', // Display hourly rate if provided
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.app,
                    ),
                  ],
                ],
              ),
              SizedBox(height: 6.h),
              Row(
                children: [
                  Icon(Icons.email, size: 14, color: AppColors.f32Color),
                  CustomText(
                    left: 05,
                    text: role,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.phone, size: 14, color: AppColors.f32Color),
                  CustomText(
                    left: 10,
                    text: contact,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
