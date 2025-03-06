import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/global/controller/auth_controller/auth_controller.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import 'package:barber_time/app/view/common_widgets/curved_short_clipper/curved_short_clipper.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_container_button/custom_container_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_from_card/custom_from_card.dart';
import 'package:barber_time/app/view/common_widgets/custom_rich_text/custom_rich_text.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final userRole = GoRouterState.of(context).extra as UserRole?;
    debugPrint("Selected Role============================${userRole?.name}");
    return Scaffold(
      body: SingleChildScrollView(
        child: Obx(() {
          return Column(
            children: [
              ClipPath(
                clipper: CurvedBannerClipper(),
                child: Container(
                    width: double.infinity,
                    // height: MediaQuery.of(context).size.height / 1.3,
                    // Adjust height according to your design
                    color: AppColors.normalHover,
                    // Brown color similar to your design
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 30.h,
                          ),
                          const CustomText(
                            textAlign: TextAlign.start,
                            text: AppStrings.welcomeBack,
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                            color: AppColors.white50,
                          ),

                          Center(child: Assets.images.signInLogo.image()),
                          SizedBox(
                            height: 10.h,
                          ),

                          //ToDo ==========✅✅ Email✅✅==========
                          CustomFromCard(
                              hinText: AppStrings.enterYourEmail,
                              title: AppStrings.email,
                              controller: authController.emailController,
                              validator: (v) {}),
                          //ToDo ==========✅✅ password ✅✅==========
                          CustomFromCard(
                              isPassword: true,
                              hinText: AppStrings.enterYourPassword,
                              title: AppStrings.password,
                              controller: authController.passwordController,
                              validator: (v) {}),

                          ///: <<<<<<======🗄️🗄️🗄️🗄️🗄️🗄️💡💡Forgot Password💡💡🗄️🗄️🗄️🗄️🗄️🗄️🗄️>>>>>>>>===========

                          Row(
                            children: [
                              Checkbox(
                                value: authController.isRemember.value,
                                checkColor: AppColors.white50,
                                activeColor: AppColors.black,
                                onChanged: (value) {
                                  authController.isRemember.value =
                                      value ?? false;
                                  debugPrint(
                                      "Checkbox clicked, Remember value: ${authController.isRemember.value}");
                                },
                              ),
                              const CustomText(
                                top: 12,
                                text: AppStrings.rememberMe,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.white50,
                                bottom: 15,
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  context.push(RoutePath.forgetPasswordScreen);
                                },
                                child: CustomText(
                                  top: 12,
                                  text: AppStrings.forgotPassword.tr,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.white50,
                                  bottom: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
              ),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: [
                      //ToDo ==========✅✅ Sing In Button✅✅==========
                      CustomButton(
                        onTap: () {
                          context.pushNamed(RoutePath.homeScreen,
                             );
                          // Pass role
                        },
                        title: AppStrings.signIn,
                        fillColor: Colors.black,
                        textColor: Colors.white,
                      ),

                      SizedBox(
                        height: 50.h,
                      ),
                      //ToDo ==== ======✅✅ dontHaveAnAccount✅✅==========
                      CustomRichText(
                          firstText: AppStrings.dontHaveAnAccount,
                          secondText: AppStrings.signUp,
                          onTapAction: () {
                            context.pushNamed(
                              RoutePath.signUpScreen,
                            );
                          }),
                    ],
                  )),
            ],
          );
        }),
      ),
    );
  }
}
