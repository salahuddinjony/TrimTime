import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/global/controller/payment_controller/payment_controller.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_payment_card/custom_payment_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class SubscriptionPlan extends StatelessWidget {
  SubscriptionPlan({super.key});

  final PaymentController controller = Get.find<PaymentController>();

  @override
  Widget build(BuildContext context) {
    final userRole = GoRouterState.of(context).extra as UserRole?;
    debugPrint("Selected Role============================${userRole?.name}");
    return Scaffold(
      appBar: const CustomAppBar(
        appBarContent: AppStrings.subscriptionPlan,
        appBarBgColor: AppColors.linearFirst,
        iconData: Icons.arrow_back,
      ),
      body: SingleChildScrollView(
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  CustomSubscriptionCard(
                    price: "€23.99",
                    features: controller.paymentConditions,
                    iconAsset: Assets.images.silver.path,
                    cardColor: Colors.white,
                    textColor: AppColors.black,
                    iconBgColor: AppColors.bottomColor,
                    borderColor: Colors.grey,
                    onTap: () {
                      context.pushNamed(
                          RoutePath.paymentOption,extra: userRole
                      );
                      debugPrint("Silver plan selected");
                    },
                    planName: 'Silver',
                  ),
                  SizedBox(height: 12.h),
                  CustomSubscriptionCard(
                    planName: "Gold",
                    price: "£34.99",
                    features: controller.paymentConditions,
                    iconAsset: Assets.images.gold.path,
                    cardColor: AppColors.secondary,
                    textColor: AppColors.white50,
                    iconBgColor: AppColors.bottomColor,
                    borderColor: AppColors.gray500,
                    onTap: () {
                      debugPrint("Gold plan selected");
                    },

                  ),
                  SizedBox(height: 12.h),
                  CustomSubscriptionCard(
                    planName: "Diamond",
                    price: "€ 49.99",
                    features:controller.paymentConditions,
                    iconAsset: Assets.images.diamond.path,
                    cardColor: Colors.white,
                    textColor: AppColors.black,
                    iconBgColor: AppColors.bottomColor,
                    borderColor: AppColors.secondary,
                    onTap: () {
                      debugPrint("Diamond plan selected");
                    },

                  ),
                ],
              ),
            )),
      ),
    );
  }
}
