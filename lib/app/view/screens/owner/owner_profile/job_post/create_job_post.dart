import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_from_card/custom_from_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CreateJobPost extends StatelessWidget {
  const CreateJobPost({
    super.key,
  });

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
      appBar: const CustomAppBar(
        appBarContent: AppStrings.jobPost,
        iconData: Icons.arrow_back,
        appBarBgColor: AppColors.linearFirst,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomFromCard(
                  suffixIcon: const Icon(Icons.calendar_month),
                  title: 'Date',
                  controller: TextEditingController(text: 'MM/DD/YY'),
                  validator: (v) {}),
              Row(
                children: [
                  Expanded(
                    child: CustomFromCard(
                        suffixIcon: const Icon(Icons.calendar_month),
                        title: 'Start time',
                        controller: TextEditingController(text: ''),
                        validator: (v) {}),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: CustomFromCard(
                        suffixIcon: const Icon(Icons.calendar_month),
                        title: 'End time',
                        controller: TextEditingController(text: ''),
                        validator: (v) {}),
                  ),
                ],
              ),
              CustomFromCard(
                  title: 'Rate(hourly)',
                  hinText: "Enter rate",
                  controller: TextEditingController(),
                  validator: (v) {}),

              CustomFromCard(
                  title: AppStrings.shopName,
                  hinText: AppStrings.name,
                  controller: TextEditingController(),
                  validator: (v) {}),

              CustomFromCard(
                  suffixIcon: const Icon(Icons.camera),
                  title: "Add shop logo",
                  hinText:"Upload your logo",
                  controller: TextEditingController(),
                  validator: (v) {}),

              CustomFromCard(
                  title: AppStrings.description,
                  hinText: AppStrings.description,
                  controller: TextEditingController(),
                  validator: (v) {}),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: CustomButton(
          textColor: AppColors.white50,
          fillColor: AppColors.black,
          onTap: () {
            context.pop();
          },
          title: AppStrings.save,
        ),
      ),

      ///============================ body ===============================
    );
  }
}
