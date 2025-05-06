import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
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

            /// Barber Grid (Fixed height without Expanded)
            SizedBox(
              height: 300.h, // Fixed height for the GridView
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
                      _showTipDialog(context, TextEditingController());
                    },
                  );
                },
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

  // Function to show the Tip dialog
  void _showTipDialog(
      BuildContext context, TextEditingController tipController) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.white,
          title: Column(
            children: [
              Assets.images.hugeiconsTips.image(),
              const Text(
                "Give tips !",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Tips Amount Input
              const Text(
                "Tips amount",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: tipController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Enter tips amount",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            // Cancel Button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            // Submit Button
            TextButton(
              onPressed: () {
                String tipAmount = tipController.text;
                if (tipAmount.isNotEmpty) {
                  print("Tip amount: $tipAmount");
                  Navigator.of(context).pop();
                  // Add your logic to handle the tip submission
                } else {
                  // Handle case where the user hasn't entered a tip
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter a tip amount")),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
