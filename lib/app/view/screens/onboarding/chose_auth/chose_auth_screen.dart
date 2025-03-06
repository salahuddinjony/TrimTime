import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';

import 'package:barber_time/app/view/common_widgets/custom_container_button/custom_container_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ChoseAuthScreen extends StatelessWidget {
  const ChoseAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userRole = GoRouterState.of(context).extra as UserRole?;
    debugPrint("Selected Role============================${userRole?.name}");
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Adding some vertical space for better layout
              SizedBox(height: 50.h),

              // Logo in the center
              Center(child: Assets.images.logo.image()),

              const CustomText(
                text: AppStrings.barbersTime,
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: AppColors.normalHover,
              ),

              const CustomText(
                textAlign: TextAlign.center,
                maxLines: 5,
                text: AppStrings.inAWorldFullOFTrends,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.gray800,
              ),

              // Spacer for better alignment
              SizedBox(height: 40.h),
              //ToDo ==========✅✅ Email ✅✅==========
              CustomContainerButton(
                isArrow: false,
                text: AppStrings.signInWithEmail,
                icon: Assets.images.email.image(),
                onTap: () {
                  AppRouter.route.pushNamed(RoutePath.getStartedScreen,
                      extra: userRole);                },
              ),
              //ToDo ==========✅✅ Apple ✅✅==========
              CustomContainerButton(
                isArrow: false,
                text: AppStrings.signInWithApple,
                icon: Assets.images.apple.image(),
                onTap: () {},
              ), //ToDo ==========✅✅ Facebook ✅✅==========
              CustomContainerButton(
                isArrow: false,
                text: AppStrings.signInWithFacebook,
                icon: Assets.images.facebook.image(),
                onTap: () {},
              ), //ToDo ==========✅✅ Google ✅✅==========
              CustomContainerButton(
                isArrow: false,
                text: AppStrings.signInWithGoogle,
                icon: Assets.images.google.image(),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
