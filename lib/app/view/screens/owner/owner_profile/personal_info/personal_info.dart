import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/global/helper/extension/extension.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/controller/owner_profile_controller.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/models/profile_response_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../common_widgets/custom_menu_card/custom_menu_card.dart';

class PersonalInfo extends StatelessWidget {
  final UserRole? userRole;
  final ProfileData data;
  final OwnerProfileController controller;
  const PersonalInfo({
    super.key,
    this.userRole,
    required this.data,
    required this.controller,
  });

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
      appBar: CustomAppBar(
        appBarContent: AppStrings.profile,
        iconData: Icons.arrow_back,
        isIcon: false,
        onTap: () {
          context.pop();
          // AppRouter.route
          //     .pushNamed(RoutePath.editOwnerProfile, extra: userRole);
        },
        appBarBgColor: AppColors.linearFirst,
      ),

      ///============================ body ===============================
      body: ClipPath(
        clipper: CurvedBannerClipper(),
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xCCEDC4AC), // First color (with opacity)
                Color(0xFFE9874E),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //TOdo=====Header====
                Center(
                  child: Column(
                  children: [
                    Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      CustomNetworkImage(
                      boxShape: BoxShape.circle,
                      imageUrl: data.image ?? AppConstants.demoImage,
                      height: 102,
                      width: 102,
                      ),
                      Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                          BoxShadow(
                          color: Colors.black.withValues(alpha: .1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                          ),
                        ],
                        ),
                        child: IconButton(
                        icon: const Icon(Icons.edit, size: 20, color: AppColors.linearFirst),
                        onPressed: () {
                          AppRouter.route.pushNamed(
                            RoutePath.editOwnerProfile,
                            extra:{
                              'userRole': userRole,
                              'profileData': data,
                              "controller": controller,
                            }
                          );
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        ),
                      ),
                      ),
                    ],
                    ),
                    CustomText(
                    top: 8,
                    text: data.fullName.safeCap(),
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColors.black,
                    ),
                    CustomText(
                    top: 8,
                    text: data.email,
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: AppColors.black,
                    ),
                  ],
                  ),
                ),
                //TOdo=====name====
                CustomMenuCard(
                  onTap: () {},
                  isArrow: true,
                  text: data.fullName.safeCap(),
                  icon: Assets.icons.personalInfo.svg(  colorFilter: const ColorFilter.mode(
                      AppColors.black, BlendMode.srcIn),),
                ),
                //=====date====
                CustomMenuCard(
                  isArrow: true,
                  text: data.dateOfBirth != null
                      ? '${data.dateOfBirth!.day.toString().padLeft(2, '0')}/${data.dateOfBirth!.month.toString().padLeft(2, '0')}/${data.dateOfBirth!.year}'
                      : 'N/A',
                  icon: Assets.icons.date.svg(  colorFilter: const ColorFilter.mode(
                      AppColors.black, BlendMode.srcIn),),
                ),
                //=====gender====
                CustomMenuCard(
                  isArrow: true,
                  text: data.gender.safeCap(),
                  icon: Assets.icons.gender.svg(  colorFilter: const ColorFilter.mode(
                      AppColors.black, BlendMode.srcIn),),
                ),
                //=====gender====
                // CustomMenuCard(
                //   isArrow: true,
                //   text: data.role.safeCap(),
                //   icon: Assets.icons.gender.svg(  colorFilter: const ColorFilter.mode(
                //       AppColors.black, BlendMode.srcIn),),
                // ),

                //=========phone===
                CustomMenuCard(
                  text: data.phoneNumber ?? 'N/A',
                  icon: Assets.icons.phone.svg(  colorFilter: const ColorFilter.mode(
                      AppColors.black, BlendMode.srcIn),),
                  isArrow: true,
                ),
                //=====location====
                CustomMenuCard(
                  isArrow: true,
                  text: data.address ?? 'N/A',
                  icon: Assets.icons.location.svg(
                    colorFilter: const ColorFilter.mode(
                        AppColors.black, BlendMode.srcIn),
                  ),
                ), //=====addService====
              ],
            ),
          ),
        ),
      ),
    );
  }
}
