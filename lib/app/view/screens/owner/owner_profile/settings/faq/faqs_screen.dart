import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/settings/info_controller/info_controller.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/settings/faq/models/faq_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class FaqsScreen extends StatelessWidget {
   FaqsScreen({super.key});
  final InfoController infoController = Get.find<InfoController>();

  @override
  Widget build(BuildContext context) {
    final extra = GoRouter.of(context).state.extra;
    UserRole? userRole;
    if (extra is UserRole) {
      userRole = extra;
    } else if (extra is Map) {
      try {
        userRole = extra['userRole'] as UserRole?;
      } catch (_) {
        userRole = null;
      }
    }
    debugPrint("===================${userRole?.name}");
    if (userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }
    return Scaffold(
      backgroundColor: AppColors.white50,

      ///============================ Header ===============================
      appBar: const CustomAppBar(
        appBarBgColor: AppColors.linearFirst,
        appBarContent: AppStrings.faq,
        iconData: Icons.arrow_back,
      ),
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
          child: Obx(() {
            if (infoController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final List<FaqItem> items = infoController.faqs;
            if (items.isEmpty) {
              return const Center(child: Text('No FAQs available'));
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Obx(() {
                  final isSelected = infoController.selectedIndex.value == index;
                  return Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: CustomText(
                            maxLines: 2,
                            textAlign: TextAlign.start,
                            text: item.question,
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          trailing: Icon(
                            isSelected
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.green,
                          ),
                          onTap: () => infoController.toggleItem(index),
                        ),
                        AnimatedCrossFade(
                          firstChild: Container(),
                          secondChild: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: CustomText(
                              maxLines: 50,
                              textAlign: TextAlign.start,
                              text: item.answer,
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          crossFadeState: isSelected
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 300),
                        ),
                      ],
                    ),
                  );
                });
              },
            );
          }),
        ),
      ),
    );
  }
}
