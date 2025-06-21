import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/common_profile_total_card/common_profile_total_card.dart';
import 'package:flutter/material.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../common_widgets/common_profile_card/common_profile_card.dart';
import '../../../../common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';

class BusinessProfile extends StatelessWidget {
  const BusinessProfile({super.key});

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
          appBarContent: "Shop Profile",
          iconData: Icons.arrow_back,
        ),
        body: ClipPath(
            clipper: CurvedBannerClipper(),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 1.3,
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
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonProfileCard(
                        name: "Christian Ronaldo",
                        bio:
                            "Great haircuts aren’t just a service; they’re an experience! With 10 years in the game, I specialize in fades, tapers, and beard perfection.",
                        imageUrl: AppConstants.demoImage,
                        onEditTap: () {
                          AppRouter.route.pushNamed(
                            RoutePath.businessProfileEdit,
                            extra: userRole,
                          );
                        },
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              //==================✅✅Total Card✅✅===================
                              const Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CommonProfileTotalCard(
                                      title: AppStrings.ratings, value: "290+"),
                                  SizedBox(width: 8),
                                  CommonProfileTotalCard(
                                      title: AppStrings.following,
                                      value: "150+"),
                                  SizedBox(width: 8),
                                  CommonProfileTotalCard(
                                      title: "Follower", value: "500+"),
                                ],
                              ),
                              SizedBox(
                                height: 14.h,
                              ),
                              Row(
                                children: [
                                  const CustomText(
                                    text: 'All Barber',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.black,
                                    bottom: 10,
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: (){
                                      AppRouter.route.pushNamed(
                                          RoutePath.barberAddedScreen,
                                          extra: userRole);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(8.r),
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle),
                                      child: const Icon(
                                        Icons.edit,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      AppRouter.route.pushNamed(
                                          RoutePath.barberAddedScreen,
                                          extra: userRole);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(8.r),
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle),
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 14.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: List.generate(4, (index) {
                                  return Column(
                                    children: [
                                      CustomNetworkImage(
                                        imageUrl: AppConstants.demoImage,
                                        height: 70,
                                        width: 70,
                                        boxShape: BoxShape.circle,
                                      ),
                                      const CustomText(
                                        text: 'Jons',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.black,
                                        bottom: 10,
                                      ),
                                    ],
                                  );
                                }),
                              ),

                              const CustomText(
                                top: 18,
                                text: 'Photo Gallery',
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white50,
                                bottom: 10,
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomNetworkImage(
                                      imageUrl: AppConstants.demoImage,
                                      height: 78,
                                      width: 96),
                                  CustomNetworkImage(
                                      imageUrl: AppConstants.demoImage,
                                      height: 78,
                                      width: 96),
                                  CustomNetworkImage(
                                      imageUrl: AppConstants.demoImage,
                                      height: 78,
                                      width: 96),
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomNetworkImage(
                                      imageUrl: AppConstants.demoImage,
                                      height: 78,
                                      width: 96),
                                  CustomNetworkImage(
                                      imageUrl: AppConstants.demoImage,
                                      height: 78,
                                      width: 96),
                                  CustomNetworkImage(
                                      imageUrl: AppConstants.demoImage,
                                      height: 78,
                                      width: 96),
                                ],
                              ),

                              CustomText(
                                top: 10,
                                text: "All Service",
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),

                              CustomText(
                                top: 10,
                                text: "Hair Cut",
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                              ),
                              CustomText(
                                top: 10,
                                text: "Shaving",
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }
}
