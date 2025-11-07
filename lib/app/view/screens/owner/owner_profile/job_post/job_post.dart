import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/global/helper/extension/extension.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_border_card/custom_border_card.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/job_post/controller/barber_owner_job_post_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../common_widgets/show_grooming_dialoge/show_grooming_dialoge.dart';

class JobPost extends StatelessWidget {
  JobPost({
    super.key,
  });

  final controller = Get.find<BarberOwnerJobPostController>();

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

    debugPrint("===================${userRole?.name}");
    if (userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }
    return Scaffold(
      ///============================ Header ===============================
      appBar: const CustomAppBar(
        appBarContent: AppStrings.jobPost,
        iconData: Icons.arrow_back,
        appBarBgColor: AppColors.linearFirst,
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30.h),
        child: CustomButton(
          textColor: AppColors.white50,
          fillColor: AppColors.black,
          onTap: () {
            AppRouter.route.pushNamed(RoutePath.createJobPost, extra: userRole);
          },
          title: AppStrings.addNew,
        ),
      ),

      ///============================ body ===============================
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Obx(() {
          if (controller.barberJobPostStatus.value.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (controller.barberJobPostStatus.value.isError) {
            return Center(
              child: Text(AppStrings.somethingWentWrong),
            );
          }

          if (controller.barberJobPosts.isEmpty) {
            return Center(
              child: Text(AppStrings.noJobPostFound),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await controller.fetchBarberJobPost();
            },
            child: ListView.separated(
              itemCount: controller.barberJobPosts.length,
              separatorBuilder: (context, index) => SizedBox(height: 5.h),
              itemBuilder: (context, index) {
                final jobPost = controller.barberJobPosts[index];
                final logoWidget = (jobPost.shopLogo?.isNotEmpty == true)
                    ? CachedNetworkImage(
                        imageUrl: jobPost.shopLogo!,
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) =>
                            Assets.images.logo.image(height: 50),
                      )
                    : Assets.images.logo.image(height: 50);
                return GestureDetector(
                  onTap: () {
                    debugPrint('Job Post Tapped: ${jobPost.id}');
                  },
                  child: CustomBorderCard(
                    isEdit: true,
                    isEditTap: () {
                      AppRouter.route.pushNamed(
                        RoutePath.createJobPost,
                        extra: {
                          'userRole': userRole,
                          'jobPost': jobPost,
                          'isEditMode': true,
                        },
                      );
                    },
                    title: jobPost.shopName ?? 'Barber Shop',
                    time:
                        '${DateTime.tryParse(jobPost.startDate ?? '')?.formatDate() ?? ''} - ${DateTime.tryParse(jobPost.endDate ?? '')?.formatDate() ?? ''}',
                    price: jobPost.salary != null
                        ? '\$${jobPost.salary}'
                        : (jobPost.hourlyRate != null
                            ? '\$${jobPost.hourlyRate}/hr'
                            : '\$0'),
                    date: DateTime.tryParse(jobPost.datePosted ?? '')
                            ?.formatDate() ??
                        '02/10/23',
                    buttonText: 'See Description',
                    isButton: false,
                    isDelete: true,
                    onTapDelete: () {
                      showDialog(
                          context: context,
                          builder: (context) =>
                              deleteDialog(context, controller, jobPost.id as String));
                    },
                    isSeeDescription: true,
                    onButtonTap: () {},
                    logoImage: logoWidget,
                    seeDescriptionTap: () {
                      showGroomingDialog(
                        context: context,
                        logoImage: logoWidget,
                        barberShopName: jobPost.shopName,
                        barberShopDescription: jobPost.description,
                      );
                    },
                    isToggle: true,
                    toggleValue: jobPost.isActive ?? false,
                    onToggleChanged: (value) {
                      controller.toggleJobPostStatus(
                        jobId: jobPost.id ?? '',
                        isActive: value,
                      );
                    },
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }

  Widget deleteDialog(
      BuildContext context, BarberOwnerJobPostController controller, String jobPostId) {
    return AlertDialog(
      title: Text("Do you want to delete this job post?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text(AppStrings.cancel),
        ),
        TextButton(
          onPressed: () {
            controller.deleteJob(jobPostId);
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text(AppStrings.delete),
        ),
      ],
    );
  }
}
