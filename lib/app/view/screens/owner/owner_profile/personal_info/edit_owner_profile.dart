import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/view/common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_from_card/custom_from_card.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_radio_button/custom_radio_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/common_widgets/custom_text_field/custom_text_field.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/controller/owner_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditOwnerProfile extends StatelessWidget {
  EditOwnerProfile({
    super.key,
  });

  final OwnerProfileController controller = Get.find<OwnerProfileController>();

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
                    suffixIcon: const Icon(
                      Icons.calendar_month,
                      color: AppColors.white50,
                    ),
                    isRead: true,
                    isBgColor: true,
                    isBorderColor: true,
                    title: AppStrings.dateOfBirth,
                    controller: TextEditingController(text: '22/10/2024l'),
                    validator: (f) {}),
                const CustomText(
                  color: AppColors.black,
                  text: AppStrings.gender,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  bottom: 8,
                ),
                //Gender
                CustomRadioButtonRow(
                  genderController: TextEditingController(),
                ),
                //======================Phone Number=================
                const CustomText(
                  color: AppColors.black,
                  text: AppStrings.phoneNumber,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  bottom: 8,
                ),

                const Row(
                  children: [
                    Expanded(flex: 3, child: CustomTextField()),
                    SizedBox(width: 8,),
                    Expanded(flex: 7, child: CustomTextField()),
                  ],
                ),
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
