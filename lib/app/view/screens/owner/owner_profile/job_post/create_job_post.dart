import 'package:barber_time/app/global/helper/extension/extension.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_from_card/custom_from_card.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/job_post/controller/barber_owner_job_post_controller.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/job_post/model/barber_owner_job_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

enum DateFor { datePosted, startDate, endDate }

class CreateJobPost extends StatelessWidget {
  const CreateJobPost({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BarberOwnerJobPostController>();

    final extra = GoRouter.of(context).state.extra;
    UserRole? userRole;
    JobPostData? jobPost;
    bool isEditMode = false;

    if (extra is UserRole) {
      userRole = extra;
    } else if (extra is Map) {
      try {
        userRole = extra['userRole'] as UserRole?;
        jobPost = extra['jobPost'] as JobPostData?;
        isEditMode = extra['isEditMode'] as bool? ?? false;
      } catch (_) {
        userRole = null;
      }
    }

    // Initialize form data only once based on mode
    if (isEditMode && jobPost != null) {
      controller.loadJobPostForEdit(jobPost);
    } else {
      controller.initializeFormForCreate();
    }

    Future<void> selectDate({required DateFor forDate}) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2030),
      );

      if (picked != null && forDate == DateFor.datePosted) {
        controller.dateController.text = picked.formatDateApi();
      }
      if (picked != null && forDate == DateFor.startDate) {
        controller.startDateController.text = picked.formatDateApi();
      }
      if (picked != null && forDate == DateFor.endDate) {
        controller.endDateController.text = picked.formatDateApi();
      }
    }

    // Future<void> selectStartTime() async {
    //   final TimeOfDay? picked = await showTimePicker(
    //     context: context,
    //     initialTime: TimeOfDay.now(),
    //   );

    //   if (picked != null) {
    //     controller.startTimeController.text = picked.format(context);
    //   }
    // }

    // Future<void> selectEndTime() async {
    //   final TimeOfDay? picked = await showTimePicker(
    //     context: context,
    //     initialTime: TimeOfDay.now(),
    //   );

    //   if (picked != null) {
    //     controller.endTimeController.text = picked.format(context);
    //   }
    // }

    // Future<void> pickShopLogo() async {
    //   await controller.pickImage();
    //   if (controller.imagePath.value.isNotEmpty) {
    //     controller.shopLogoController.text = 'Logo uploaded';
    //   }
    // }

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
      appBar: const CustomAppBar(
        appBarContent: AppStrings.jobPost,
        iconData: Icons.arrow_back,
        appBarBgColor: AppColors.linearFirst,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomFromCard(
                hinText: "Select date",
                suffixIcon: const Icon(Icons.calendar_month),
                title: 'Date',
                controller: controller.dateController,
                isRead: true,
                isBgColor: true,
                isBorderColor: true,
                validator: (v) {
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        selectDate(forDate: DateFor.startDate);
                      },
                      child: AbsorbPointer(
                        child: CustomFromCard(
                            hinText: "Select start date",
                            suffixIcon: const Icon(Icons.calendar_today),
                            title: 'Start date',
                            controller: controller.startDateController,
                            validator: (v) {
                              return null;
                            }),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        selectDate(forDate: DateFor.endDate);
                      },
                      child: AbsorbPointer(
                        child: CustomFromCard(
                            hinText: "Select end date",
                            suffixIcon: const Icon(Icons.event),
                            title: 'End date',
                            controller: controller.endDateController,
                            validator: (v) {
                              return null;
                            }),
                      ),
                    ),
                  ),
                ],
              ),
              CustomFromCard(
                  title: 'Rate(hourly)',
                  hinText: "Enter rate in USD",
                  controller: controller.rateController,
                  validator: (v) {
                   if(v == null || v.isEmpty) {
                      return 'Please enter hourly rate';
                    }
                    final rate = double.tryParse(v);
                    if (rate == null || rate <= 0) {
                      return 'Please enter a valid hourly rate greater than 0';
                    }
                    return null;
                  }),

              // CustomFromCard(
              //     title: AppStrings.shopName,
              //     hinText: AppStrings.name,
              //     controller: controller.shopNameController,
              //     validator: (v) {
              //       return null;
              //     }),

              // GestureDetector(
              //   onTap: pickShopLogo,
              //   child: AbsorbPointer(
              //     child: CustomFromCard(
              //         suffixIcon: const Icon(Icons.camera),
              //         title: "Add shop logo",
              //         hinText: "Upload your logo",
              //         controller: controller.shopLogoController,
              //         validator: (v) {
              //           return null;
              //         }),
              //   ),
              // ),

              // Image Preview and Clear
              // Obx(() {
              //   if (controller.imagePath.value.isEmpty) {
              //     return const SizedBox.shrink();
              //   }

              //   return Container(
              //     margin: const EdgeInsets.only(top: 10, bottom: 10),
              //     padding: const EdgeInsets.all(10),
              //     decoration: BoxDecoration(
              //       border: Border.all(color: AppColors.black.withOpacity(0.2)),
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text(
              //               'Shop Logo Preview',
              //               style: TextStyle(
              //                 fontSize: 14.sp,
              //                 fontWeight: FontWeight.w600,
              //               ),
              //             ),
              //             IconButton(
              //               onPressed: () {
              //                 controller.clearImage();
              //                 controller.shopLogoController.clear();
              //               },
              //               icon: const Icon(Icons.close, color: Colors.red),
              //               padding: EdgeInsets.zero,
              //               constraints: const BoxConstraints(),
              //             ),
              //           ],
              //         ),
              //         SizedBox(height: 10.h),
              //         Center(
              //           child: ClipRRect(
              //             borderRadius: BorderRadius.circular(10),
              //             child: controller.isNetworkImage.value
              //                 ? CachedNetworkImage(
              //                     imageUrl: controller.imagePath.value,
              //                     height: 80.h,
              //                     width: 80.w,
              //                     fit: BoxFit.cover,
              //                     placeholder: (context, url) => const Center(
              //                       child: CircularProgressIndicator(),
              //                     ),
              //                     errorWidget: (context, url, error) =>
              //                         Assets.images.logo.image(
              //                       height: 80.h,
              //                       width: 80.w,
              //                       fit: BoxFit.cover,
              //                     ),
              //                   )
              //                 : Image.file(
              //                     File(controller.imagePath.value),
              //                     height: 80.h,
              //                     width: 80.w,
              //                     fit: BoxFit.cover,
              //                   ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   );
              // }),

              CustomFromCard(
                  title: AppStrings.description,
                  hinText: AppStrings.description,
                  controller: controller.descriptionController,
                  maxLine: 5,
                  validator: (v) {
                    return null;
                  }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 10,
          bottom: MediaQuery.of(context).padding.bottom + 10,
        ),
        child: CustomButton(
          textColor: AppColors.white50,
          fillColor: AppColors.black,
          onTap: () async {
            final result;
            if (isEditMode) {
              result = await controller.updateJobPost(jobId: jobPost?.id ?? '');
            } else {
              result = await controller.createBarberOwnerJobPost();
            }
            if (result == true) {
              if (context.mounted) {
                context.pop();
              }
            }
          },
          title: isEditMode ? AppStrings.save : AppStrings.create,
        ),
      ),

      ///============================ body ===============================
    );
  }
}
