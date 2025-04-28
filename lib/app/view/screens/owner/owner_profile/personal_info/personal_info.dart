import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../common_widgets/custom_menu_card/custom_menu_card.dart';

class PersonalInfo extends StatelessWidget {
  const PersonalInfo({
    super.key,
  });

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
      ///============================ Header ===============================
      appBar: CustomAppBar(
        appBarContent: AppStrings.profile,
        iconData: Icons.arrow_back,
        isIcon: true,
        onTap: () {
          AppRouter.route
              .pushNamed(RoutePath.editOwnerProfile, extra: userRole);
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
                      color: AppColors.black,
                    ),
                  ],
                )),
                //TOdo=====name====
                CustomMenuCard(
                  onTap: () {},
                  isArrow: true,
                  text: "james",
                  icon: Assets.icons.personalInfo.svg(  colorFilter: const ColorFilter.mode(
                      AppColors.black, BlendMode.srcIn),),
                ),
                //=====date====
                CustomMenuCard(
                  isArrow: true,
                  text: "22-03-1998",
                  icon: Assets.icons.date.svg(  colorFilter: const ColorFilter.mode(
                      AppColors.black, BlendMode.srcIn),),
                ),
                //=====gender====
                CustomMenuCard(
                  isArrow: true,
                  text: "male",
                  icon: Assets.icons.gender.svg(  colorFilter: const ColorFilter.mode(
                      AppColors.black, BlendMode.srcIn),),
                ),
                //=========phone===
                CustomMenuCard(
                  text: '+4412451211',
                  icon: Assets.icons.phone.svg(  colorFilter: const ColorFilter.mode(
                      AppColors.black, BlendMode.srcIn),),
                  isArrow: true,
                ),
                //=====location====
                CustomMenuCard(
                  isArrow: true,
                  text: 'Abu dhabi',
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
