import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/curved_short_clipper/curved_short_clipper.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userRole = GoRouterState.of(context).extra as UserRole?;
    debugPrint("Selected Role============================${userRole?.name}");
    return Scaffold(
      body: Column(
        children: [
          ClipPath(
            clipper: CurvedShortClipper(),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 2,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xCCEDC4AC), // First color (with opacity)
                    Color(0xFFE9864E),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 120.h,
                    ),
                    const CustomText(
                      text: AppStrings.getStarted,
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: AppColors.white50,
                    ),
                    const CustomText(
                      text: AppStrings.startWithSign,
                      fontWeight: FontWeight.w300,
                      fontSize: 20,
                      color: AppColors.white50,
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: Column(
              children: [
                //ToDo ==========✅✅ Sing In Button ✅✅==========
                CustomButton(
                  fillColor: AppColors.black,
                  textColor: AppColors.white50,
                  onTap: () {
                    AppRouter.route
                        .pushNamed(RoutePath.signInScreen, extra: userRole);
                  },
                  title: AppStrings.signIn,
                ),

                //ToDo ==========✅✅ Sing Up Button ✅✅==========
                SizedBox(
                  height: 20.h,
                ),

                CustomButton(
                  fillColor: AppColors.black,
                  textColor: AppColors.white50,
                  onTap: () {
                    if (userRole == UserRole.user) {
                      AppRouter.route
                          .pushNamed(RoutePath.signUpScreen, extra: userRole);
                    } else if (userRole == UserRole.barber) {
                      AppRouter.route
                          .pushNamed(RoutePath.signUpScreen, extra: userRole);
                    } else if (userRole == UserRole.owner) {
                      AppRouter.route
                          .pushNamed(RoutePath.ownerSignUp, extra: userRole);
                    } else {
                      debugPrint('Unknown user role: ');
                    }
                  },
                  title: AppStrings.signUp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
