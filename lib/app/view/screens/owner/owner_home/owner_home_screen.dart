import 'package:barber_time/app/core/bottom_navbar.dart';
import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/common_home_app_bar/common_home_app_bar.dart';
import 'package:barber_time/app/view/common_widgets/custom_feed_card/custom_feed_card.dart';
import 'package:barber_time/app/view/common_widgets/custom_hiring_pending_card/custom_hiring_pending_card.dart';
import 'package:barber_time/app/view/common_widgets/custom_info_card/custom_info_card.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/common_widgets/custom_title/custom_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class OwnerHomeScreen extends StatelessWidget {
  OwnerHomeScreen({super.key});

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final userRole = GoRouter.of(context).state.extra as UserRole?;

    debugPrint("===================${userRole?.name}");
    if (userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }
    return Scaffold(
      bottomNavigationBar: BottomNavbar(
        currentIndex: 0,
        role: userRole,
      ),
      body: Column(
        children: [
          ///: <<<<<<======🗄️🗄️🗄️🗄️🗄️🗄️💡💡 Appbar💡💡🗄️🗄️🗄️🗄️🗄️🗄️🗄️>>>>>>>>===========
          CommonHomeAppBar(
            uniqueQrCode: () {
              AppRouter.route
                  .pushNamed(RoutePath.uniqueQrCode, extra: userRole);
            },
            isDashboard: true,
            onDashboard: () async {
              final Uri url = Uri.parse('https://barber-shift-dashboard.vercel.app/');
              debugPrint("Dashboard button clicked");

              if (await canLaunchUrl(url)) {
                bool launched = await launchUrl(url, mode: LaunchMode.platformDefault);
                if (!launched) {
                  debugPrint("Failed to launch URL with platformDefault mode, trying externalApplication");
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              } else {
                debugPrint("Could not launch $url");
              }
            },

            onCalender: () {
              AppRouter.route
                  .pushNamed(RoutePath.scheduleScreen, extra: userRole);
            },
            scaffoldKey: scaffoldKey,
            name: "Masum",
            image: AppConstants.demoImage,
            onTap: () {
              AppRouter.route
                  .pushNamed(RoutePath.notificationScreen, extra: userRole);
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              // Wrap everything in a SingleChildScrollView
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            CustomInfoCard(
                              title: AppStrings.totalCustomer, // Title text
                              value: "00",
                              image: Assets.images.totalCustomer
                                  .image(), // Dynamic value (could be fetched from a database)
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            CustomInfoCard(
                              image: Assets.images.totalBarber.image(),
                              title: AppStrings.totalBarber, // Title text
                              value:
                                  "00", // Dynamic value (could be fetched from a database)
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            CustomInfoCard(
                              image: Assets.images.hiringSelected.image(),

                              title: AppStrings.hiringPost, // Title text
                              value:
                                  "00", // Dynamic value (could be fetched from a database)
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            CustomInfoCard(
                              image: Assets.images.barberRequest.image(),

                              title: AppStrings.barberRequest, // Title text
                              value:
                                  "00", // Dynamic value (could be fetched from a database)
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            CustomInfoCard(
                              image: Assets.images.pending.image(),

                              title: AppStrings.pending, // Title text
                              value:
                                  "00", // Dynamic value (could be fetched from a database)
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            CustomInfoCard(
                              image: Assets.images.waiting.image(),

                              title: AppStrings.waiting, // Title text
                              value:
                                  "00", // Dynamic value (could be fetched from a database)
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 12.h,
                    ),

                    ///: <<<<<<======✅✅ recentRequest✅✅>>>>>>>>===========
                    CustomTitle(
                      title: AppStrings.recentRequest,
                      actionText: AppStrings.seeAll,
                      onActionTap: () {
                        AppRouter.route.pushNamed(RoutePath.recentRequestScreen,
                            extra: userRole);
                      },
                      actionColor: AppColors.secondary,
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    // Barber shop cards
                    Column(
                      children: List.generate(2, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: GestureDetector(
                            onTap: () {
                              AppRouter.route.pushNamed(RoutePath.visitShop,
                                  extra: userRole);
                            },
                            child: CustomHiringCard(
                              isMessage: true,
                              imageUrl: AppConstants.demoImage,
                              // Image URL (dynamic)
                              name: "Unknown",
                              // Dynamic title (Job name)
                              role: "Barber",
                              // Hardcoded or dynamic role
                              rating: 4.5,
                              // Hardcoded or dynamic rating
                              location: "New York, USA",
                              // Dynamic location or hardcoded
                              onHireTap: () {}, // Hire button action
                            ),
                          ),
                        );
                      }),
                    ),

                    Row(
                      children: [
                        CustomText(
                          textAlign: TextAlign.start,
                          text:
                              'You have 5 \n appointments waiting for you today!',
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                          color: AppColors.black,
                          bottom: 20,
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            context.pushNamed(RoutePath.ownerRequestBooking,
                                extra: userRole);
                          },
                          child: const Text(
                            AppStrings.seeAll,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    ///: <<<<<<======✅✅ Feed✅✅>>>>>>>>===========

                    CustomTitle(
                      title: "Feed",
                      actionText: AppStrings.seeAll,
                      onActionTap: () {
                        AppRouter.route
                            .pushNamed(RoutePath.feedAll, extra: userRole);
                      },
                      actionColor: AppColors.secondary,
                    ),

                    SizedBox(
                      height: 12.h,
                    ),

                    // Feed Cards Section
                    Column(
                      children: List.generate(4, (index) {
                        return CustomFeedCard(
                          userImageUrl: AppConstants.demoImage,
                          userName: "Roger Hunt",
                          userAddress:
                              "2972 Westheimer Rd. Santa Ana, Illinois 85486",
                          postImageUrl: AppConstants.demoImage,
                          postText:
                              "Fresh Cut, Fresh Start! 🔥💈 Kickstart your day with confidence!#BarberLife #StayFresh",
                          rating: "5.0 * (169)",
                          onFavoritePressed: () {
                            // Handle favorite button press
                          },
                          onVisitShopPressed: () {
                            AppRouter.route.pushNamed(RoutePath.visitShop,
                                extra: userRole);
                            // Handle visit shop button press
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
