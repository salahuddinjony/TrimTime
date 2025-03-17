import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_feed_card/custom_feed_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyFavoriteScreen extends StatelessWidget {
  const MyFavoriteScreen({
    super.key,
  });

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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.linearFirst,
        title: const Text(AppStrings.myFavorite),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(4, (index) {
              return CustomFeedCard(
                userImageUrl: AppConstants.demoImage,
                userName: "Roger Hunt",
                userAddress: "2972 Westheimer Rd. Santa Ana, Illinois 85486",
                postImageUrl: AppConstants.demoImage,
                postText:
                "Fresh Cut, Fresh Start! 🔥💈 Kickstart your day with confidence!#BarberLife #StayFresh",
                rating: "5.0 * (169)",
                onFavoritePressed: () {
                  // Handle favorite button press
                },
                onVisitShopPressed: () {
                  AppRouter.route.pushNamed(
                      RoutePath.visitShop,
                      extra: userRole);
                  // Handle visit shop button press
                },
              );
            }),
          ),
        ),
      ),

    );
  }
}
