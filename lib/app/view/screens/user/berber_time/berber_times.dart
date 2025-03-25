import 'package:barber_time/app/core/bottom_navbar.dart';
import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
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

class BerberTimes extends StatelessWidget {
  const BerberTimes({super.key});

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
        bottomNavigationBar: BottomNavbar(currentIndex: 1, role: userRole),
        backgroundColor: AppColors.linearFirst,
        appBar: const CustomAppBar(
          appBarContent: AppStrings.barbersTime,
          appBarBgColor: AppColors.linearFirst,
        ),
        body: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomNetworkImage(
                    imageUrl: AppConstants.shop, height: 184, width: 379),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CustomText(
                            top: 10,
                            text: "Barber time",
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: AppColors.gray500,
                          ),
                          const Spacer(),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                color: AppColors.black,
                                borderRadius:
                                BorderRadius.all(Radius.circular(14))),
                            child: Row(
                              children: [
                                Assets.icons.liveLocation.svg(),
                                const CustomText(
                                  left: 10,
                                  text: AppStrings.liveLocation,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                  color: AppColors.white50,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Row(
                            children: List.generate(5, (index) {
                              return const Icon(
                                Icons.star,
                                color: Colors.black,
                                size: 16,
                              );
                            }),
                          ),
                          const CustomText(
                            text: "(550)",
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                            color: AppColors.gray500,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Row(
                        children: [
                          Icon(
                            Icons.place,
                            color: Colors.black,
                            size: 21,
                          ),
                          CustomText(
                            left: 10,
                            text: "Oldesloer Strasse 82",
                            fontWeight: FontWeight.w500,
                            fontSize: 21,
                            color: AppColors.gray500,
                          ),
                        ],
                      ),
                      const CustomText(
                        top: 16,
                        text: AppStrings.availableBarber,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: AppColors.gray500,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 300, // প্রয়োজন অনুযায়ী ঠিক করো
                        child: GridView.builder(
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 1,
                          ),
                          itemCount: 10,
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
                              ],
                            );
                          },
                        ),
                      ),
                      CustomButton(
                        onTap: () {},
                        fillColor: AppColors.black,
                        title: AppStrings.add,
                        textColor: Colors.white,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      CustomButton(
                        onTap: () {},
                        fillColor: Colors.white,
                        borderColor: AppColors.orange700,
                        title: AppStrings.addReview,
                        textColor: Colors.orange,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ));
  }
}
