import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/common_widgets/custom_tip_card/custom_tip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userRole = GoRouter.of(context).state.extra as UserRole?;

    if (userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.linearFirst,
      appBar: const CustomAppBar(
        appBarContent: "Tip",
        appBarBgColor: AppColors.linearFirst,
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// All Barbers title
            CustomText(
              text: "All Barbers",
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.gray500,
            ),

            SizedBox(height: 20.h),

            /// Barber Grid
            SizedBox(
              height: 300.h,
              child: Expanded(
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Adjusted for better look
                    crossAxisSpacing: 0.w,
                    mainAxisSpacing: 15.h,
                    childAspectRatio: 1.9, // Perfect height/width
                  ),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return CustomTipCard(
                      imageUrl: AppConstants.demoImage,
                      name: "Barber $index",
                      onSendTip: () {
                        debugPrint('Tip sent for Barber $index!');
                      },
                    );
                  },
                ),
              ),
            ),

            SizedBox(height: 20.h),
            CustomText(
              text: "Service Charge:",
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.gray500,
            ),
            SizedBox(height: 100.h),

            /// Submit Button
            CustomButton(
              onTap: () {
                AppRouter.route.pushNamed(
                  RoutePath.paymentOption,
                  extra: userRole,
                );
              },
              title: AppStrings.submit,
              fillColor: Colors.black,
              textColor: AppColors.whiteColor,
              height: 50.h,
            ),
          ],
        ),
      ),
    );
  }
}
