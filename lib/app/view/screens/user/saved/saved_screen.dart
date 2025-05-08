import 'package:barber_time/app/core/bottom_navbar.dart';
import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/common_shop_card/common_shop_card.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

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
      floatingActionButton: userRole == UserRole.user
          ? IconButton(
        onPressed: () {
          AppRouter.route.pushNamed(RoutePath.scannerScreen, extra: userRole);
        },
        icon: Container(
          height: 85,
          width: 85,
          padding: EdgeInsets.all(12.r),  // You can adjust the padding as needed
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.navColor,  // Custom color for the button
          ),
          child: Assets.images.bxScan.image(color: AppColors.black),  // Scanner icon
        ),
      )
          : null, // Return null if the role is not 'user'
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomNavbar(currentIndex: 3, role: userRole),
      backgroundColor: AppColors.white50,
      appBar: const CustomAppBar(
        appBarContent: AppStrings.saved,
        appBarBgColor: AppColors.linearFirst,
      ),
      body: ListView.builder(itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: GestureDetector(
            onTap: (){
              AppRouter.route
                  .pushNamed(RoutePath.shopProfileScreen, extra: userRole);
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
      }),
    );
  }
}
