import 'package:barber_time/app/core/bottom_navbar.dart';
import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/common_home_app_bar/common_home_app_bar.dart';
import 'package:barber_time/app/view/common_widgets/common_shop_card/common_shop_card.dart';
import 'package:barber_time/app/view/common_widgets/custom_card/custom_card.dart';
import 'package:barber_time/app/view/common_widgets/custom_feed_card/custom_feed_card.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/common_widgets/custom_title/custom_title.dart';
import 'package:barber_time/app/view/screens/user/home/controller/user_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final UserHomeController homeController = Get.find<UserHomeController>();

  @override
  Widget build(BuildContext context) {
    final userRole = GoRouter.of(context).state.extra as UserRole?;

    if (userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }

    return Scaffold(
      floatingActionButton: IconButton(
        onPressed: () {
          AppRouter.route
              .pushNamed(RoutePath.scannerScreen, extra: userRole);
        },
        icon: Container(
          height: 79,
          width: 79,
          padding: EdgeInsets.all(12.r),  // You can adjust the padding as needed
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.navColor,  // Custom color for the button
          ),
          child: Assets.images.scanner.image(color: AppColors.black),  // Scanner icon
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomNavbar(currentIndex: 0, role: userRole),
      body: Column(
        children: [
          /// 🏡 Common Home AppBar
          CommonHomeAppBar(
            isSearch: true,
            onSearch: () => AppRouter.route
                .pushNamed(RoutePath.searchSaloonScreen, extra: userRole),
            scaffoldKey: scaffoldKey,
            name: "Anwer",
            image: AppConstants.demoImage,
            onTap: () => AppRouter.route
                .pushNamed(RoutePath.notificationScreen, extra: userRole),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomCard(
                          onTap: () {
                            AppRouter.route.pushNamed(
                                RoutePath.nearYouShopScreen,
                                extra: userRole);
                          },
                          title: "Bookings",
                          icon: Assets.icons.bookings.svg()),


                      CustomCard(
                          onTap: () {
                            AppRouter.route.pushNamed(RoutePath.myLoyality,
                                extra: userRole);
                          },
                          title: "Loyalty",
                          icon: Assets.icons.loyalitys.svg()),
                      CustomCard(
                          onTap: () {
                            AppRouter.route.pushNamed(RoutePath.scannerScreen,
                                extra: userRole);
                          },
                          title: "Queue",
                          icon: Assets.icons.ques.svg()),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomCard(
                          onTap: () {
                            AppRouter.route.pushNamed(
                                RoutePath.shopProfileScreen,
                                extra: userRole);
                          },
                          title: "Review",
                          icon: Assets.icons.reviews.svg()),
                      CustomCard(
                          onTap: () {
                            _showTipDialog(context);
                          },
                          title: "Tips",
                          icon: Assets.icons.tips.svg(height: 35)),
                      CustomCard(
                          onTap: () {
                            AppRouter.route.pushNamed(RoutePath.mapViewScreen,
                                extra: userRole);
                          },
                          title: "MapView",
                          icon: Assets.icons.mapview.svg()),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),

                  /// 🔥 Near You Section
                  CustomTitle(
                    title: AppStrings.nearYou,
                    actionText: AppStrings.seeAll,
                    onActionTap: () => AppRouter.route.pushNamed(
                        RoutePath.nearYouShopScreen,
                        extra: userRole),
                    actionColor: AppColors.secondary,
                  ),
                  SizedBox(height: 12.h),

                  /// 📌 Horizontal Scroll for Shops

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(4, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: CommonShopCard(
                            imageUrl: AppConstants.shop,
                            title: "Barber Time ",
                            rating: "5.0 ★ (169)",
                            location: "Oldesloer Strasse 82",
                            discount: "15%",
                            onSaved: () => debugPrint("Saved Clicked!"),
                          ),
                        );
                      }),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  /// 🌟 Top Rated Section
                  CustomTitle(
                    title: "Top Rated",
                    actionText: AppStrings.seeAll,
                    onActionTap: () => AppRouter.route.pushNamed(
                        RoutePath.nearYouShopScreen,
                        extra: userRole),
                    actionColor: AppColors.secondary,
                  ),
                  SizedBox(height: 12.h),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(4, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: CommonShopCard(
                            imageUrl: AppConstants.shop,
                            title: "Barber Time ",
                            rating: "5.0 ★ (169)",
                            location: "Oldesloer Strasse 82",
                            discount: "15%",
                            onSaved: () => debugPrint("Saved Clicked!"),
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  /// 📢 Feed Section
                  CustomTitle(
                    title: "Feed",
                    actionText: AppStrings.seeAll,
                    onActionTap: () => AppRouter.route
                        .pushNamed(RoutePath.feedAll, extra: userRole),
                    actionColor: AppColors.secondary,
                  ),
                  SizedBox(height: 12.h),

                  /// 📝 List of Feeds
                  Column(
                    children: List.generate(4, (index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: CustomFeedCard(
                          userImageUrl: AppConstants.demoImage,
                          userName: "Roger Hunt",
                          userAddress:
                              "2972 Westheimer Rd. Santa Ana, Illinois 85486",
                          postImageUrl: AppConstants.demoImage,
                          postText:
                              "Fresh Cut, Fresh Start! 🔥💈 Kickstart your day with confidence! #BarberLife #StayFresh",
                          rating: "5.0 ★ (169)",
                          onFavoritePressed: () {},
                          onVisitShopPressed: () => AppRouter.route
                              .pushNamed(RoutePath.visitShop, extra: userRole),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to show the Tip dialog
  void _showTipDialog(BuildContext context) {
    final userRole = GoRouter.of(context).state.extra as UserRole?;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: AppColors.white,
          title: Column(
            children: [
              const Icon(
                Icons.attach_money,
                color: Colors.orange,
                size: 40,
              ),
              const Text(
                "Tip",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              CustomText(
                maxLines: 2,
                text: "Would you like to leave this or barber a tip?",
                fontWeight: FontWeight.w400,
                color: AppColors.black,
                fontSize: 15.sp,
              )
            ],
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Yes button
              _buildRadioButton("Yes", context, () {
                AppRouter.route
                    .pushNamed(RoutePath.tipsScreen, extra: userRole);
              }),
              const SizedBox(width: 20),
              // No button
              _buildRadioButton("No", context, () {}),
            ],
          ),
          actions: <Widget>[
            // Close button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Helper method to create radio-like buttons for Yes/No selection
  Widget _buildRadioButton(
      String label, BuildContext context, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orange, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.orange, fontSize: 16),
        ),
      ),
    );
  }
}
