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

  const CustomBarberCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.role,
    required this.contact,
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
            height: 98.h, // ScreenUtil for responsive design
            width: 98.w, // ScreenUtil for responsive design
          ),
          const SizedBox(width: 12), // Space between image and text
          // Barber's Information Column
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                top: 12,
                left: 10,
                text: name, // Barber's name passed from constructor
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
              CustomText(
                left: 10,
                text: role, // Barber's role passed from constructor
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
              CustomText(
                left: 10,
                text: contact, // Barber's contact passed from constructor
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
