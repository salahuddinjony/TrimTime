import 'package:barber_time/app/core/bottom_navbar.dart';
import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QueScreen extends StatelessWidget {
  const QueScreen({super.key});

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
      body: Column(
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
                          borderRadius: BorderRadius.all(Radius.circular(14))),
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
                const SizedBox(height: 10,),
                CustomNetworkImage(
                    boxShape: BoxShape.circle,
                    imageUrl: AppConstants.demoImage,
                    height: 62,
                    width: 62)
              ],
            ),
          )
        ],
      ),
    );
  }
}
