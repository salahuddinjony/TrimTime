import 'package:barber_time/app/core/bottom_navbar.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OwnerMessagingScreen extends StatelessWidget {
  const OwnerMessagingScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String roleFromDatabase = "owner";
    UserRole userRole = getRoleFromString(roleFromDatabase);
    return Scaffold(
        bottomNavigationBar: BottomNavbar(
          currentIndex: 1,
          role: getRoleFromString(userRole.name),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: const Text(AppStrings.messaging),
        ),

      body: ClipPath(
        clipper: CurvedBannerClipper(),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 1.5,
          // Adjust height according to your design
          color: AppColors.orange700,
          // Brown color similar to your design
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 120.h,
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
