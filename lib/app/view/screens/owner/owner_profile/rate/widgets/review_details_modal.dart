import 'package:barber_time/app/global/helper/extension/extension.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/common_widgets/view_image_gallery/widgets/design_files_gallery.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/rate/models/review_response_model.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/rate/widgets/star_rating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewDetailsModal extends StatelessWidget {
  final ReviewData review;

  const ReviewDetailsModal({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              // Header with drag handle and close button
              Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 12, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.grey[100],
                      shape: const CircleBorder(),
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        customBorder: const CircleBorder(),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            Icons.close,
                            size: 20,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Customer Info Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Row(
                          children: [
                            CustomNetworkImage(
                              boxShape: BoxShape.circle,
                              imageUrl: review.customerImage.isNotEmpty
                                  ? review.customerImage
                                  : AppConstants.demoImage,
                              height: 60,
                              width: 60,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: review.customerName.isNotEmpty
                                        ? review.customerName.safeCap()
                                        : 'Anonymous',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.black,
                                  ),
                                  const SizedBox(height: 4),
                                  CustomText(
                                    text: 'Customer',
                                    fontSize: 13,
                                    color: Colors.grey[600]!,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Rating Section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.amber.shade50,
                              Colors.orange.shade50,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.amber.shade200),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            StarRating(
                                rating: review.rating.toDouble(), size: 28),
                            const SizedBox(width: 12),
                            CustomText(
                              text: '${review.rating}.0',
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Colors.amber.shade900,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Review Section
                      _SectionTitle(title: 'Review'),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: CustomText(
                          text: review.comment.isNotEmpty
                              ? review.comment
                              : 'No comment provided',
                          fontSize: 15,
                          color: AppColors.black,
                          left: 0,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                        ),
                      ),

                      if (review.images.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        _SectionTitle(title: 'Photos'),
                        const SizedBox(height: 12),
                        DesignFilesGallery(
                          designFiles: review.images,
                          height: 120,
                          width: 120,
                        ),
                      ],

                      const SizedBox(height: 20),

                      // Barber Section
                      _SectionTitle(title: 'Barber'),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Row(
                          children: [
                            CustomNetworkImage(
                              boxShape: BoxShape.circle,
                              imageUrl: review.barberImage.isNotEmpty
                                  ? review.barberImage
                                  : AppConstants.demoImage,
                              height: 50,
                              width: 50,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: review.barberName.isNotEmpty
                                      ? review.barberName
                                      : 'Unknown',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.black,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.content_cut,
                                      size: 14,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 4),
                                    CustomText(
                                      text: review.saloonName.isNotEmpty
                                          ? review.saloonName
                                          : 'Unknown',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.bodyGrayMedium,
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Salon Section
                      _SectionTitle(title: 'Salon'),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomNetworkImage(
                              boxShape: BoxShape.circle,
                              imageUrl: review.saloonLogo.isNotEmpty
                                  ? review.saloonLogo
                                  : AppConstants.demoImage,
                              height: 50,
                              width: 50,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: review.saloonName.isNotEmpty
                                        ? review.saloonName
                                        : 'Unknown',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.black,
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 14,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 4),
                                      CustomText(
                                        text: review.saloonAddress.isNotEmpty
                                            ? review.saloonAddress
                                            : 'No address',
                                        fontSize: 12,
                                        color: Colors.grey[600]!,
                                        left: 0,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Dates Section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue.shade100),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        size: 14,
                                        color: Colors.blue[700],
                                      ),
                                      const SizedBox(width: 6),
                                      CustomText(
                                        text: 'Appointment Date',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.blue[700]!,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  CustomText(
                                    text: review.appointmentAt != null
                                        ? '${review.appointmentAt!.toLocal()}'
                                            .split(' ')[0]
                                        : 'N/A',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.black,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: Colors.blue[200],
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.rate_review,
                                        size: 14,
                                        color: Colors.blue[700],
                                      ),
                                      const SizedBox(width: 6),
                                      CustomText(
                                        text: 'Review Date',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.blue[700]!,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  CustomText(
                                    text: review.createdAt != null
                                        ? '${review.createdAt!.toLocal()}'
                                            .split(' ')[0]
                                        : 'N/A',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.black,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Close Button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE9874E),
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                elevation: 0,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const CustomText(
                                text: 'Close',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text: title,
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: AppColors.black,
    );
  }
}
