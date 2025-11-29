import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/common_shop_card/common_shop_card.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/user_nav_bar/user_nav_bar.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/my_favorite/widgets/fav_card_widgets.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/my_favorite/widgets/favorite_shimmer_card.dart';
import 'package:barber_time/app/view/screens/user/home/controller/user_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class SavedScreen extends StatelessWidget {
  SavedScreen({super.key});

  final UserHomeController controller = Get.find<UserHomeController>();

  @override
  Widget build(BuildContext context) {
    controller.fetchAllFavourite();
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

    if (userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        bottomNavigationBar: CustomNavBar(currentIndex: 3, role: userRole),
        backgroundColor: AppColors.white50,
        appBar: const CustomAppBar(
          appBarContent: AppStrings.saved,
          appBarBgColor: AppColors.last,
        ),
        body: Column(
          children: [
            // ✅ Tab Bar
            Container(
              color: AppColors.last,
              child: const TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(text: 'Favorite Shop'),
                  Tab(text: 'Feed'),
                ],
              ),
            ),

            // ✅ TabBarView
            Expanded(
              child: TabBarView(
                children: [
                  /// 👉 Favorite Shop ListView
                  ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: GestureDetector(
                          onTap: () {
                            AppRouter.route.pushNamed(
                                RoutePath.shopProfileScreen,
                                extra: userRole);
                          },
                          child: CommonShopCard(
                            imageUrl: AppConstants.shop,
                            title: "Barber Time ",
                            rating: "5.0 ★ (169)",
                            location: "Oldesloer Strasse 82",
                            discount: "15%",
                            onSaved: () => debugPrint("Saved Clicked!"),
                          ),
                        ),
                      );
                    },
                  ),

                  /// 👉 Feed Column/
                  Obx(() {
                    if (controller.isLoading.value) {
                      return ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: const FavoriteShimmerCard(),
                        ),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 15),
                        itemCount: 3,
                      );
                    }

                    final display = controller.favoriteItems;

                    // Check if the list is empty
                    if (display.isEmpty) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          await controller.fetchAllFavourite();
                        },
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height - 200,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.favorite_border,
                                      size: 80,
                                      color: Colors.grey[400],
                                    ),
                                    SizedBox(height: 16.h),
                                    Text(
                                      'No Favorites Yet',
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.secondary,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      'Start adding your favorite posts\nto see them here',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.grey[600],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        await controller.fetchAllFavourite();
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children:
                                buildFeedCards(userRole, display, controller),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
