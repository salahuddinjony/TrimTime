import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomFeedCard extends StatelessWidget {
  final String userImageUrl;
  final String userName;
  final String userAddress;
  final String postImageUrl;
  final String postText;
  final String rating;
  final VoidCallback onFavoritePressed;
  final VoidCallback onVisitShopPressed;

  const CustomFeedCard({
    super.key,
    required this.userImageUrl,
    required this.userName,
    required this.userAddress,
    required this.postImageUrl,
    required this.postText,
    required this.rating,
    required this.onFavoritePressed,
    required this.onVisitShopPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info Row
          Row(
            children: [
              CustomNetworkImage(
                boxShape: BoxShape.circle,
                imageUrl: userImageUrl,
                height: 48,
                width: 48,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      left: 8,
                      text: userName,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: AppColors.black,
                    ),
                    CustomText(
                      left: 8,
                      text: userAddress,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: AppColors.black,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          // Post Image
          CustomNetworkImage(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            imageUrl: postImageUrl,
            height: 364,
            width: double.infinity,
          ),
          const CustomText(
            textAlign: TextAlign.start,
            maxLines: 2,
            top: 8,
            text:
            "Fresh Cut, Fresh Start! 🔥💈 Kickstart your day with confidence!#BarberLife #StayFresh",
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: AppColors.black,
          ),
          Row(
            children: [
              // Favorite Button
              Container(
                margin: const EdgeInsets.only(top: 10),
                decoration: const BoxDecoration(
                    color: AppColors.secondary, shape: BoxShape.circle),
                child: IconButton(
                  onPressed: onFavoritePressed,
                  icon: const Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                  ),
                ),
              ),
              CustomText(
                textAlign: TextAlign.start,
                left: 8,
                text: rating,
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: AppColors.black,
              ),
              const Spacer(),
              // Visit Shop Button
              Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: AppColors.black,
                ),
                child: const CustomText(
                  textAlign: TextAlign.start,
                  left: 8,
                  text: AppStrings.visitShop,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: AppColors.white50,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
