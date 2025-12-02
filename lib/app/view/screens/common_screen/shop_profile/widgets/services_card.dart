import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServicesCard extends StatelessWidget {
  final String serviceName;
  final double price;
  final int duration;
  final bool isActive;
  final bool isSelected;
  final Color activeColor = Colors.green;

  const ServicesCard(
      {super.key,
      required this.serviceName,
      required this.price,
      required this.duration,
      this.isSelected = false,
      required this.isActive});

  @override
  Widget build(BuildContext context) {
    final textColor = isSelected ? Colors.white : AppColors.black;
    final priceColor = isSelected ? Colors.white : AppColors.black;
    final durationColor = isSelected ? Colors.white70 : AppColors.gray500;
    final shadowColor = isSelected
        ? Colors.black.withValues(alpha: .25)
        : AppColors.orange500.withValues(alpha: .1);

    return Container(
      width: 220,
      margin: EdgeInsets.only(right: 12.w, bottom: 8.h, top: 4.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: activeColor,
        gradient: isSelected
            ? LinearGradient(
                colors: [
                  const Color.fromARGB(255, 199, 69, 18),
                  const Color.fromARGB(255, 166, 216, 87),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [
                  AppColors.orange500.withValues(alpha: .1),
                  AppColors.last.withValues(alpha: .05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:AppColors.white ,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: isSelected ? 16 : 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isSelected
                  ? Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 20,
                    )
                  : SizedBox.shrink(),
              Expanded(
                child: CustomText(
                  text: serviceName,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  maxLines: 2,
                ),
              ),
              if (isActive)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CustomText(
                    text: "Active",
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16,
                color: isSelected ? Colors.white : AppColors.orange500,
              ),
              SizedBox(width: 6.w),
              CustomText(
                text: "$duration min",
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: durationColor,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(
                Icons.attach_money,
                size: 18,
                color: isSelected ? Colors.white : AppColors.orange500,
              ),
              Flexible(
                child: CustomText(
                  text: "$price",
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: priceColor,
                ),
              ),
            ],
          ),
          // ...existing code...
        ],
      ),
    );
  }
}
