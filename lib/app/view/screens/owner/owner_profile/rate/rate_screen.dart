import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/settings/info_controller/info_controller.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/rate/models/review_response_model.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class RateScreen extends StatelessWidget {
  RateScreen({
    super.key,
  });

  final InfoController infoController = Get.find<InfoController>();

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (!infoController.isLoading.value && infoController.barberReviews.isEmpty) {
    //     infoController.getBarberReviews();
    //   }
    // });
    final extra = GoRouter.of(context).state.extra;
    UserRole? userRole;
    if (extra is UserRole) {
      userRole = extra;
    } else if (extra is Map) {
      try {
        userRole = extra['userRole'] as UserRole?;
      } catch (_) {
        userRole = null;
      }
    }

    debugPrint("===================${userRole?.name}");
    if (userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }
    return Scaffold(
      ///============================ Header ===============================
      appBar: const CustomAppBar(
        appBarContent: AppStrings.ratings,
        iconData: Icons.arrow_back,
        appBarBgColor: AppColors.linearFirst,
      ),

      ///============================ body ===============================
      body: ClipPath(
        clipper: CurvedBannerClipper(),
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xCCEDC4AC), // First color (with opacity)
                Color(0xFFE9874E),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Obx(() {
              if (infoController.isLoading.value) {
                return ListView.separated(
                  padding: const EdgeInsets.only(top: 2, bottom: 10),
                  itemCount: 4,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) =>
                      const Card(elevation: 1, child: _ReviewShimmerCard()),
                );
              }

              final reviews = infoController.barberReviews;
              final displayReviews = reviews;

              // Show empty state when no reviews
              if (displayReviews.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.rate_review_outlined,
                        size: 80,
                        color: Colors.white.withValues(alpha: .8), 
                      ),
                      const SizedBox(height: 16),
                      CustomText(
                        text: 'No Reviews Yet',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700]!,
                      ),
                      const SizedBox(height: 8),
                      CustomText(
                        text: 'Reviews will appear here once customers\nstart rating your service',
                        fontSize: 14,
                        textAlign: TextAlign.center,
                        color: Colors.grey[600]!,
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async => await infoController.getBarberReviews(),
                child: ListView.separated(
                  padding: const EdgeInsets.only(top: 2, bottom: 10),
                  itemCount: displayReviews.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 2),
                  itemBuilder: (context, index) {
                    final r = displayReviews[index];
                    return Card(
                      elevation: 1,
                      child: _ReviewCard(review: r),
                    );
                  },
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final ReviewData review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            imageUrl: review.saloonLogo.isNotEmpty
                ? review.saloonLogo
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
                        text: review.saloonName.isNotEmpty
                            ? review.saloonName
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
                        _StarRating(rating: review.rating.toDouble(), size: 18),
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
                  text:
                      review.comment.isNotEmpty ? review.comment : 'No comment',
                  fontSize: 13,
                  color: AppColors.black,
                ),
                const SizedBox(height: 8),
                CustomText(
                  text: review.createdAt != null
                      ? '${review.createdAt!.toLocal()}'.split(' ')[0]
                      : '',
                  fontSize: 12,
                  color: AppColors.black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StarRating extends StatelessWidget {
  final double rating;
  final double size;

  const _StarRating({required this.rating, this.size = 16});

  @override
  Widget build(BuildContext context) {
    final stars = List<Widget>.generate(5, (index) {
      final starIndex = index + 1;
      IconData icon;
      Color color;
      if (rating >= starIndex) {
        icon = Icons.star;
        color = Colors.amber;
      } else {
        icon = Icons.star_border;
        color = Colors.grey;
      }
      return Icon(
        icon,
        size: size,
        color: color,
        shadows: [
          Shadow(
            color: Colors.black.withValues(alpha: .25),
            offset: const Offset(1, 2),
            blurRadius: 4,
          ),
        ],
      );
    });

    return Row(mainAxisSize: MainAxisSize.min, children: stars);
  }
}

class _ReviewShimmerCard extends StatelessWidget {
  const _ReviewShimmerCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: 44,
                height: 44,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Container(height: 14, color: Colors.white)),
                      const SizedBox(width: 8),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          SizedBox(
                              width: 60,
                              height: 12,
                              child: ColoredBox(color: Colors.white)),
                          SizedBox(height: 4),
                          SizedBox(
                              width: 36,
                              height: 12,
                              child: ColoredBox(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(height: 12, color: Colors.white),
                  const SizedBox(height: 8),
                  Container(height: 12, width: 100, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
