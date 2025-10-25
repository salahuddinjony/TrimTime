import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/common_shop_card/common_shop_card.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/user_nav_bar/user_nav_bar.dart';
import 'package:barber_time/app/view/common_widgets/custom_feed_card/custom_feed_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
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
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.white,
              tabs: const [
                Tab(text: 'Favorite Shop'),
                Tab(text: 'Feed'),
              ],
            ),
          ),

          // ✅ TabBarView
          Expanded(
            child: TabBarView(
              controller: _tabController,
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
                          AppRouter.route.pushNamed(RoutePath.shopProfileScreen,
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
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: List.generate(4, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: CustomFeedCard(
                          userImageUrl: AppConstants.demoImage,
                          userName: "Roger Hunt",
                          userAddress:
                              "2972 Westheimer Rd. Santa Ana, Illinois 85486",
                          postImageUrl: AppConstants.demoImage,
                          postText:
                              "Fresh Cut, Fresh Start! 🔥💈 Kickstart your day with confidence! #BarberLife #StayFresh",
                          rating: "5.0 ★ (169)",
                          onFavoritePressed: (isFavorite) {
                            // Handle favorite button press
                          },
                          onVisitShopPressed: () => AppRouter.route
                              .pushNamed(RoutePath.shopProfileScreen, extra: userRole),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
