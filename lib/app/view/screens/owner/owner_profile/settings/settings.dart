import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/global/global_alart/global_alart.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/view/common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:flutter/material.dart';

import '../../../../common_widgets/custom_menu_card/custom_menu_card.dart';

class Settings extends StatelessWidget {
  const Settings({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///============================ Header ===============================
      appBar: const CustomAppBar(
        appBarContent: AppStrings.settings,
        iconData: Icons.arrow_back,
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
                //=====loyaLity====
                CustomMenuCard(
                  onTap: () {
                    AppRouter.route.pushNamed(
                      RoutePath.loyaltyScreen,
                    );
                  },
                  isContainerCard: true,
                  text: AppStrings.loyaLity,
                  icon: Assets.icons.location.svg(
                    color: AppColors.normalHover,
                  ),
                ), //=====faq====
                CustomMenuCard(
                  onTap: () {
                    AppRouter.route.pushNamed(
                      RoutePath.faqsScreen,
                    );
                  },
                  isContainerCard: true,
                  text: AppStrings.faq,
                  icon: Assets.icons.faq.svg(
                    color: AppColors.normalHover,
                  ),
                ), //=====termsAndConditions====
                CustomMenuCard(
                  onTap: () {
                    AppRouter.route.pushNamed(
                      RoutePath.termsScreen,
                    );
                  },
                  isContainerCard: true,
                  text: AppStrings.termsAndConditions,
                  icon: Assets.icons.terms.svg(
                    color: AppColors.normalHover,
                  ),
                ), //=====privacyPolicy====
                CustomMenuCard(
                  onTap: () {
                    AppRouter.route.pushNamed(
                      RoutePath.privacyPolicyScreen,
                    );
                  },
                  isContainerCard: true,
                  text: AppStrings.privacyPolicy,
                  icon: Assets.icons.privacy.svg(
                    color: AppColors.normalHover,
                  ),
                ), //=====changePassword====
                CustomMenuCard(
                  onTap: () {
                    AppRouter.route.pushNamed(
                      RoutePath.changePasswordScreen,
                    );
                  },
                  isContainerCard: true,
                  text: AppStrings.changePassword,
                  icon: Assets.icons.key.svg(
                    color: AppColors.normalHover,
                  ),
                ),
                //=====deleteAccount====
                CustomMenuCard(
                  onTap: () {
                    GlobalAlert.showDeleteDialog(
                        context, () {}, AppStrings.areYouSureYouWantToDelete);
                  },
                  isArrow: true,
                  isContainerCard: true,
                  text: AppStrings.deleteAccount,
                  icon: Assets.icons.delete.svg(
                    color: AppColors.normalHover,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
