import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/settings/info_controller/info_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class PrivacyPolicyScreen extends StatelessWidget {
   PrivacyPolicyScreen({super.key});
  final InfoController infoController = Get.find<InfoController>();

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
      backgroundColor: AppColors.linearFirst,
      ///============================ Header ===============================
      appBar:  const CustomAppBar(
        appBarBgColor: AppColors.linearFirst,

        appBarContent: AppStrings.privacyPolicy,
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: Obx(
          (){
            if(infoController.isLoading.value){
              return const Center(child: CircularProgressIndicator());
            }
            if(infoController.privacyPolicy.isEmpty){
              return const Center(child: Text('No Privacy Policy available'));
            }
            return ListView.builder(
              itemCount: infoController.privacyPolicy.length,
              itemBuilder: (context, index) {
                final item = infoController.privacyPolicy[index];
                return _buildPrivacyItem(item);
              },
            );
          }

        ),
      ),
    );
  }

  Widget _buildPrivacyItem(dynamic item) {
    // item may be a model with `heading` and `content` fields or a Map
    final heading = (item?.heading ?? item['heading'] ?? '') as String;
    final content = (item?.content ?? item['content'] ?? '') as String;

    return Card(
      color: Colors.white.withValues(alpha: .9),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: heading,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 8),
            CustomText(
              text: content,
              fontSize: 14,
              maxLines: 20,
            ),
          ],
        ),
      ),
    );
  }
}
