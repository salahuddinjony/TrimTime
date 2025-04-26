import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

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
      backgroundColor: AppColors.white50,
      appBar: const CustomAppBar(
        appBarContent: "Tip",
        appBarBgColor: AppColors.linearFirst,
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding:
        EdgeInsets.symmetric(horizontal: 20.w,vertical: 20.h),
        child: Column(
          children: [
            CustomButton(
              onTap: () {
                AppRouter.route.pushNamed(
                    RoutePath.paymentOption,
                    extra: userRole);
              },
              title: AppStrings.submit,
              fillColor: Colors.black,
              textColor: AppColors.whiteColor,
            )
          ],
        ),
      ),
    );
  }
}
