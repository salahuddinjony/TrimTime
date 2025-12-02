import 'package:barber_time/app/global/helper/extension/extension.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/rate/models/review_response_model.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/rate/widgets/review_details_modal.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/rate/widgets/star_rating.dart';
import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  final ReviewData review;

  const ReviewCard({required this.review});

  void _showReviewDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ReviewDetailsModal(review: review),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showReviewDetails(context),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomNetworkImage(
              boxShape: BoxShape.circle,
              imageUrl: review.customerImage.isNotEmpty
                  ? review.customerImage
                  : AppConstants.demoImage,
              height: 44,
              width: 44,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomText(
                          textAlign: TextAlign.start,
                          text: review.customerName.isNotEmpty
                              ? review.customerName.safeCap()
                              : 'Anonymous',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          StarRating(
                              rating: review.rating.toDouble(), size: 18),
                          const SizedBox(height: 2),
                          CustomText(
                            text: '${review.rating}/5',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  CustomText(
                    left: 0,
                    text: review.comment.isNotEmpty
                        ? review.comment
                        : 'No comment',
                    fontSize: 13,
                    color: AppColors.black,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      CustomText(
                        text: review.createdAt != null
                            ? '${review.createdAt!.formatDate()}'
                            : '',
                        fontSize: 12,
                        color: AppColors.black,
                        textAlign: TextAlign.left,
                      ),
                      const Spacer(),
                      Icon(Icons.chevron_right,
                          size: 20, color: AppColors.black),
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
