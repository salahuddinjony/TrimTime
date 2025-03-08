import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/view/common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/settings/info_controller/info_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FaqsScreen extends StatelessWidget {
   FaqsScreen({super.key});
  final InfoController infoController = Get.find<InfoController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white50,

      ///============================ Header ===============================
      appBar: const CustomAppBar(
        appBarContent: AppStrings.faq,
        iconData: Icons.arrow_back,
      ),
      body: ClipPath(
        clipper: CurvedBannerClipper(),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 1.5,
          color: AppColors.normalHover,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: 2,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    /// **Question**
                    ListTile(
                      title: const CustomText(
                        maxLines: 2,
                        textAlign: TextAlign.start,
                        text: "No question available",
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      trailing: Obx(() {
                        final isSelected =
                            infoController.selectedIndex.value == index;
                        return Icon(
                          isSelected
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.green,
                        );
                      }),
                      onTap: () => infoController.toggleItem(index),
                    ),

                    /// **Answer**
                    Obx(() {
                      final isSelected =
                          infoController.selectedIndex.value == index;
                      return AnimatedCrossFade(
                        firstChild: Container(),
                        secondChild: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: CustomText(
                            maxLines: 50,
                            textAlign: TextAlign.start,
                            text: "No answer available",
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        crossFadeState: isSelected
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 300),
                      );
                    }),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
