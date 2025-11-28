import 'dart:io';

import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/bottom_navbar.dart';
import '../../../../../common_widgets/custom_menu_card/custom_menu_card.dart';

class BarberPersonalProfile extends StatefulWidget {
  const BarberPersonalProfile({
    super.key,
  });

  @override
  State<BarberPersonalProfile> createState() => _BarberPersonalProfileState();
}

class _BarberPersonalProfileState extends State<BarberPersonalProfile> {
  final String videoThumbnailPath = '/storage/emulated/0/Download/sample_thumbnail.png';

  @override
  Widget build(BuildContext context) {

    final userRole = GoRouter.of(context).state.extra as UserRole?;

    debugPrint("===================${userRole?.name}");
    if (userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }
    return Scaffold(
      bottomNavigationBar: BottomNavbar(
        currentIndex: 4,
        role: userRole,
      ),
      ///============================ Header ===============================
      appBar: const CustomAppBar(
        appBarContent: AppStrings.profile,
        iconData: Icons.arrow_back,
        appBarBgColor: AppColors.linearFirst,
      ),

      ///============================ body ===============================
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xCCEDC4AC),
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
                      CustomNetworkImage(
                          boxShape: BoxShape.circle,
                          imageUrl: AppConstants.demoImage,
                          height: 102,
                          width: 102),
                      const CustomText(
                        top: 8,
                        text: "Jane Cooper",
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: AppColors.black,
                      ),
                      const CustomText(
                        top: 8,
                        text: "Jane@example.com",
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        bottom: 10,
                        color: AppColors.black,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            AppRouter.route.pushNamed(RoutePath.barberEditProfile,
                                extra: userRole);
                          },
                          child: Container(
                            width: 130.w,
                            padding: EdgeInsets.all(10.r),
                            decoration: BoxDecoration(
                                border: Border.all(color: AppColors.secondary),
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              children: [
                                CustomText(
                                  textAlign: TextAlign.center,
                                  text: AppStrings.editProfile,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.sp,
                                  color: AppColors.secondary,
                                  left: 8,
                                  right: 8,
                                ),
                                Assets.icons.edit.svg()
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),

              SizedBox(
                height: 10.h,
              ),

              //TOdo=====name====
              CustomMenuCard(
                onTap: () {},
                isArrow: true,
                text: "james",
                icon: Assets.icons.personalInfo.svg(
                  colorFilter:
                      const ColorFilter.mode(AppColors.black, BlendMode.srcIn),
                ),
              ),
              //=====date====
              CustomMenuCard(
                isArrow: true,
                text: "22-03-1998",
                icon: Assets.icons.date.svg(
                  colorFilter:
                      const ColorFilter.mode(AppColors.black, BlendMode.srcIn),
                ),
              ),
              //=====gender====
              CustomMenuCard(
                isArrow: true,
                text: "male",
                icon: Assets.icons.gender.svg(
                  colorFilter:
                      const ColorFilter.mode(AppColors.black, BlendMode.srcIn),
                ),
              ),
              //=========phone===
              CustomMenuCard(
                text: '+4412451211',
                icon: Assets.icons.phone.svg(
                  colorFilter:
                      const ColorFilter.mode(AppColors.black, BlendMode.srcIn),
                ),
                isArrow: true,
              ),
              //=====location====
              CustomMenuCard(
                isArrow: true,
                text: 'Abu dhabi',
                icon: Assets.icons.location.svg(
                  colorFilter:
                      const ColorFilter.mode(AppColors.black, BlendMode.srcIn),
                ),
              ),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // Image thumbnail
                    CustomNetworkImage(
                      borderRadius: BorderRadius.circular(10),
                      imageUrl: AppConstants.style1,
                      height: 120,
                      width: 160,
                    ),
                    const SizedBox(width: 10),

                    CustomVideoThumbnails(
                      thumbnailPath: videoThumbnailPath,
                      height: 120,
                      width: 160,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}


class CustomVideoThumbnails extends StatelessWidget {
  final String thumbnailPath;
  final double height;
  final double width;
  final BorderRadius borderRadius;

  const CustomVideoThumbnails({
    super.key,
    required this.thumbnailPath,
    required this.height,
    required this.width,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: borderRadius,
          child: File(thumbnailPath).existsSync()
              ? Image.file(
            File(thumbnailPath),
            height: height,
            width: width,
            fit: BoxFit.cover,
          )
              : Container(
            height: height,
            width: width,
            color: Colors.grey,
            child: const Center(
              child: Text(
                'Thumbnail not found',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}