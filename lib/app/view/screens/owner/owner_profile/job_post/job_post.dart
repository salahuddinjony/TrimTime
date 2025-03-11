import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/view/common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:flutter/material.dart';

class JobPost extends StatelessWidget {
  const JobPost({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///============================ Header ===============================
      appBar: const CustomAppBar(
        appBarContent: AppStrings.jobPost,
        iconData: Icons.arrow_back,
        appBarBgColor: AppColors.linearFirst,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: CustomButton(
          textColor: AppColors.white50,
          fillColor: AppColors.black,
          onTap: () {},
          title: AppStrings.add,
        ),
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
                //========================Save Button===============
              ],
            ),
          ),
        ),
      ),
    );
  }
}
