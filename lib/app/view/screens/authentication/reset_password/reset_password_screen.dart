
import 'package:barber_time/app/global/controller/auth_controller/auth_controller.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_from_card/custom_from_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final AuthController authController = Get.find<AuthController>();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.normalHover,

      ///: <<<<<<======🗄️🗄️🗄️🗄️🗄️🗄️💡💡Reset password💡💡🗄️🗄️🗄️🗄️🗄️🗄️🗄️>>>>>>>>===========
      appBar: CustomAppBar(
        appBarContent: AppStrings.resetPassword ,
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
        child: Column(
          children: [
            CustomFromCard(
                title: AppStrings.fullName,
                controller: authController.fullNameController,
                validator: (v) {}),
          ],
        )
      ),
    );
  }
}
