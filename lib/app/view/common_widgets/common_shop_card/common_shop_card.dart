import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CommonShopCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String rating;
  final String location;
  final String discount;
  final VoidCallback onSaved;

  const CommonShopCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.rating,
    required this.location,
    required this.discount,
    required this.onSaved,
  });

  @override
  _CommonShopCardState createState() => _CommonShopCardState();
}

class _CommonShopCardState extends State<CommonShopCard> {
  // Boolean to track the save state
  bool isSaved = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 233,
      width: 326,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.secondary,
      ),
      child: Stack(
        children: [
          _buildBackgroundImage(),
          _buildDiscountLabel(),
          _buildBottomDetails(),
        ],
      ),
    );
  }

  /// Background Image with Rounded Borders
  Widget _buildBackgroundImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: CachedNetworkImage(
        imageUrl: widget.imageUrl,
        height: 145,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  /// Discount Label on Top Right
  Widget _buildDiscountLabel() {
    return Positioned(
      top: 10,
      right: 20,
      child: CustomText(
        text: "${widget.discount} OFF",
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppColors.white50,
      ),
    );
  }

  /// Bottom Section with Details
  Widget _buildBottomDetails() {
    return Positioned(
      top: 150,
      left: 20,
      right: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: widget.title,
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: AppColors.black,
          ),
          CustomText(
            text: widget.rating,
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: AppColors.black,
          ),
          Row(
            children: [
              Assets.icons.location.svg(),
              const SizedBox(width: 5),
              CustomText(
                text: widget.location,
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: AppColors.white50,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
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
      onTap: () {
        setState(() {
          isSaved = !isSaved; // Toggle the save state
        });
        widget.onSaved(); // Call the onSaved callback passed by the parent
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: AppColors.black,
          shape: BoxShape.circle,
        ),
        child:Icon(Icons.favorite,  color: isSaved ? Colors.red : Colors.white,size: 15,)
      ),
    );
  }
}
