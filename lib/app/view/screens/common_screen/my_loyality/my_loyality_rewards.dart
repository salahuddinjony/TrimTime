import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/common_text_row/common_text_row.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/common_widgets/visit_tracer_card/visit_tracer_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class MyLoyalityRewards extends StatelessWidget {
  const MyLoyalityRewards({super.key});

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
                text: "Track your visits Last 30 Days!",
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.whiteDarker,
                bottom: 10.h,
              ),
              const CommonTextRow(
                keyText: 'Shop Name:',
                valueText: 'Barber time',
              ),
              const CommonTextRow(
                keyText: 'Name:',
                valueText: 'Jenny tom',
              ),
              const CommonTextRow(
                keyText: 'Id No:',
                valueText: '122455334',
              ),
              const CommonTextRow(
                keyText: 'Range:',
                valueText: '122455334',
              ),
              SizedBox(
                height: 12.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: EdgeInsets.all(10.r),
                    color: AppColors.visit,
                    child: CustomText(
                      text: "Total Visits \n 4 ",
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                      color: AppColors.black,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.r),
                    color: AppColors.visit,
                    child: CustomText(
                      text: "Total Visits Points \n 4",
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                      color: AppColors.black,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.r),
                    color: AppColors.visit,
                    child: CustomText(
                      text: "Last Visit \n 21/03/25",
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12.h,
              ),

              VisitTracerCard(
                currentStatus: 1,
                totalStatus: 4,
                title: 'Visit Tracer',
                description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
