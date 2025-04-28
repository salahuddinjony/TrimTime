import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_from_card/custom_from_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BusinessProfileEdit extends StatelessWidget {
  const BusinessProfileEdit({super.key});

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
      //==================✅✅Header✅✅===================
      appBar: const CustomAppBar(
        appBarBgColor: AppColors.linearFirst,
        appBarContent: "Shop Edit Profile",
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            CustomFromCard(
                title: AppStrings.shopName,
                controller: TextEditingController(),
                validator: (v) {}),
            CustomFromCard(
                title: "Barber Shop business Bio",
                maxLine: 5,
                controller: TextEditingController(),
                validator: (v) {}),
            CustomButton(
              onTap: () {
                context.pop();
              },
              fillColor: AppColors.black,
              textColor: AppColors.whiteColor,
              title: AppStrings.save,
            )
          ],
        ),
      ),
    );
  }
}
