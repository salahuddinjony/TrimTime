import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/common_shop_card/common_shop_card.dart';
import 'package:barber_time/app/view/common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/screens/common_screen/shop_profile/widgets/rating_dialog.dart';
import 'package:barber_time/app/view/screens/user/home/controller/user_home_controller.dart';
import 'package:barber_time/app/view/screens/user/home/customer_review/widgets/seloon_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerReviewScreen extends StatelessWidget {
  final UserRole userRole;
  final UserHomeController controller;
  CustomerReviewScreen({
    super.key,
    required this.userRole,
    required this.controller,
  });
  @override
  Widget build(BuildContext context) {
    // Use the widget's userRole and controller directly
    debugPrint("===================${userRole.name}");
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
              final SelonList = controller.customerReviewsList;
              if (controller.customerReviewStatus.value.isLoading) {
                return ListView.separated(
                  padding: const EdgeInsets.only(top: 2, bottom: 10),
                  itemCount: 4,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) => SeloonShimmer(),
                );
              }

              final reviews = controller.customerReviewsList;
              final displayReviews = reviews;

              // Show empty state when no reviews, with pull-to-refresh
              if (displayReviews.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () async {
                    await controller.fetchCustomerReviews();
                  },
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.rate_review_outlined,
                                size: 80,
                                color: Colors.white.withOpacity(.8),
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
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  // Call the controller's fetch method to refresh reviews
                  await controller.fetchCustomerReviews();
                },
                child: ListView.separated(
                  padding: const EdgeInsets.only(top: 2, bottom: 10),
                  itemCount: displayReviews.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 2),
                  itemBuilder: (context, index) {
                    final salon = SelonList[index];
                    return GestureDetector(
                      onTap: () {
                        RatingDialog.showRatingDialog(
                          context,
                          userRole: userRole,
                          controller: controller,
                          saloonId: salon.userId,
                          barberId: salon.barberId,
                          bookingId: salon.bookingId,
                        );
                        // Handle card tap if needed
                      },
                      child: CommonShopCard(
                        imageUrl: salon.saloonLogo,
                        title: salon.saloonName,
                        rating: "${salon.ratingCount} ★",
                        location: salon.saloonAddress,
                        discount: '',
                        onSaved: () => debugPrint("Saved Clicked!"),
                      ),
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
