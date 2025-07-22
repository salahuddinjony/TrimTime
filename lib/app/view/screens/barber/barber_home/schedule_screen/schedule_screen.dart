import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/schedule_card/schedule_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../common_widgets/curved_short_clipper/curved_short_clipper.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

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
    return  Scaffold(
      //==================✅✅Header✅✅===================
      appBar: CustomAppBar(
        appBarBgColor: AppColors.linearFirst,
        appBarContent: "Schedule",
        iconData: Icons.arrow_back,
      ),
      backgroundColor: AppColors.white,
      body:
      ClipPath(
        clipper: CurvedShortClipper(),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 1.8,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xCCEDBFA5), // First color (with opacity)
                Color(0xFFE9854C),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child:
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                ScheduleCard(
                  timeTitle: "Time",
                  shopTitle: "Shop Name",
                  timeValue: "7:00AM-8:00PM",
                  shopName: "Barber Time",
                )

              ],
            ),
          ),

        ),
      ),

    );
  }
}
