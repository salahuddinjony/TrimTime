import 'package:barber_time/app/core/bottom_navbar.dart';
import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/common_home_app_bar/common_home_app_bar.dart';
import 'package:barber_time/app/view/common_widgets/custom_border_card/custom_border_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BarberHomeScreen extends StatelessWidget {
  BarberHomeScreen({super.key});

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
          CommonHomeAppBar(
            scaffoldKey: scaffoldKey,
            name: "Masum",
            image: AppConstants.demoImage,
            onTap: () {
              AppRouter.route
                  .pushNamed(RoutePath.notificationScreen, extra: userRole);
            },
          ),
          Expanded(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(2, (index) {
                      return CustomBorderCard(
                        title: 'Barber Shop',
                        time: '10:00am-10:00pm',
                        price: '£20.00/Per hr',
                        date: '02/10/23',
                        buttonText: 'Completed',
                        isButton: true,
                        onButtonTap: () {
                          // Handle button tap logic
                        },
                        logoImage: Assets.images.logo.image(height: 50),
                      );
                    }),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
