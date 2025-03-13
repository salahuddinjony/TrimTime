import 'package:barber_time/app/core/bottom_navbar.dart';
import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_border_card/custom_border_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BarberHistoryScreen extends StatelessWidget {
  const BarberHistoryScreen({super.key});

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
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(
          appBarBgColor: AppColors.linearFirst,
          appBarContent: AppStrings.history,
          iconData: Icons.arrow_back,
        ),
        bottomNavigationBar: BottomNavbar(
          currentIndex: 3,
          role: userRole,
        ),
        body:

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child:
          CustomBorderCard(
            title: 'Barber Shop',
            time: '10:00am-10:00pm',
            price: '£20.00/Per hr',
            date: '02/10/23',
            buttonText: 'Completed',
            isButton: false,
            onButtonTap: () {
              // Handle button tap logic
            },
            logoImage: Assets.images.logo.image(height: 50),
          ),

        ));
  }
}
