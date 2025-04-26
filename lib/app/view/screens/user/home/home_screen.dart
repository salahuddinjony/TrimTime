import 'package:barber_time/app/core/bottom_navbar.dart';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/common_home_app_bar/common_home_app_bar.dart';
import 'package:barber_time/app/view/common_widgets/common_shop_card/common_shop_card.dart';
import 'package:barber_time/app/view/common_widgets/custom_feed_card/custom_feed_card.dart';
import 'package:barber_time/app/view/common_widgets/custom_title/custom_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final scaffoldKey = GlobalKey<ScaffoldState>();

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
      bottomNavigationBar: BottomNavbar(currentIndex: 0, role: userRole),
      body: Column(
        children: [
          /// 🏡 Common Home AppBar
          CommonHomeAppBar(
            isSearch: true,
            onSearch: () => AppRouter.route
                .pushNamed(RoutePath.searchSaloon, extra: userRole),
            scaffoldKey: scaffoldKey,
            name: "Masum",
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
}
