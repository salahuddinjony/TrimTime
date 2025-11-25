import 'package:barber_time/app/global/controller/auth_controller/auth_controller.dart';
import 'package:barber_time/app/global/helper/validators/validators.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_from_card/custom_from_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});
  final AuthController authController = Get.find<AuthController>();

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
    debugPrint("===================${userRole?.name}");
    if (userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }
    return Scaffold(
      backgroundColor: AppColors.linearFirst,
      appBar: const CustomAppBar(
        appBarBgColor: AppColors.linearFirst,
        appBarContent: AppStrings.changePassword,
        iconData: Icons.arrow_back,
      ),
      body: Stack(
        children: [
          // Curved background at the back
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: CurvedBannerClipper(),
              child: Container(
                width: double.infinity,
                height: 380.h,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xCCEDC4AC),
                      Color(0xFFE9874E),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          // Foreground content
          SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  SizedBox(height: 40.h),
                  //current password
                  CustomFromCard(
                      isBorderColor: true,
                      isPassword: true,
                      title: AppStrings.currentPassword,
                      hinText: AppStrings.enterCurrentPassword,
                      controller: authController.passwordController,
                      validator: (v) {
                        return null;
                      }),
                  //New Password
                  CustomFromCard(
                      isBorderColor: true,
                      isPassword: true,
                      title: AppStrings.newPassword,
                      hinText: AppStrings.enterNewPassword,
                      controller: authController.newPasswordController,
                      validator: (v) {
                        return Validators.passwordValidator(v);
                      }),
                  //retype password
                  CustomFromCard(
                      isBorderColor: true,
                      isPassword: true,
                      title: AppStrings.retypePassword,
                      hinText: AppStrings.retypeNewPassword,
                      controller: authController.confirmPasswordController,
                      validator: (v) {
                        return Validators.confirmPasswordValidator(
                            v, authController.newPasswordController.text);
                      }),
                  SizedBox(
                    height: 50.h,
                  ),
                  //=====================Change password Button===============
                  Card(
                    elevation: 4,
                    child: CustomButton(
                      onTap: () async {
                        authController.changePassword();
                        // context.pop();
                      },
                      fillColor: AppColors.last,
                      title: AppStrings.changePassword,
                      textColor: AppColors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
