import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter/material.dart';

class CommonProfileTotalCard extends StatelessWidget {
  final String title;
  final String value;

  const CommonProfileTotalCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90, // Ensure a proper width
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            text: title,
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: AppColors.black,
          ),
          const SizedBox(height: 4), // Space before Divider
          const SizedBox(
            width: double.infinity, // Ensures the divider is full width
            child: Divider(
              color: AppColors.linearFirst,
              thickness: 1.5, // Makes the divider thicker
            ),
          ),
          const SizedBox(height: 4), // Space after Divider
          CustomText(
            text: value,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
        ],
      ),
    );
  }
}
