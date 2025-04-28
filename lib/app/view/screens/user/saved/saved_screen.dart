import 'package:barber_time/app/core/bottom_navbar.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/common_shop_card/common_shop_card.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
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
      bottomNavigationBar: BottomNavbar(currentIndex: 3, role: userRole),
      backgroundColor: AppColors.white50,
      appBar: const CustomAppBar(
        appBarContent: AppStrings.saved,
        appBarBgColor: AppColors.linearFirst,
      ),
      body: ListView.builder(itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
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
    );
  }
}
