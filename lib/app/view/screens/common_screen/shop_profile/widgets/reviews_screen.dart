import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/rate/widgets/review_card.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/rate/widgets/review_shimmer_card.dart';
import 'package:barber_time/app/view/screens/user/home/controller/user_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class ReviewsScreen<T> extends StatelessWidget {
  final UserRole userRole;
  final T controller;
  final String userId;
  final String salonName;
  const ReviewsScreen(
      {super.key,
      required this.userRole,
      required this.controller,
      required this.userId,
      required this.salonName});

  @override
  Widget build(BuildContext context) {
    final dynamic controller = this.controller;
    // final UserHomeController controller = this.controller as UserHomeController;

    final extra = GoRouter.of(context).state.extra;
    // Determine user role whether passed directly or inside an extra map.
    UserRole? userRole;
    if (extra is UserRole) {
      userRole = extra;
    } else if (extra is Map && extra['userRole'] is UserRole) {
      userRole = extra['userRole'] as UserRole;
    } else {
      userRole = null;
    }
    return Scaffold(
      ///============================ Header ===============================
      appBar: CustomAppBar(
        appBarContent: salonName,
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
                Color.fromARGB(
                    204, 237, 172, 172), // First color (with opacity)
                Color(0xFFE9874E),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Obx(() {
              final reviews = controller.barberReviews;
              final isLoadingReviews = controller.isLoadingReviews.value;

              // Show shimmer while loading reviews
              if (isLoadingReviews) {
                return ListView.separated(
                  padding: const EdgeInsets.only(top: 2, bottom: 10),
                  itemCount: 4,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) =>
                      const Card(elevation: 1, child: ReviewShimmerCard()),
                );
              }

              // Show empty state only when not loading and no data
              if (reviews.isEmpty) {
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
                        text:
                            'Reviews will appear here once customers\nstart rating your service',
                        fontSize: 14,
                        textAlign: TextAlign.center,
                        color: Colors.grey[600]!,
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async =>
                    await controller.getBarberReviews(userId: userId),
                child: ListView.separated(
                  padding: const EdgeInsets.only(top: 2, bottom: 10),
                  itemCount: reviews.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 2),
                  itemBuilder: (context, index) {
                    final r = reviews[index];
                    return Card(
                      elevation: 1,
                      child: ReviewCard(review: r),
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
