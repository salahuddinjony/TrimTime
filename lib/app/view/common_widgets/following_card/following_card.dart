import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter/material.dart';

class FollowingCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String status; // Can be 'follow' or 'unfollow'
  final VoidCallback onUnfollowPressed;

  const FollowingCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.status,
    required this.onUnfollowPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: AppColors.linearFirst,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Profile Image
            CustomNetworkImage(
              boxShape: BoxShape.circle,
              imageUrl: imageUrl, // Dynamic Image URL
              height: 45,
              width: 45,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Name
                  CustomText(
                    text: name,
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: AppColors.black,
                  ),
                  Row(
                    children: [
                      // Username Subtitle or Role
                      CustomText(
                        text: name, // You can pass a different subtitle if needed
                        fontWeight: FontWeight.w300,
                        fontSize: 11,
                        color: AppColors.black,
                      ),
                      const Spacer(),
                      // Unfollow Button
                      GestureDetector(
                        onTap: onUnfollowPressed, // Trigger unfollow action
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.white50,
                            border: Border.all(color: AppColors.gray500),
                            borderRadius: const BorderRadius.all(Radius.circular(4)),
                          ),
                          child: CustomText(
                            text: status, // 'Follow' or 'Unfollow'
                            fontSize: 15,
                            color: AppColors.black,
                          ),
                        ),
                      )
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
