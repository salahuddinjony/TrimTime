import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CommonShopCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String rating;
  final String location;
  final String discount;
  final VoidCallback onSaved;
  final bool isSaved;

  const CommonShopCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.rating,
    required this.location,
    required this.discount,
    required this.onSaved,
    this.isSaved = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 233.h,
      width: 326.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: AppColors.secondary,
      ),
      child: Stack(
        children: [
          _buildBackgroundImage(),
          // buildReport(),
          // _buildDiscountLabel(),
          _buildBottomDetails(),
        ],
      ),
    );
  }

  /// Background Image with Rounded Borders
  Widget _buildBackgroundImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.r),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: 145.h,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  /// Discount Label on Top Right
  Widget buildDiscountLabel() {
    return Positioned(
        top: 10.h,
        right: 20.w,
        child: GestureDetector(
            onTap: () {
              // _showReportDialog requires context from build method
            },
            child: Icon(
              Icons.more_horiz,
              color: AppColors.white,
              size: 24.sp,
            )));
  }

  /// Discount Label on Top Right
  Widget buildReport() {
    return Positioned(
      top: 30.h,
      right: 20.w,
      child: CustomText(
        text: "${discount} OFF",
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.white50,
      ),
    );
  }

  /// Bottom Section with Details
  Widget _buildBottomDetails() {
    return Positioned(
      top: 150.h,
      left: 20.w,
      right: 20.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: title,
            fontWeight: FontWeight.w500,
            fontSize: 16.sp,
            color: AppColors.black,
          ),
          CustomText(
            text: rating,
            fontWeight: FontWeight.w500,
            fontSize: 16.sp,
            color: AppColors.black,
          ),
          Row(
            children: [
              Assets.icons.location.svg(height: 14.h, width: 14.w),
              SizedBox(width: 5.w),
              Expanded(
                child: CustomText(
                  text: location,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                  color: AppColors.white50,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 5.w),
              _buildSaveIcon(),
            ],
          ),
        ],
      ),
    );
  }

  /// Save Icon Button
  Widget _buildSaveIcon() {
    return GestureDetector(
      onTap: onSaved,
      child: Container(
          padding: EdgeInsets.all(8.r),
          decoration: const BoxDecoration(
            color: AppColors.black,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.favorite,
            color: isSaved ? Colors.red : Colors.white,
            size: 15.sp,
          )),
    );
  }
}

void showReportDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          backgroundColor: AppColors.last,
          title: GestureDetector(
            onTap: () {
              context.pop();
            },
            child: CustomText(
              text: "Report",
              fontSize: 20.sp,
              color: AppColors.white,
              fontWeight: FontWeight.w700,
            ),
          ));
    },
  );
}
