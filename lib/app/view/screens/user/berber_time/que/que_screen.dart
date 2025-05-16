import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/route_path.dart';
import '../../../../../core/routes.dart';
import '../berber_times.dart';

class QueScreen extends StatelessWidget {
  const QueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final extra = GoRouter.of(context).state.extra;

    UserRole? userRole;
    String? statusString;

    if (extra is List && extra.length == 2) {
      // Try casting safely
      if (extra[0] is UserRole) {
        userRole = extra[0] as UserRole;
      }
      if (extra[1] is String) {
        statusString = extra[1] as String;
      }
    }

    // Fallback if you want to support single-type extras too (optional)
    else if (extra is UserRole) {
      userRole = extra;
    } else if (extra is String) {
      statusString = extra;
    }

    if (userRole == null && statusString == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No valid extra received')),
      );
    }

    return Scaffold(
        backgroundColor: AppColors.linearFirst,
        appBar: const CustomAppBar(
          iconData: Icons.arrow_back,
          appBarContent: AppStrings.que,
          appBarBgColor: AppColors.linearFirst,
        ),
        body: ListView(
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(
                    top: 60,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.navColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.1),
                        blurRadius: 8,
                        spreadRadius: 2,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: CustomNetworkImage(
                      imageUrl: AppConstants.shop,
                      height: 184,
                      width: double.infinity),
                ),
                Positioned(
                  top: 0,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      //==================✅✅Image✅✅===================
                      CustomNetworkImage(
                        imageUrl: AppConstants.demoImage,
                        height: 100,
                        width: 100,
                        boxShape: BoxShape.circle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        CustomText(
                          top: 16,
                          text: "Jane Cooper",
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                          color: AppColors.gray500,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (userRole != null) {
                              AppRouter.route.pushNamed(RoutePath.visitShop,
                                  extra: userRole);
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                color: AppColors.black,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: const CustomText(
                              text: AppStrings.seeProfile,
                              fontWeight: FontWeight.w500,
                              fontSize: 11,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const CustomText(
                    top: 16,
                    text: "Ongoing Customer",
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: AppColors.gray500,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 200,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 1,
                      ),
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomNetworkImage(
                              boxShape: BoxShape.circle,
                              imageUrl: AppConstants.demoImage,
                              height: 62,
                              width: 62,
                            ),
                            const SizedBox(height: 8),
                            const CustomText(
                              text: "Jane Cooper",
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: AppColors.gray500,
                            ),
                            const SizedBox(height: 8),
                            const CustomText(
                              text: "40 min",
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: AppColors.gray500,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 100.h,
                  ),
                  Center(
                    child: const CustomText(
                      textAlign: TextAlign.center,
                      text: "Estimated Waiting Time 40min",
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: AppColors.gray500,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  CustomButton(
                    onTap: () {
                      BerberTimes.showChooseBarberDialog(context);
                    },
                    fillColor: statusString == "IsQue"
                        ? AppColors.black
                        : AppColors.red,
                    title: statusString == "IsQue"
                        ? "Add to Queue"
                        : "Remove form Que",
                    textColor: Colors.white,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
