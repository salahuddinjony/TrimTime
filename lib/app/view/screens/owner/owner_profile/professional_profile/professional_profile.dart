import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/global/helper/extension/extension.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/common_profile_total_card/common_profile_total_card.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/view_image_gallery/widgets/design_files_gallery.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/controller/owner_profile_controller.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/models/profile_response_model.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/models/barber_professional_profile.dart';
import 'package:flutter/material.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/bottom_navbar.dart';
import '../../../../common_widgets/common_profile_card/common_profile_card.dart';

class ProfessionalProfile extends StatelessWidget {
  final ProfileData? data;
  final UserRole? userRole;
  final OwnerProfileController? controller;
  final String? barberId; // For viewing other barber's profile
  final bool isForActionButton;
  final VoidCallback? onActionApprove;
  final VoidCallback? onActionReject;


  const ProfessionalProfile({
    super.key,
    this.data,
    this.userRole,
    this.controller,
    this.barberId,
    this.isForActionButton = false,
    this.onActionApprove,
    this.onActionReject,
  });

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

    // Determine if viewing own profile or another barber's profile
    final bool isViewingOtherBarber = barberId != null;
    final OwnerProfileController ctrl =
        controller ?? Get.find<OwnerProfileController>();

    // Fetch barber profile if viewing another barber
    if (isViewingOtherBarber && barberId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ctrl.fetchBarberProfileById(barberId!);
      });
    }

    return Scaffold(
      bottomNavigationBar: isViewingOtherBarber
          ? null
          : BottomNavbar(
              currentIndex: 4,
              role: userRole,
            ),
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
                final bool isLoading = isViewingOtherBarber
                    ? ctrl.isOtherBarberProfileLoading.value
                    : ctrl.isBarberProfessionalProfileLoading.value;

                final BarberProfile? professionalData = isViewingOtherBarber
                    ? ctrl.otherBarberProfile.value
                    : (ctrl.barberProfessionalProfileList.isNotEmpty
                        ? ctrl.barberProfessionalProfileList.first
                        : null);

                if (isLoading) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }

                if (professionalData == null) {
                  final height = MediaQuery.of(context).size.height;
                  return SizedBox(
                    height: height * 0.5,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CommonProfileCard(
                            name: data?.fullName.safeCap() ??
                                professionalData?.user?.fullName ??
                                'Unknown',
                            bio: 'No professional profile available',
                            imageUrl: '',
                            showEditIcon: !isViewingOtherBarber,
                            onEditTap: !isViewingOtherBarber
                                ? () {
                                    AppRouter.route.pushNamed(
                                      RoutePath.editProfessionalProfile,
                                      extra: {
                                        'userRole': userRole,
                                        'data': data,
                                        'controller': ctrl,
                                      },
                                    );
                                  }
                                : null,
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  );
                }

                // Choose profile image from portfolio or user image
                String imageUrl = professionalData.portfolio.isNotEmpty
                    ? professionalData.portfolio.first
                    : (professionalData.user?.image ?? '');

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CommonProfileCard(
                      isBarberProfile: true,
                      name: professionalData.user?.fullName ??
                          data?.fullName.safeCap() ??
                          'Unknown',
                      bio: professionalData.bio ?? "No bio available",
                      imageUrl: imageUrl,
                      showEditIcon: !isViewingOtherBarber,
                      onEditTap: !isViewingOtherBarber
                          ? () {
                              AppRouter.route.pushNamed(
                                RoutePath.editProfessionalProfile,
                                extra: {
                                  'userRole': userRole,
                                  'professionalData': professionalData,
                                  'controller': ctrl,
                                },
                              );
                            }
                          : null,
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

                    const SizedBox(height: 10),

                    //==================✅✅Total Card✅✅===================
                    Row(
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
                    ),

                    SizedBox(height: 35.h),

                    // Skills chips coming from professional profile
                    Column(
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
                                '${professionalData.experienceYears ?? 'N/A'} years',
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
                        const SizedBox(height: 12),
                        CustomText(
                          text: 'Portfolio:',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.black,
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 100.w,
                          height: 100.h,
                          child: DesignFilesGallery(
                            designFiles: professionalData.portfolio.map((e) {
                              return e;
                            }).toList(),
                            height: 100.h,
                            width: double.infinity,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        // action button for Accept/Reject
                        if (isForActionButton && (onActionApprove != null && onActionReject != null)) ...[
                          Row(
                            children: [
                              Expanded(
                                  flex: 5,
                                  child: CustomButton(
                                    title: AppStrings.reject,
                                    onTap: onActionReject,
                                    fillColor: Colors.white,
                                  )),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                  flex: 5,
                                  child: CustomButton(
                                    onTap: onActionApprove,
                                    fillColor: AppColors.bottomColor,
                                    title: AppStrings.approve,
                                    textColor: Colors.white,
                                  )),
                            ],
                          )
                        ],
                        SizedBox( height: 20.h)
                      ],
                    ),

                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
