import 'package:barber_time/app/global/helper/extension/extension.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FollowingCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String? email;
  final String status;
  final VoidCallback onUnfollowPressed;
  final bool? isFollower;

  const FollowingCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.status,
    this.email,
    required this.onUnfollowPressed,
    this.isFollower = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.r),
      child: Container(
        padding:
            isFollower == true ? EdgeInsets.all(15.r) : EdgeInsets.all(25.r),
        decoration: BoxDecoration(
          color: AppColors.linearFirst,
          borderRadius: BorderRadius.all(Radius.circular(8.r)),
          border: Border.all(
              color: isFollower == true ? AppColors.white : AppColors.gray500,
              width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Profile Image
            CustomNetworkImage(
              boxShape: BoxShape.circle,
              imageUrl: imageUrl, // Dynamic Image URL
              height: isFollower == true ? 45.r : 50.r,
              width: isFollower == true ? 45.r : 50.r,
            ),
            SizedBox(width: 12.r),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Name
                  CustomText(
                    text: name.safeCap(),
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: AppColors.black,
                  ),
                  SizedBox(height: email != null ? 4 : 0),
                  Row(
                    children: [
                      // Username Subtitle or Role
                      Icon(Icons.email, size: 12, color: AppColors.gray500),
                      const SizedBox(width: 4),
                      CustomText(
                        text: email ??
                            'N/A', // You can pass a different subtitle if needed
                        fontWeight: FontWeight.w300,
                        fontSize: 11,
                        color: AppColors.black,
                      ),
                      const Spacer(),
                      // Unfollow Button
                      isFollower == true
                          ? GestureDetector(
                              onTap:
                                  onUnfollowPressed, // Trigger unfollow action
                              child: Container(
                                padding: EdgeInsets.all(6.r),
                                decoration: BoxDecoration(
                                  color: AppColors.white50,
                                  border: Border.all(color: AppColors.gray500),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.r)),
                                ),
                                child: CustomText(
                                  text: status, // 'Follow' or 'Unfollow'
                                  fontSize: 14.sp,
                                  color: AppColors.black,
                                ),
                              ),
                            )
                          : const SizedBox()
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
