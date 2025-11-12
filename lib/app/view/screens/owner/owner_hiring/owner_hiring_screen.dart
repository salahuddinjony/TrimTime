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

    if (userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }

    return Scaffold(
      bottomNavigationBar: BottomNavbar(currentIndex: 3, role: userRole),
      appBar: const CustomAppBar(
        appBarBgColor: AppColors.normalHover,
        appBarContent: AppStrings.hiring,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: SingleChildScrollView(
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
                var filteredJobs = controller.jobHistoryAllList;
                if (controller.isJobHistoryLoading.value) {
                  return SizedBox(
                    height: 300.h,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.orange700,
                      ),
                    ),
                  );
                }
                return filteredJobs.isEmpty
                    ? Padding(
                        padding: EdgeInsets.only(top: 100.h),
                        child: Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              children: [
                                const TextSpan(text: "No jobs found on "),
                                TextSpan(
                                  text: controller.selectedFilter.value,
                                  style: const TextStyle(
                                    color: AppColors.orange700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const TextSpan(text: "status"),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Column(
                        children: filteredJobs.map<Widget>((job) {
                          return GestureDetector(
                            onTap: () {
                              final barber = job.barber;
                              if (barber != null) {
                                // Use userId if available, otherwise use id
                                final barberId = barber.id;
                                debugPrint("Barber ${barber.fullName} clicked");
                                debugPrint("Barber ID: $barberId");

                                // Navigate to professional profile with barber ID
                                AppRouter.route.pushNamed(
                                  RoutePath.professionalProfile,
                                  extra: {
                                    'userRole': userRole,
                                    'barberId': barberId,
                                    'isForActionButton': true,
                                    if (job.status == 'PENDING')
                                      ...{
                                        'onActionApprove': () {
                                          controller.updateJobStatus(applicationId: job.id!, status: 'COMPLETED');
                                        },
                                        'onActionReject': () {
                                          controller.updateJobStatus(applicationId: job.id!, status: 'REJECTED');
                                        },
                                      },
                                  },
                                );
                              }
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: CustomHiringCard(
                                isCalling: true,
                                imageUrl: AppConstants.demoImage,
                                name: job.barber.fullName ?? "N/A",
                                role: job.barber.email ?? "",
                                rating: job.jobPost.saloonOwnerAvgRating ?? 0.0,
                                location: job.jobPost.shopAddress ?? "N/A",
                                onHireTap: () {
                                  AppRouter.route.pushNamed(
                                      RoutePath.chatScreen,
                                      extra: userRole);
                                },
                              ),
                            ),
                          );
                        }).toList(),
                      );
              }),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable Filter Button
  Widget _buildFilterButton(String filterText) {
    return GestureDetector(
      onTap: () {
        controller.filterJobs(filterText);
      },
      child: Obx(() => Container(
            padding: const EdgeInsets.all(12),
            margin: EdgeInsets.only(right: 8.w),
            decoration: BoxDecoration(
              color: controller.selectedFilter.value == filterText
                  ? AppColors.orange700
                  : AppColors.container,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: CustomText(
              text: filterText,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: controller.selectedFilter.value == filterText
                  ? AppColors.white
                  : AppColors.black,
            ),
          )),
    );
  }
}
