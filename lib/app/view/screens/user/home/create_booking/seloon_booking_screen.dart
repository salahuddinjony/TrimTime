import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/view/common_widgets/common_profile_card/common_follow_msg_button.dart/custom_booking_button.dart';
import 'package:barber_time/app/view/common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import 'package:barber_time/app/view/common_widgets/custom_text_field/custom_text_field.dart';
import 'package:barber_time/app/view/screens/common_screen/shop_profile/widgets/services_card.dart';
import 'package:barber_time/app/view/screens/owner/owner_home/inner_widgets/monitization_date_picar.dart';
import 'package:barber_time/app/view/screens/user/home/controller/user_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:barber_time/app/global/helper/extension/extension.dart'
    show SafeCap;

class SeloonBookingScreen extends StatelessWidget {
  final String userId;
  final UserRole userRole;
  final UserHomeController controller;

  SeloonBookingScreen(
      {super.key,
      required this.userId,
      required this.userRole,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarBgColor: AppColors.searchScreenBg,
        appBarContent: "Booking",
        iconData: Icons.arrow_back,
        onTap: () {
          AppRouter.route.pop();
        },
      ),
      body: ClipPath(
        clipper: CurvedBannerClipper(),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.searchScreenBg,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => CustomText(
                      text:
                          "Select Services ${controller.selectedServicesIds.length > 0 ? '(${controller.selectedServicesIds.length.toString().padLeft(2, '0')})' : ''}",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Obx(() {
                    final isLoading =
                        controller.getSelonServicesStatus.value.isLoading;
                    final servicesData = controller.selonServicesList;
                    if (isLoading) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                                2,
                                (index) => Container(
                                      width: 200,
                                      height: 120,
                                      margin: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    )),
                          ),
                        ),
                      );
                    } else if (servicesData.isEmpty == true) {
                      return Container(
                        child: CustomText(
                          text: "No services available.",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.gray500,
                        ),
                      );
                    } else {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(servicesData.length, (index) {
                            final service = servicesData[index];
                            return GestureDetector(
                              onTap: () {
                                controller.addOrRemoveServiceId(service.id);
                              },
                              child: ServicesCard(
                                isSelected: controller.selectedServicesIds
                                    .contains(service.id),
                                serviceName: service.name,
                                price: service.price.toDouble(),
                                duration: service.duration,
                                isActive: true,
                              ),
                            );
                          }),
                        ),
                      );
                    }
                  }),
                  SizedBox(height: 20.h),
                  CustomText(
                    text: "Select Date & Time",
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                  SizedBox(height: 12.h),
                  HorizontalDatePicker<UserHomeController>(
                    userRole: userRole,
                    controller: controller,
                    seloonId: userId,
                  ),


                  SizedBox(height: 12.h),
                  CustomText(
                    text: "Select Barber",
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                  controller.getBarberDatewiseStatus.value.isLoading
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.orange500,
                            ),
                          ),
                        )
                      : controller
                              .barberDatewiseBookings.value != null
                          ? Column(
                              children: controller.barberDatewiseBookings.value!.barbers
                                  .map((barber) => ListTile(
                                        leading: CustomNetworkImage(
                                          imageUrl: barber.image
                                              ?? "",
                                          width: 50,
                                          height: 50,
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        title: CustomText(
                                          text: barber.name,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.black,
                                        ),
                                      
                                      ))
                                  .toList(),
                            )
                          : controller.getBarberDatewiseStatus.value.isSuccess? Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: CustomText(
                                  text: "No barbers available.",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.gray500,
                                ),
                              ),
                            ): SizedBox.shrink(),
                  SizedBox(height: 12.h),
                  CustomTextField(
                    hintText: "Additional Notes",
                    maxLines: 2,
                    isColor: true,
                    onTap: () {
                      // Implement date picker
                    },
                  ),
                  SizedBox(height: 30.h),
                  CustomBookingButton(
                    text: "Confirm Booking",
                    onTap: () {
                      debugPrint("Booking button tapped");
                    },
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
