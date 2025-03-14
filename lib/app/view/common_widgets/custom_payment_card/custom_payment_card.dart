import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:barber_time/app/utils/app_colors.dart';


class CustomSubscriptionCard extends StatelessWidget {
  final String planName;
  final String price;
  final Color cardColor;
  final Color borderColor;
  final Color textColor;
  final Color iconBgColor;
  final String iconAsset;
  final List<String> features;
  final VoidCallback onTap;

  const CustomSubscriptionCard({super.key,
    required this.cardColor,
    required this.textColor,
    required this.iconBgColor,
    required this.iconAsset,
    required this.features,
    required this.onTap,
    required this.borderColor,
  required this.planName, required this.price,
  });



  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8, bottom: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              iconAsset,
              width: 50,
              height: 50,
            ),
          ),
          CustomText(
            text: planName,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
          CustomText(
            text: price,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
            bottom: 8,
          ),
          Column(
            children: List.generate(features.length, (index) {
              return CustomText(
                text: features[index],
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: CustomButton(
              onTap: onTap,
              borderColor: borderColor,
              fillColor: cardColor,
              textColor: textColor,
              title: 'Subscribe',
            ),
          )
        ],
      ),
    );
  }
}
