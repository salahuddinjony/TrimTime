import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/global/helper/extension/extension.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/common_profile_total_card/common_profile_total_card.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/controller/owner_profile_controller.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/models/profile_response_model.dart';
import 'package:flutter/material.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:go_router/go_router.dart';

import '../../../../common_widgets/common_profile_card/common_profile_card.dart';

class ProfessionalProfile extends StatelessWidget {
  final ProfileData data;
  final UserRole? userRole;
  final OwnerProfileController controller;

  const ProfessionalProfile(
      {super.key, required this.data, this.userRole, required this.controller});

  @override
  Widget build(BuildContext context) {
    final extra = GoRouter.of(context).state.extra;
    UserRole? userRoleFromExtra;
    if (extra is UserRole) {
      userRoleFromExtra = extra;
    } else if (extra is Map) {
      try {
        userRoleFromExtra = extra['userRole'] as UserRole?;
      } catch (_) {
        userRoleFromExtra = null;
      }
    }
    final userRole = this.userRole ?? userRoleFromExtra;

    debugPrint("===================${userRole?.name}");
    if (userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }
    return Scaffold(
      backgroundColor: AppColors.linearFirst,
      //==================✅✅Header✅✅===================
      appBar: const CustomAppBar(
        appBarBgColor: AppColors.linearFirst,
        appBarContent: "Barber Profile",
        iconData: Icons.arrow_back,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() {
                if (controller.isBarberProfessionalProfileLoading.value) {
                  return const SizedBox(
                    height: 180,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (controller.barberProfessionalProfileList.isEmpty) {
                  final height = MediaQuery.of(context).size.height;
                  return SizedBox(
                    height: height * 0.5,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CommonProfileCard(
                            name: data.fullName.safeCap(),
                            bio: 'No professional profile available',
                            imageUrl: '',
                            onEditTap: () {
                              AppRouter.route.pushNamed(
                                RoutePath.editProfessionalProfile,
                                extra: {
                                  'userRole': userRole,
                                  'data': data,
                                  'controller': controller,
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  );
                }

                final professionalData =
                    controller.barberProfessionalProfileList.first;

                // Choose profile image from portfolio if available
                String imageUrl = professionalData.portfolio.isNotEmpty
                    ? professionalData.portfolio.first
                    : '';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CommonProfileCard(
                      name: data.fullName.safeCap(),
                      bio: professionalData.bio ?? "No bio available",
                      imageUrl: imageUrl,
                      onEditTap: () {
                        AppRouter.route.pushNamed(
                          RoutePath.editProfessionalProfile,
                          extra: {
                            'userRole': userRole,
                            'professionalData': professionalData,
                            'controller': controller,
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 8),

                    // Availability and rating row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                size: 12,
                                color: professionalData.isAvailable
                                    ? Colors.greenAccent
                                    : Colors.redAccent,
                              ),
                              const SizedBox(width: 6),
                              CustomText(
                                text: professionalData.isAvailable
                                    ? 'Available'
                                    : 'Not available',
                                fontSize: 14,
                                color: AppColors.black,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber),
                              const SizedBox(width: 6),
                              CustomText(
                                text:
                                    '${professionalData.avgRating.toStringAsFixed(1)} (${professionalData.ratingCount})',
                                fontSize: 14,
                                color: AppColors.black,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),

              const SizedBox(
                height: 10,
              ),

              //==================✅✅Total Card✅✅===================
              Obx(() {
                if (controller.isBarberProfessionalProfileLoading.value) {
                  return const SizedBox(
                    height: 80,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (controller.barberProfessionalProfileList.isEmpty) {
                  return const SizedBox.shrink();
                }

                final professionalData =
                    controller.barberProfessionalProfileList.first;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CommonProfileTotalCard(
                      title: 'Rating',
                      value:
                          '${professionalData.avgRating.toStringAsFixed(1)} (${professionalData.ratingCount})',
                    ),
                    SizedBox(width: 8),
                    CommonProfileTotalCard(
                      title: AppStrings.following,
                      value: professionalData.followingCount.toString(),
                    ),
                    SizedBox(width: 8),
                    CommonProfileTotalCard(
                      title: 'Followers',
                      value: professionalData.followerCount.toString(),
                    ),
                  ],
                );
              }),

              SizedBox(
                height: 35.h,
              ),

              // Skills chips coming from professional profile
              Obx(() {
                if (controller.isBarberProfessionalProfileLoading.value)
                  return const SizedBox.shrink();
                if (controller.barberProfessionalProfileList.isEmpty)
                  return const SizedBox.shrink();
                final professionalData =
                    controller.barberProfessionalProfileList.first;
                final experience = professionalData.experienceYears ?? 'N/A';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomText(
                          text: 'Experience:',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.black,
                        ),
                        const SizedBox(width: 5),
                        Chip(
                          backgroundColor: Colors.white,
                          label: Text(
                            '$experience years',
                            style: const TextStyle(color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    CustomText(
                      text: 'Skills:',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black,
                    ),
                    Wrap(
                      spacing: 5,
                      runSpacing: 2,
                      children: professionalData.skills.map<Widget>((s) {
                        return Chip(
                          backgroundColor: Colors.white,
                          label: Text(s,
                              style: const TextStyle(color: Colors.black)),
                        );
                      }).toList(),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
