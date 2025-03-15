import 'package:barber_time/app/core/bottom_navbar.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/common_widgets/custom_text_field/custom_text_field.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class BarberFeed extends StatelessWidget {
  const BarberFeed({
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
      bottomNavigationBar: BottomNavbar(
        currentIndex: 2,
        role: userRole,
      ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.linearFirst,
        title: const Text(AppStrings.addFeed),
      ),
      body: Column(
        children: [
          ClipPath(
            clipper: CurvedBannerClipper(),
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xCCEDC4AC), // First color (with opacity)
                    Color(0xFFE9874E),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CustomText(
                      text: AppStrings.choiceImage,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                      fontSize: 16,
                      bottom: 8,
                    ),
                    Row(
                      children: [
                        CustomNetworkImage(
                            imageUrl: AppConstants.demoImage,
                            height: 100,
                            width: 100),
                        SizedBox(
                          width: 10.w,
                        ),
                        DottedBorder(
                          padding: const EdgeInsets.all(25),
                          child: const Column(
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              CustomText(
                                text: AppStrings.upload,
                                fontWeight: FontWeight.w500,
                                color: AppColors.black,
                                fontSize: 16,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.w,
                    ),
                    const CustomText(
                      text: AppStrings.caption,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                      fontSize: 16,
                      bottom: 8,
                    ),
                    const CustomTextField(),
                    SizedBox(
                      height: 40.w,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
            child: CustomButton(
              title: AppStrings.post,
              textColor: AppColors.white50,
              onTap: () {

              },
              fillColor: AppColors.black,
            ),
          )
        ],
      ),
    );
  }
}
