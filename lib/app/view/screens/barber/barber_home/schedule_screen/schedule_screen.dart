import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/common_home_app_bar/common_home_app_bar.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/common_widgets/schedule_card/schedule_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

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
    return const Scaffold(
      //==================✅✅Header✅✅===================
      appBar: CustomAppBar(
        appBarBgColor: AppColors.linearFirst,
        appBarContent: "Schedule",
        iconData: Icons.arrow_back,
      ),
      backgroundColor: AppColors.linearFirst,
      body: Padding(
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
    );
  }
}
