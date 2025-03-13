import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/global/controller/auth_controller/auth_controller.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
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
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xCCEDC4AC), // First color (with opacity)
                          Color(0xFFE9864E),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
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
                            color: AppColors.black,
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
                                color: AppColors.black,
                                bottom: 15,
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  AppRouter.route.pushNamed(
                                      RoutePath.forgetPasswordScreen,
                                      extra: userRole);
                                },
                                child: CustomText(
                                  top: 12,
                                  text: AppStrings.forgotPassword.tr,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.black,
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
                          if (userRole == UserRole.user) {
                            AppRouter.route.goNamed(RoutePath.homeScreen, extra: userRole);
                          } else if (userRole == UserRole.barber) {
                            AppRouter.route.goNamed(RoutePath.barberHomeScreen, extra: userRole);
                          } else if (userRole == UserRole.owner) {
                            AppRouter.route.goNamed(RoutePath.ownerHomeScreen, extra: userRole);
                          } else {
                            print('No route selected');
                          }
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
                            if (userRole == UserRole.user) {
                              AppRouter.route.pushNamed(RoutePath.signUpScreen,
                                  extra: userRole);
                            } else if (userRole == UserRole.barber) {
                              AppRouter.route.pushNamed(RoutePath.signUpScreen,
                                  extra: userRole);
                            } else if (userRole == UserRole.owner) {
                              AppRouter.route.pushNamed(RoutePath.ownerSignUp,
                                  extra: userRole);
                            } else {
                              debugPrint('Unknown user role: ');
                            }
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
