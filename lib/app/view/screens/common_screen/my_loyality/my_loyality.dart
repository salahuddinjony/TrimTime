import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class MyLoyality extends StatelessWidget {
  const MyLoyality({super.key});

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
      appBar: AppBar(
        title: const CustomText(
          text: "My Loyalty Rewards",
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        ),
        centerTitle: true,
        backgroundColor: AppColors.linearFirst,
      ),

      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.first, // start color
              AppColors.last, // end color
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              CustomText(
                text: "Track your visits and earn rewards!",
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.white50,
                bottom: 10.h,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10.r),
                color: AppColors.orange700,
                child: CustomText(
                  text: "Shop visit Tracking ",
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                  color: AppColors.white50,
                ),
              ),
              SizedBox(
                height: 12.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      AppRouter.route.pushNamed(RoutePath.myLoyalityRewards,
                          extra: userRole);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.r),
                      color: AppColors.orange500,
                      child: CustomText(
                        text: "Barber time \n 4 visit",
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        color: AppColors.white50,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.r),
                    color: AppColors.orange500,
                    child: CustomText(
                      text: "Hair Salon \n 3 visit",
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                      color: AppColors.white50,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.r),
                    color: AppColors.orange500,
                    child: CustomText(
                      text: "Skin Care \n 1 visit",
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                      color: AppColors.white50,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: EdgeInsets.all(10.r),
                    color: AppColors.orange500,
                    child: CustomText(
                      text: "Nail Salon \n 4 visit",
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                      color: AppColors.white50,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.r),
                    color: AppColors.orange500,
                    child: CustomText(
                      text: "For Female \n 3 visit",
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                      color: AppColors.white50,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12.h,
              ),
              Container(
                padding: EdgeInsets.all(10.r),
                color: AppColors.visit,
                child: CustomText(
                  text: "Barber time \n 4 visit",
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                  color: AppColors.black,
                ),
              ),
              SizedBox(
                height: 12.h,
              ),
              CustomText(
                text: "Barber Time gives you a 10% discount \n to enjoy!",
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.white50,
                bottom: 10.h,
              ),
              CustomText(
                text: "Stay tuned for the next Hair Salon discount!",
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
                bottom: 10.h,
              ),
              Container(
                padding: EdgeInsets.all(10.r),
                color: AppColors.white50,
                child: CustomText(
                  text: "Loyalty points 1240 YOU EARING",
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
