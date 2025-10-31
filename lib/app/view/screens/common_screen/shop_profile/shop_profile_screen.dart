import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/common_profile_total_card/common_profile_total_card.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/controller/barber_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';

class ShopProfileScreen extends StatelessWidget {
  ShopProfileScreen({super.key});

  final controller = Get.find<BarberHomeController>();

  @override
  Widget build(BuildContext context) {
    final userRole = GoRouter.of(context).state.extra as UserRole?;

    debugPrint("===================${userRole?.name}");
    if (userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }
    return Obx(() {
  final selonData = controller.selonList.value;

      // Only update isFollowing after a successful fetch, not on every rebuild or button click
      if (controller.getSelonStatus.value.isSuccess &&
          controller.selonList.value != null &&
          controller.getSelonStatus.value == RxStatus.success() &&
          ModalRoute.of(context)?.isCurrent == true) {
        controller.isFollowing.value = controller.selonList.value!.isFollowing;
      }


      final isLoading = controller.getSelonStatus.value.isLoading;
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: const CustomAppBar(
          appBarBgColor: AppColors.searchScreenBg,
          appBarContent: "Shop Profile",
          iconData: Icons.arrow_back,
        ),
        body: ClipPath(
          clipper: CurvedBannerClipper(),
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.searchScreenBg,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 60),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: .1),
                                blurRadius: 8,
                                spreadRadius: 2,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 50.h),
                              isLoading
                                  ? Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        width: 120,
                                        height: 22,
                                        color: Colors.white,
                                      ),
                                    )
                                  : CustomText(
                                      text:
                                          selonData?.shopName ?? "No Shop Data",
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.black,
                                    ),
                              const SizedBox(height: 10),
                              isLoading
                                  ? Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        width: 80,
                                        height: 20,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        _customButton(
                                            controller.isFollowing.value
                                                ? "Unfollow"
                                                : "Follow",
                                            controller.isFollowing.value
                                                ? Icons.person_remove
                                                : Icons.person_add,
                                            controller,
                                            controller.isFollowing.value,
                                            selonData?.userId ?? ""),
                                        const SizedBox(width: 10),
                                        _iconButton(
                                            Assets.images.chartSelected.image(
                                          color: Colors.white,
                                          height: 15,
                                        )),
                                      ],
                                    ),
                              const SizedBox(height: 20),
                              isLoading
                                  ? Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        width: double.infinity,
                                        height: 40,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      child: CustomText(
                                        maxLines: 20,
                                        text:
                                            "Great haircuts aren't just a service; they're an experience! With 10 years in the game, I specialize in fades, tapers, and beard perfection.",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.black,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                              SizedBox(height: 15.h),
                              isLoading
                                  ? Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        width: 120,
                                        height: 18,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: AppColors.orange500,
                                          size: 14,
                                        ),
                                        CustomText(
                                          left: 5,
                                          text: selonData?.shopAddress ??
                                              "No Location",
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.gray500,
                                        ),
                                      ],
                                    ),
                              SizedBox(height: 15.h),
                              isLoading
                                  ? Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        width: 100,
                                        height: 30,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            AppRouter.route.pushNamed(
                                                RoutePath.mapViewScreen,
                                                extra: userRole);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(5.r),
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(7)),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.location_on,
                                                  color: Colors.white,
                                                  size: 10,
                                                ),
                                                CustomText(
                                                  left: 5,
                                                  text: "View",
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors.whiteColor,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                        GestureDetector(
                                          onTap: () {
                                            _showInformationDialog(context);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(5.r),
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(7)),
                                            child: Row(
                                              children: [
                                                CustomText(
                                                  left: 5,
                                                  text: "More Info",
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors.whiteColor,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 0,
                          child: isLoading
                              ? Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                )
                              : CustomNetworkImage(
                                  imageUrl: AppConstants.shop,
                                  height: 100,
                                  width: 100,
                                  boxShape: BoxShape.circle,
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    isLoading
                        ? Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                  3,
                                  (index) => Container(
                                        width: 80,
                                        height: 40,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        color: Colors.white,
                                      )),
                            ),
                          )
                        : const Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CommonProfileTotalCard(
                                  title: AppStrings.ratings, value: "290+"),
                              SizedBox(width: 8),
                              CommonProfileTotalCard(
                                  title: AppStrings.following, value: "150+"),
                              SizedBox(width: 8),
                              CommonProfileTotalCard(
                                  title: "Follower", value: "500+"),
                            ],
                          ),
                    isLoading
                        ? Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 120,
                              height: 24,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              color: Colors.white,
                            ),
                          )
                        : const CustomText(
                            top: 10,
                            bottom: 8,
                            text: "All Barbers",
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          ),
                    isLoading
                        ? Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Row(
                              children: List.generate(
                                  4,
                                  (index) => Container(
                                        width: 58,
                                        height: 58,
                                        margin: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      )),
                            ),
                          )
                        : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(4, (index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      CustomNetworkImage(
                                          imageUrl: AppConstants.demoImage,
                                          height: 58.h,
                                          boxShape: BoxShape.circle,
                                          width: 58.h),
                                      const CustomText(
                                        text: "Jacob Jones",
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.black,
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ),
                    const SizedBox(height: 10),
                    isLoading
                        ? Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 120,
                              height: 24,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              color: Colors.white,
                            ),
                          )
                        : const CustomText(
                            top: 10,
                            text: 'Gallery',
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.gray500,
                            bottom: 10,
                          ),
                    isLoading
                        ? Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 96,
                              height: 78,
                              color: Colors.white,
                            ),
                          )
                        : CustomNetworkImage(
                            imageUrl: AppConstants.demoImage,
                            height: 78,
                            width: 96),
                    const SizedBox(height: 20),
                    isLoading
                        ? Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2,
                              height: 40,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              color: Colors.white,
                            ),
                          )
                        : Center(
                            child: CustomButton(
                              width: MediaQuery.of(context).size.width / 2,
                              fillColor: AppColors.last,
                              borderColor: Colors.white,
                              textColor: Colors.white,
                              onTap: () {
                                _showRatingDialog(context);
                              },
                              title: AppStrings.addReview,
                            ),
                          ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  void _showInformationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.white50,
          title: CustomText(
            text: "Information",
            fontSize: 20.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.black,
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.person,
                    color: AppColors.orange500,
                  ),
                  const SizedBox(width: 8),
                  CustomText(
                    text: "James Tracy",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w300,
                    color: AppColors.black,
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  const Icon(
                    Icons.cake,
                    color: AppColors.orange500,
                  ),
                  const SizedBox(width: 8),
                  CustomText(
                    text: "22-03-1998",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w300,
                    color: AppColors.black,
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  const Icon(
                    Icons.email,
                    color: AppColors.orange500,
                  ),
                  const SizedBox(width: 8),
                  CustomText(
                    text: "James@gmail.com",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w300,
                    color: AppColors.black,
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  const Icon(
                    Icons.phone,
                    color: AppColors.orange500,
                  ),
                  const SizedBox(width: 8),
                  CustomText(
                    text: "+44 26537 26347",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w300,
                    color: AppColors.black,
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: AppColors.orange500,
                  ),
                  const SizedBox(width: 8),
                  CustomText(
                    text: "Abu Dhabi",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w300,
                    color: AppColors.black,
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.orange.shade50,
          title: Column(
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.orange,
                size: 40,
              ),
              const Text(
                "Give rating out of 5!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10.h),
              RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemSize: 30,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  print("Rating: $rating");
                },
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  print("Add picture clicked");
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.add,
                      size: 30,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Write your feedback',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                print("Rating submitted");
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Widget _customButton(String text, IconData icon,
      BarberHomeController controller, bool isFollowing, String userId) {
    return GestureDetector(
      onTap: () {
        controller.toggleFollow(userId: userId);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: Colors.white),
            const SizedBox(width: 6),
            CustomText(
              text: text,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconButton(Widget icon) {
    return GestureDetector(
      onTap: () {
        AppRouter.route.pushNamed(RoutePath.chatScreen);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: icon,
      ),
    );
  }
}
