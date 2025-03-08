import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/view/common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/common_widgets/permission_button/permission_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../common_widgets/custom_menu_card/custom_menu_card.dart';

class PersonalInfo extends StatelessWidget {
  const PersonalInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///============================ Header ===============================
      appBar: const CustomAppBar(
        appBarContent: AppStrings.profile,
        iconData: Icons.arrow_back
        ,
      ),

      ///============================ body ===============================
      body: ClipPath(
        clipper: CurvedBannerClipper(),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 1.5,
          color: AppColors.normalHover,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //TOdo=====personalInformation====
                CustomMenuCard(
                  onTap: () {},
                  text: AppStrings.personalInformation,
                  icon: Assets.icons.personalInfo.svg(),
                ),
                //=====businessProfile====
                CustomMenuCard(
                  text: AppStrings.businessProfile,
                  icon: Assets.icons.business.svg(),
                ),
                //=====jobPost====
                CustomMenuCard(
                  text: AppStrings.jobPost,
                  icon: Assets.icons.job.svg(),
                ),
                //=====barbersTime====
                CustomMenuCard(
                  text: AppStrings.barber,
                  icon: Assets.images.berber.image(height: 20),
                ),
                //=====myFeedBack====
                CustomMenuCard(
                  text: AppStrings.myFeedBack,
                  icon: Assets.icons.myFeedBack.svg(),
                ), //=====addService====
                CustomMenuCard(
                  text: AppStrings.addService,
                  icon: Assets.icons.addService.svg(),
                ),
                //=====barbersTime====
                CustomMenuCard(
                  text: AppStrings.settings,
                  icon: Assets.icons.settings.svg(),
                ),
                //=====logOut====
                CustomMenuCard(
                  onTap: () {
                    permissionPopUp(
                        title: AppStrings.areYouSureYouWantToLogOut,
                        context: context,
                        ontapNo: () {
                          context.pop();
                        },
                        ontapYes: () {
                          AppRouter.route.goNamed(
                            RoutePath.choseRoleScreen,
                          );
                        });
                  },
                  isArrow: true,
                  isTextRed: true,
                  text: AppStrings.logOut,
                  icon: Assets.icons.logout.svg(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
