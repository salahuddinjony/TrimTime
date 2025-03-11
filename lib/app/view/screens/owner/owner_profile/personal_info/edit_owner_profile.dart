import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/view/common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_from_card/custom_from_card.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:flutter/material.dart';

class EditOwnerProfile extends StatelessWidget {
  const EditOwnerProfile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///============================ Header ===============================
      appBar: const CustomAppBar(
        appBarContent: AppStrings.editProfile,
        iconData: Icons.arrow_back,
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
                Center(
                    child: CustomNetworkImage(
                        boxShape: BoxShape.circle,
                        imageUrl: AppConstants.demoImage,
                        height: 102,
                        width: 102)),
                //name
                CustomFromCard(
                    isBgColor: true,
                    isBorderColor: true,
                    title: AppStrings.name,
                    controller: TextEditingController(text: " james"),
                    validator: (f) {}),
                //dateOfBirth
                CustomFromCard(
                    suffixIcon: const Icon(Icons.calendar_month,color: AppColors.white50,),
                    isRead: true,
                    isBgColor: true,
                    isBorderColor: true,
                    title: AppStrings.dateOfBirth,
                    controller: TextEditingController(text: '22/10/2024l'),
                    validator: (f) {}),
                //location
                CustomFromCard(
                    isBgColor: true,
                    isBorderColor: true,
                    title: AppStrings.location,
                    controller: TextEditingController(text: 'Abu Dhabi'),
                    validator: (f) {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
