import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_container_button/custom_container_button.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ChoseRoleScreen extends StatelessWidget {
  const ChoseRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Logo in the center
              Center(child: Assets.images.logo.image()),

              // Spacer for better alignment
              SizedBox(height: 40.h),
              //ToDo ==========✅✅ Customer ✅✅==========
              CustomContainerButton(
                isArrow: true,
                text: AppStrings.customer,
                icon: Assets.images.customer.image(),
                onTap: () {
                  AppRouter.route.pushNamed(RoutePath.choseAuthScreen);
                  // context.push(RoutePath.choseAuthScreen,extra: UserRole.user);
                },
              ),

              //ToDo ==========✅✅ barber ✅✅==========
              CustomContainerButton(
                isArrow: true,
                text: AppStrings.berber,
                icon: Assets.images.berber.image(),
                onTap: () {
                  context.push(RoutePath.choseAuthScreen,extra: UserRole.barber);
                },
              ),

              //ToDo ==========✅✅ Owner ✅✅==========
              CustomContainerButton(
                isArrow: true,
                text: AppStrings.owner,
                icon: Assets.images.owner.image(),
                onTap: () {
                  context.push(RoutePath.choseAuthScreen,extra: UserRole.owner);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
