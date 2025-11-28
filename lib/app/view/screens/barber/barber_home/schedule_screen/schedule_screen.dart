import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/schedule_card/schedule_card.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/controller/barber_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../common_widgets/curved_short_clipper/curved_short_clipper.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userRole = GoRouter.of(context).state.extra as UserRole?;
    final BarberHomeController controller = Get.find<BarberHomeController>();

    debugPrint("===================${userRole?.name}");
    if (userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }
    return Scaffold(
      //==================✅✅Header✅✅===================
      appBar: CustomAppBar(
        appBarBgColor: AppColors.linearFirst,
        appBarContent: "Schedule",
        iconData: Icons.arrow_back,
      ),
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // Background ClipPath - positioned at the top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: ClipPath(
                clipper: CurvedShortClipper(),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 1.3,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xCCEDBEA3),
                        Color(0xFFE98F5A),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Data on top of the background
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Obx(() {
              // Show loading indicator
              if (controller.fetchScheduleStatus.value.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.white,
                  ),
                );
              }

              // Show error message
              if (controller.fetchScheduleStatus.value.isError) {
                return RefreshIndicator(
                  onRefresh: () async {
                    await controller.fetchScheduleData(useDay: false);
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height - 200,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: AppColors.white,
                              size: 48,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'Failed to load schedule',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 16.sp,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            ElevatedButton(
                              onPressed: () {
                                controller.fetchScheduleData(useDay: false);
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }

              // Show empty state
              if (controller.scheduleList.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () async {
                    await controller.fetchScheduleData(useDay: false);
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height - 200,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              color: AppColors.white,
                              size: 48,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'No schedules available',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }

              // Show schedule list with refresh indicator
              return RefreshIndicator(
                onRefresh: () async {
                  await controller.fetchScheduleData(useDay: false);
                },
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: controller.scheduleList.length,
                  itemBuilder: (context, index) {
                    final schedule = controller.scheduleList[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: ScheduleCard(
                        timeTitle: "Day & Time",
                        shopTitle: "Weekend",
                        timeValue: "${schedule.dayName} | ${schedule.time}",
                        shopName: schedule.isActive ? "No" : "Yes",
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
