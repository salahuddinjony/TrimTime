import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/view/common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_from_card/custom_from_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white50,

      ///============================ Header ===============================
      appBar: const CustomAppBar(
        appBarContent: AppStrings.changePassword,
        iconData: Icons.arrow_back,
      ),
      body: ClipPath(
        clipper: CurvedBannerClipper(),
        child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 1.5,
            color: AppColors.normalHover,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  //current password
                  CustomFromCard(
                      isBorderColor: true,
                      isPassword: true,
                      title: AppStrings.currentPassword,
                      hinText: AppStrings.enterCurrentPassword,
                      controller: TextEditingController(),
                      validator: (v) {}),

                  //New Password
                  CustomFromCard(
                      isBorderColor: true,
                      isPassword: true,
                      title: AppStrings.newPassword,
                      hinText: AppStrings.enterNewPassword,
                      controller: TextEditingController(),
                      validator: (v) {}),

                  //retype password
                  CustomFromCard(
                      isBorderColor: true,
                      isPassword: true,
                      title: AppStrings.retypePassword,
                      hinText: AppStrings.retypeNewPassword,
                      controller: TextEditingController(),
                      validator: (v) {}),
                  SizedBox(
                    height: 50.h,
                  ),
                  //=====================Change password Button===============
                  CustomButton(
                    onTap: () {},
                    fillColor: AppColors.white50,
                    title: AppStrings.changePassword,
                  )
                ],
              ),
            )),
      ),
    );
  }
}
