import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_border_card/custom_border_card.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/controller/barber_home_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        appBarBgColor: AppColors.app,
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

            // Barber shop cards
            Expanded(
              child: Obx(() {
                if (controller.isJobHistoryLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final selected = controller.selectedFilter.value;
                final isNearbyJob = selected == "Nearby job";
                final jobs = isNearbyJob
                    ? controller.jobPostList
                    : controller.jobHistoryList;

                if (jobs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Assets.images.logo.image(height: 60),
                        SizedBox(height: 16.h),
                        Text(
                          "No Job Post",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          "Currently, there are no job posts available.\nPlease check back later.",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    if (!isNearbyJob) {
                      final jobApp = controller.jobHistoryList[index];
                      final job = jobApp.jobPost;
                      final salary = job.hourlyRate != null
                          ? '£${job.hourlyRate}'
                          : '£20.00/Per hr';
                      String dateText = '';
                      if (job.startDate != null && job.endDate != null) {
                        final start = job.startDate;
                        final end = job.endDate;
                        dateText =
                            '${start!.day.toString().padLeft(2, '0')}/${start.month.toString().padLeft(2, '0')}/${start.year} - '
                            '${end!.day.toString().padLeft(2, '0')}/${end.month.toString().padLeft(2, '0')}/${end.year}';
                      } else if (job.datePosted != null) {
                        final posted = job.datePosted;
                        dateText =
                            '${posted!.day.toString().padLeft(2, '0')}/${posted.month.toString().padLeft(2, '0')}/${posted.year}';
                      } else {
                        dateText = '—';
                      }
                      final logoWidget = Assets.images.logo.image(height: 50);

                      return CustomBorderCard(
                        title: job.shopName,
                        time: '10:00am-10:00pm',
                        price: salary,
                        date: dateText,
                        buttonText: jobApp.status,
                        isButton: false,
                        isSeeDescription: true,
                        logoImage: logoWidget,
                        seeDescriptionTap: () {
                          final desc = job.description; // if non-nullable
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text(job.shopName),
                              content: SingleChildScrollView(child: Text(desc)),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                          );
                        },
                        onButtonTap: () {},
                      );
                    } else {
                      final job = controller.jobPostList[index];
                      final salary = job.salary != null
                          ? '£${job.salary.toString()}'
                          : '£20.00/Per hr';
                      String dateText = '';
                      if (job.startDate != null && job.endDate != null) {
                        final start = job.startDate;
                        final end = job.endDate;
                        dateText =
                            '${start!.day.toString().padLeft(2, '0')}/${start.month.toString().padLeft(2, '0')}/${start.year} - '
                            '${end!.day.toString().padLeft(2, '0')}/${end.month.toString().padLeft(2, '0')}/${end.year}';
                      } else if (job.datePosted != null) {
                        final posted = job.datePosted;
                        dateText =
                            '${posted!.day.toString().padLeft(2, '0')}/${posted.month.toString().padLeft(2, '0')}/${posted.year}';
                      } else {
                        dateText = '—';
                      }
                      final logoWidget = (job.shopLogo?.isNotEmpty == true)
                          ? CachedNetworkImage(
                              imageUrl: job.shopLogo!,
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) =>
                                  Assets.images.logo.image(height: 50),
                            )
                          : Assets.images.logo.image(height: 50);

                      return CustomBorderCard(
                        title: job.shopName ?? 'Barber Shop',
                        time: '10:00am-10:00pm',
                        price: salary,
                        date: dateText,
                        buttonText: 'Apply',
                        isButton: true,
                        isSeeDescription: true,
                        onButtonTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Apply for Job'),
                              content: Text(
                                  'Apply to ${job.shopName ?? 'this shop'}?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    controller.applyJob(jobId: job.id ?? '');
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Application sent to ${job.shopName ?? 'shop'}')),
                                    );
                                  },
                                  child: const Text('Apply'),
                                ),
                              ],
                            ),
                          );
                        },
                        logoImage: logoWidget,
                        seeDescriptionTap: () {
                          final desc =
                              job.description ?? 'No description available';
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text(job.shopName ?? 'Job Description'),
                              content: SingleChildScrollView(child: Text(desc)),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String filterText) {
    return GestureDetector(
      onTap: () {
        controller.selectedFilter.value = filterText;
        // Call getAllJobHistory with status for filters
        if (filterText == AppStrings.pending) {
          controller.getAllJobHistory(status: 'PENDING');
        } else if (filterText == AppStrings.approve) {
          controller.getAllJobHistory(status: 'COMPLETED');
        } else if (filterText == AppStrings.rejected) {
          controller.getAllJobHistory(status: 'REJECTED');
        }
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
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: controller.selectedFilter.value == filterText
                  ? AppColors.white
                  : AppColors.black,
            ),
          )),
    );
  }
}
