import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_from_card/custom_from_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

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
      backgroundColor: AppColors.linearFirst,

      ///============================ Header ===============================
      appBar: const CustomAppBar(
        appBarBgColor: AppColors.linearFirst,
        appBarContent: AppStrings.changePassword,
        iconData: Icons.arrow_back,
      ),
      body: ClipPath(
        clipper: CurvedBannerClipper(),
        child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xCCEDC4AC), // First color (with opacity)
                  Color(0xFFE9874E),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  //current password
                  CustomFromCard(
                      isBorderColor: true,
                      isPassword: true,
                      title: AppStrings.currentPassword,
                      hinText: AppStrings.enterCurrentPassword,
                      controller: TextEditingController(),
                      validator: (v) {
                        return null;
                      }),
                  //New Password
                  CustomFromCard(
                      isBorderColor: true,
                      isPassword: true,
                      title: AppStrings.newPassword,
                      hinText: AppStrings.enterNewPassword,
                      controller: TextEditingController(),
                      validator: (v) {
                        return null;
                      }),

                  //retype password
                  CustomFromCard(
                      isBorderColor: true,
                      isPassword: true,
                      title: AppStrings.retypePassword,
                      hinText: AppStrings.retypeNewPassword,
                      controller: TextEditingController(),
                      validator: (v) {
                        return null;
                      }),
                  SizedBox(
                    height: 50.h,
                  ),
                  //=====================Change password Button===============
                  CustomButton(
                    onTap: () {
                      context.pop();
                    },
                    fillColor: AppColors.white50,
                    title: AppStrings.changePassword,
                  )
                ],
              ),
            )),
      ),
    );
  }
}
