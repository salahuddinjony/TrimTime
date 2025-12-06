import 'package:barber_time/app/global/helper/extension/extension.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/screens/common_screen/my_loyality/models/loyality_data_model.dart';
import 'package:barber_time/app/view/screens/user/home/controller/user_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MyLoyality extends StatelessWidget {
  final UserRole userRole;
  final UserHomeController controller;

  const MyLoyality(
      {super.key, required this.userRole, required this.controller});

  @override
  Widget build(BuildContext context) {
    final extra = GoRouter.of(context).state.extra;
    UserRole? userRole;
    if (extra is UserRole) {
      userRole = extra;
    } else if (extra is Map && extra['userRole'] is UserRole) {
      userRole = extra['userRole'] as UserRole;
    } else {
      userRole = null;
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        iconData: Icons.arrow_back,
        appBarContent: "My Loyalty Rewards",
        appBarBgColor: AppColors.searchScreenBg,
      ),
      body: Obx(() {
        if (controller.loyalityStatus.value.isLoading) {
          return _buildShimmerLoading();
        }

        if (controller.loyalityStatus.value.isError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline,
                    size: 60.sp, color: AppColors.gray500),
                SizedBox(height: 16.h),
                CustomText(
                  text: 'Failed to load loyalty data',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () => controller.fetchLoyalityRewards(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange500,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.loyalityList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.card_giftcard,
                    size: 60.sp, color: AppColors.gray500),
                SizedBox(height: 16.h),
                CustomText(
                  text: 'No loyalty rewards yet',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
                SizedBox(height: 8.h),
                CustomText(
                  text: 'Visit salons to start earning rewards!',
                  fontSize: 14.sp,
                  color: AppColors.gray300,
                ),
              ],
            ),
          );
        }

        final totalPoints = controller.loyalityList
            .fold<int>(0, (sum, salon) => sum + salon.totalPoints);

        return RefreshIndicator(
          onRefresh: () async {
            await controller.fetchLoyalityRewards();
          },
          color: AppColors.orange500,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.searchScreenBg,
                        const Color.fromARGB(255, 226, 185, 3)
                            .withValues(alpha: 0.8)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.r),
                      bottomRight: Radius.circular(30.r),
                    ),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                    child: Column(
                      children: [
                        Icon(Icons.card_giftcard,
                            size: 40.sp, color: AppColors.white50),
                        SizedBox(height: 12.h),
                        CustomText(
                          text: "Track your visits and earn rewards!",
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white50,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20.h),
                        // Container(
                        //   padding: EdgeInsets.all(16.r),
                        //   decoration: BoxDecoration(
                        //     color: AppColors.white50,
                        //     borderRadius: BorderRadius.circular(16.r),
                        //     boxShadow: [
                        //       BoxShadow(
                        //         color: Colors.black.withOpacity(0.1),
                        //         blurRadius: 10,
                        //         offset: const Offset(0, 4),
                        //       ),
                        //     ],
                        //   ),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       Icon(Icons.stars, color: AppColors.orange700, size: 28.sp),
                        //       SizedBox(width: 8.w),
                        //       CustomText(
                        //         text: "$totalPoints",
                        //         fontWeight: FontWeight.w700,
                        //         fontSize: 28.sp,
                        //         color: AppColors.orange700,
                        //       ),
                        //       SizedBox(width: 8.w),
                        //       CustomText(
                        //         text: "Total Points",
                        //         fontWeight: FontWeight.w500,
                        //         fontSize: 14.sp,
                        //         color: AppColors.black,
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "Your Loyalty Salons",
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                        bottom: 16.h,
                      ),
                      ...controller.loyalityList.map((salon) {
                        return _buildSalonCard(context, salon, userRole);
                      }).toList(),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 200.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.r),
                  bottomRight: Radius.circular(30.r),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: List.generate(3, (index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    height: 120.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalonCard(
      BuildContext context, VisitedSaloon salon, UserRole? userRole) {
    final hasApplicableOffers = salon.applicableOffers.isNotEmpty;
    final highestOffer = hasApplicableOffers
        ? salon.applicableOffers
            .reduce((a, b) => a.percentage > b.percentage ? a : b)
        : null;

    return GestureDetector(
      onTap: () {
        _showSalonDetails(context, salon, userRole);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          gradient: hasApplicableOffers
              ? LinearGradient(
                  colors: [Colors.amber[100]!, Colors.orange[100]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [
                    AppColors.orange500.withValues(alpha: 0.9),
                    AppColors.orange700
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: hasApplicableOffers
                  ? Colors.amber.withValues(alpha: 0.3)
                  : AppColors.orange500.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 70.w,
              height: 70.w,
              child: CircularPercentIndicator(
                radius: 35.w,
                lineWidth: 6.0,
                percent: (salon.offers.isNotEmpty
                    ? (salon.totalPoints / salon.offers.last.pointThreshold)
                        .clamp(0.0, 1.0)
                    : (salon.totalPoints / 100).clamp(0.0, 1.0)),
                center: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      text: "${salon.visitCount}",
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: hasApplicableOffers
                          ? AppColors.black
                          : AppColors.white50,
                    ),
                    CustomText(
                      text: "visits",
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: hasApplicableOffers
                          ? AppColors.black
                          : AppColors.white50,
                    ),
                  ],
                ),
                backgroundColor: Colors.white.withValues(alpha: 0.3),
                progressColor: hasApplicableOffers
                    ? AppColors.orange700
                    : AppColors.white50,
                circularStrokeCap: CircularStrokeCap.round,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: salon.shopName,
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                    color: hasApplicableOffers
                        ? AppColors.black
                        : AppColors.white50,
                    maxLines: 1,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.stars,
                        size: 16.sp,
                        color: hasApplicableOffers
                            ? AppColors.orange700
                            : AppColors.white50,
                      ),
                      SizedBox(width: 4.w),
                      CustomText(
                        text: "${salon.totalPoints} points",
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        color: hasApplicableOffers
                            ? AppColors.black
                            : AppColors.white50,
                      ),
                    ],
                  ),
                  if (highestOffer != null) ...[
                    SizedBox(height: 6.h),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppColors.orange700,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.local_offer,
                              size: 12.sp, color: AppColors.white50),
                          SizedBox(width: 4.w),
                          CustomText(
                            text: "${highestOffer.percentage}% OFF Available!",
                            fontWeight: FontWeight.w700,
                            fontSize: 12.sp,
                            color: AppColors.white50,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 20.sp,
              color: hasApplicableOffers ? AppColors.black : AppColors.white50,
            ),
          ],
        ),
      ),
    );
  }

  void _showSalonDetails(
      BuildContext context, VisitedSaloon salon, UserRole? userRole) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.5,
          maxChildSize: 0.75,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 12.h),
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.gray300,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: EdgeInsets.all(20.r),
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12.r),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.orange500.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Icon(Icons.store,
                                  size: 32.sp, color: AppColors.orange700),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: salon.shopName,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.black,
                                  ),
                                  SizedBox(height: 4.h),
                                  CustomText(
                                    text:
                                        "Customer: ${salon.customerName.toString().safeCap()}",
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.gray300,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                icon: Icons.calendar_today,
                                label: "Visits",
                                value: "${salon.visitCount}",
                                color: AppColors.orange500,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: _buildStatCard(
                                icon: Icons.stars,
                                label: "Points",
                                value: "${salon.totalPoints}",
                                color: AppColors.orange700,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        if (salon.applicableOffers.isNotEmpty) ...[
                          CustomText(
                            text: "🎉 Available Rewards",
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                            bottom: 12.h,
                          ),
                          ...salon.applicableOffers.map((offer) {
                            return _buildOfferCard(offer, salon.totalPoints,
                                isApplicable: true);
                          }).toList(),
                          SizedBox(height: 24.h),
                        ],
                        CustomText(
                          text: "All Rewards Program",
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                          bottom: 12.h,
                        ),
                        ...salon.offers.map((offer) {
                          return _buildOfferCard(offer, salon.totalPoints,
                              isApplicable: false);
                        }).toList(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28.sp, color: color),
          SizedBox(height: 8.h),
          CustomText(
            text: value,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: color,
          ),
          SizedBox(height: 4.h),
          CustomText(
            text: label,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.gray300,
          ),
        ],
      ),
    );
  }

  Widget _buildOfferCard(Offer offer, int totalPoints,
      {required bool isApplicable}) {
    // Use the offer's discount percentage for the circular progress
    final progress = (offer.percentage / 100).clamp(0.0, 1.0);

    // Display the discount percentage
    final progressPercentage = offer.percentage;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: offer.eligible && isApplicable
            ? Colors.green[50]
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color:
              offer.eligible && isApplicable ? Colors.green : Colors.grey[300]!,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 60.w,
            height: 60.w,
            child: CircularPercentIndicator(
              radius: 30.w,
              lineWidth: 5.0,
              percent: progress,
              center: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    text: "$progressPercentage%",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: offer.eligible && isApplicable
                        ? Colors.green
                        : AppColors.orange700,
                  ),
                  if (!offer.eligible)
                    CustomText(
                      text: "earned",
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.gray500,
                    ),
                ],
              ),
              backgroundColor: Colors.grey[300]!,
              progressColor: offer.eligible && isApplicable
                  ? Colors.green
                  : AppColors.orange500,
              circularStrokeCap: CircularStrokeCap.round,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomText(
                      text: "${offer.percentage}% Discount",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                    SizedBox(width: 8.w),
                    if (offer.eligible && isApplicable)
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: CustomText(
                          text: "UNLOCKED",
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white50,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4.h),
                CustomText(
                  text: offer.eligible && isApplicable
                      ? "You can redeem this offer!"
                      : "Need ${offer.pointsNeeded} more points (${offer.pointThreshold} total)",
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.gray300,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          if (offer.eligible && isApplicable)
            Icon(Icons.check_circle, color: Colors.green, size: 28.sp)
          else
            Icon(Icons.lock, color: AppColors.gray500, size: 24.sp),
        ],
      ),
    );
  }
}
