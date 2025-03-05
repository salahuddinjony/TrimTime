import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/global/controller/auth_controller/auth_controller.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/view/common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import 'package:barber_time/app/view/common_widgets/curved_short_clipper/curved_short_clipper.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_container_button/custom_container_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_from_card/custom_from_card.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ClipPath(
            clipper: CurvedBannerClipper(),
            child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 1.3,
                // Adjust height according to your design
                color: AppColors.normalHover,
                // Brown color similar to your design
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 30),
                  child: Column(
                    children: [

                      const CustomText(
                        text: AppStrings.signUp,
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: AppColors.white50,
                      ),
                      //ToDo ==========✅✅ fullName ✅✅==========
                      CustomFromCard(
                          title: AppStrings.fullName,
                          controller: authController.fullNameController,
                          validator: (v) {}),
                      //ToDo ==========✅✅ Email✅✅==========
                      CustomFromCard(
                          title: AppStrings.email,
                          controller: authController.emailController,
                          validator: (v) {}),
                      //ToDo ==========✅✅ password ✅✅==========
                      CustomFromCard(
                          title: AppStrings.password,
                          controller: authController.passwordController,
                          validator: (v) {}),

                      //ToDo ==========✅✅ Confirm ✅✅==========
                      CustomFromCard(
                          title: AppStrings.confirmPassword,
                          controller: authController.confirmPasswordController,
                          validator: (v) {}),
                    ],
                  ),
                )),
          ),
          SingleChildScrollView(
            child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: CustomButton(
                  onTap: () {
                    // context.push(RoutePath.signInScreen);
                  },
                  title: "SIng",
                  fillColor: Colors.black,
                  textColor: Colors.white,
                )),
          ),
        ],
      ),
    );
  }
}
