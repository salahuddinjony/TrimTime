import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/global/global_alart/global_alart.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../common_widgets/custom_menu_card/custom_menu_card.dart';

class Settings extends StatelessWidget {
  const Settings({
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
      appBar: const CustomAppBar(
        appBarBgColor: AppColors.linearFirst,
        appBarContent: AppStrings.settings,
        iconData: Icons.arrow_back,
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
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //=====loyaLity====
                userRole == UserRole.owner?
                CustomMenuCard(
                  onTap: () {
                    AppRouter.route.pushNamed(
                      RoutePath.loyalityScreen,extra: userRole
                    );
                  },
                  isContainerCard: true,
                  text: AppStrings.loyaLity,
                  icon: Assets.icons.location.svg(
                    colorFilter: const ColorFilter.mode(AppColors.normalHover, BlendMode.srcIn),
                  ),
                ):const SizedBox(),//=====faq====
                CustomMenuCard(
                  onTap: () {
                    AppRouter.route.pushNamed(
                      RoutePath.faqsScreen,extra: userRole
                    );
                  },
                  isContainerCard: true,
                  text: AppStrings.faq,
                  icon: Assets.icons.faq.svg(
                    colorFilter: const ColorFilter.mode(AppColors.normalHover, BlendMode.srcIn),
                  ),
                ), //=====termsAndConditions====
                CustomMenuCard(
                  onTap: () {
                    AppRouter.route.pushNamed(
                      RoutePath.termsScreen,extra: userRole
                    );
                  },
                  isContainerCard: true,
                  text: AppStrings.termsAndConditions,
                  icon: Assets.icons.terms.svg(
                    colorFilter: const ColorFilter.mode(AppColors.normalHover, BlendMode.srcIn),

                  ),
                ), //=====privacyPolicy====
                CustomMenuCard(
                  onTap: () {
                    AppRouter.route.pushNamed(
                      RoutePath.privacyPolicyScreen,extra: userRole
                    );
                  },
                  isContainerCard: true,
                  text: AppStrings.privacyPolicy,
                  icon: Assets.icons.privacy.svg(
                    colorFilter: const ColorFilter.mode(AppColors.normalHover, BlendMode.srcIn),

                  ),
                ), //=====changePassword====
                CustomMenuCard(
                  onTap: () {
                    AppRouter.route.pushNamed(
                      RoutePath.changePasswordScreen,extra: userRole
                    );
                  },
                  isContainerCard: true,
                  text: AppStrings.changePassword,
                  icon: Assets.icons.key.svg(
                    colorFilter: const ColorFilter.mode(AppColors.normalHover, BlendMode.srcIn),

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
                    colorFilter: const ColorFilter.mode(AppColors.normalHover, BlendMode.srcIn),

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
