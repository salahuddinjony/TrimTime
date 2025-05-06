import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomFeedCard extends StatefulWidget {
  final String userImageUrl;
  final String userName;
  final String userAddress;
  final String postImageUrl;
  final String postText;
  final String rating;
  final VoidCallback onFavoritePressed;
  final VoidCallback onVisitShopPressed;
  final bool? isVisitSHopButton;

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
    this.isVisitSHopButton = false,
  });

  @override
  _CustomFeedCardState createState() => _CustomFeedCardState();
}

class _CustomFeedCardState extends State<CustomFeedCard> {
  // Variable to track if the item is favorited or not
  bool isFavorite = false;

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
                imageUrl: widget.userImageUrl,
                height: 48,
                width: 48,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      left: 8,
                      text: widget.userName,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: AppColors.black,
                    ),
                    CustomText(
                      left: 8,
                      text: widget.userAddress,
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
            imageUrl: widget.postImageUrl,
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
          widget.isVisitSHopButton == true
              ? const SizedBox()
              : Row(
            children: [
              // Favorite Button
              Container(
                margin: const EdgeInsets.only(top: 10),
                decoration: const BoxDecoration(
                    color: AppColors.secondary, shape: BoxShape.circle),
                child: IconButton(
                  onPressed: _toggleFavorite,
                  icon: Icon(
                    isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.white, // Red when favorited
                  ),
                ),
              ),
              CustomText(
                textAlign: TextAlign.start,
                left: 8,
                text: widget.rating,
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: AppColors.black,
              ),
              const Spacer(),
              // Visit Shop Button
              GestureDetector(
                onTap: widget.onVisitShopPressed,
                child: Container(
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
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Function to toggle the favorite state
  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite; // Toggle the favorite state
    });
    widget.onFavoritePressed(); // Call the onFavoritePressed callback
  }
}
