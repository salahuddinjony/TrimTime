import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_border_card/custom_border_card.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/controller/barber_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class JobPostAll extends StatelessWidget {
  JobPostAll({super.key});

  final BarberHomeController controller = Get.find<BarberHomeController>();

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
      appBar: const CustomAppBar(
        appBarBgColor: AppColors.linearFirst,
        appBarContent: AppStrings.jobPost,
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          children: [
            // Filter Buttons Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterButton("Nearby job"),
                  _buildFilterButton(AppStrings.pending),
                  _buildFilterButton(AppStrings.approve),
                  _buildFilterButton(AppStrings.rejected),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // Jobs List
            Obx(() {
              var filteredJobs = controller.allJobs
                  .where((job) => job['status'] == controller.selectedFilter.value)
                  .toList();

              return filteredJobs.isEmpty
                  ? const Center(child: CustomText(text: "No jobs found"))
                  : Column(
                children: filteredJobs.map((job) {
                  return CustomBorderCard(
                    title: job['title']!,
                    time: job['time']!,
                    price: job['price']!,
                    date: job['date']!,
                    buttonText: 'Apply',
                    isButton: true,
                    isSeeDescription: true,
                    onButtonTap: () {
                      // Handle apply logic
                    },
                    logoImage: Assets.images.logo.image(height: 50),
                    seeDescriptionTap: () {},
                  );
                }).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String filterText) {
    return GestureDetector(
      onTap: () {
        controller.selectedFilter.value = filterText;
      },
      child: Obx(() => Container(
        padding: const EdgeInsets.all(12),
        margin: EdgeInsets.only(right: 8.w),
        decoration: BoxDecoration(
          color: controller.selectedFilter.value == filterText
              ? AppColors.secondary
              : AppColors.innerText,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: CustomText(
          text: filterText,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      )),
    );
  }
}
