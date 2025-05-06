import 'package:barber_time/app/core/bottom_navbar.dart';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_hiring_pending_card/custom_hiring_pending_card.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/screens/owner/owner_hiring/controller/owner_hiring_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class OwnerHiringScreen extends StatelessWidget {
  OwnerHiringScreen({super.key});

  final OwnerHiringController controller = Get.find<OwnerHiringController>();

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
      bottomNavigationBar: BottomNavbar(currentIndex: 3, role: userRole),
      appBar: const CustomAppBar(
        appBarBgColor: AppColors.linearFirst,
        appBarContent: AppStrings.hiring,
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
                  _buildFilterButton("Pending"),
                  _buildFilterButton(AppStrings.ongoing),
                  _buildFilterButton(AppStrings.completed),
                  _buildFilterButton(AppStrings.rejected),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            // Filtered Job Listings
            Obx(() {
              var filteredJobs = controller.allJobs
                  .where(
                      (job) => job['status'] == controller.selectedFilter.value)
                  .toList();

              return filteredJobs.isEmpty
                  ? const Center(child: CustomText(text: "No jobs found"))
                  : Column(
                children: filteredJobs.map((job) {
                  return CustomHiringCard(
                    imageUrl: AppConstants.demoImage, // Image URL (dynamic)
                    name: job['title'] ?? "Unknown",  // Dynamic title (Job name)
                    role: "Barber",                    // Hardcoded or dynamic role
                    rating: 4.5,                       // Hardcoded or dynamic rating
                    location: "New York, USA",         // Dynamic location or hardcoded
                    onHireTap: () {
                      AppRouter.route
                          .pushNamed(RoutePath.chatScreen, extra: userRole);
                    },                  // Hire button action
                  );
                }).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }

  // Reusable Filter Button
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
