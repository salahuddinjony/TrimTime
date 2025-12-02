import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/common_profile_card/common_follow_msg_button.dart/custom_booking_button.dart';
import 'package:barber_time/app/view/common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import 'package:barber_time/app/view/common_widgets/custom_text_field/custom_text_field.dart';
import 'package:barber_time/app/view/common_widgets/show_custom_snackbar/show_custom_snackbar.dart';
import 'package:barber_time/app/view/screens/common_screen/shop_profile/widgets/services_card.dart';
import 'package:barber_time/app/view/screens/owner/owner_home/inner_widgets/monitization_date_picar.dart';
import 'package:barber_time/app/view/screens/user/home/controller/user_home_controller.dart';
import 'package:barber_time/app/view/screens/user/home/create_booking/widgets/barber_card.dart';
import 'package:barber_time/app/view/screens/user/home/create_booking/widgets/time_slot.dart';
import 'package:barber_time/app/view/screens/user/home/create_booking/widgets/time_picker_dialog.dart' as custom;
import 'package:flutter/material.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' as intl;
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SeloonBookingScreen extends StatelessWidget {
  final String userId;
  final UserRole userRole;
  final UserHomeController controller;
  final String seloonName;
  final String seloonImage;
  final String seloonAddress;

  SeloonBookingScreen(
      {super.key,
      required this.userId,
      required this.userRole,
      required this.controller, required this.seloonName, required this.seloonImage, required this.seloonAddress});

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
                    text: "Select Date",
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
                  Obx(() {
                    return CustomText(
                      text:
                          "${controller.selectedBarberId.value.isNotEmpty ? "Selected Barber (1)" : 'Select Barber '}",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    );
                  }),
                  SizedBox(height: 12.h),
                  Obx(() {
                    return controller.getBarberDatewiseStatus.value.isLoading
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.orange500,
                              ),
                            ),
                          )
                        : controller.barberDatewiseBookings.value != null &&
                                controller.barberDatewiseBookings.value!.barbers
                                    .isNotEmpty
                            ? SizedBox(
                                height:
                                    controller.selectedBarberId.value.isNotEmpty
                                        ? 115.h 
                                        : 95.h,
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: controller.barberDatewiseBookings
                                      .value!.barbers.length,
                                  itemBuilder: (context, index) {
                                    final barber = controller
                                        .barberDatewiseBookings
                                        .value!
                                        .barbers[index];
                                    return Obx(() {
                                      return barberTile(
                                          name: barber.name,
                                          imagePath: barber.image,
                                          isSelected:
                                              controller.selectedBarberId ==
                                                  barber.barberId,
                                          onTap: () {
                                            controller.selectedBarberId.value =
                                                barber.barberId;
                                            controller.getFreeSlots(
                                                barberId: controller
                                                    .selectedBarberId.value,
                                                saloonId: userId,
                                                date: intl.DateFormat(
                                                        'yyyy-MM-dd')
                                                    .format(controller
                                                        .selectedDate));
                                          });
                                    });
                                  },
                                  separatorBuilder: (context, index) =>
                                      SizedBox(height: 10.h),
                                ),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Center(
                                  child: CustomText(
                                    text: controller
                                            .noBarbersMessage.value.isNotEmpty
                                        ? controller.noBarbersMessage.value
                                        : "No barbers available.",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.gray500,
                                  ),
                                ),
                              );
                  }),
                  SizedBox(height: 12.h),
                  Obx(() {
                    return CustomText(
                      text:
                          "${controller.selectedBarberId.value.isNotEmpty ? "Available Time Slots" : 'Available Time Slots'}",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    );
                  }),
                  SizedBox(height: 12.h),
                  Obx(
                    () {
                      final freeSlots = controller.seletedBarberFreeSlots;

                      return controller
                              .selectedBarberFreeSlotsStatus.value.isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: AppColors.orange500,
                              ),
                            )
                          : freeSlots.isEmpty
                              ? Center(
                                  child: CustomText(
                                    text: controller
                                            .selectedBarberId.value.isNotEmpty
                                        ? "No free slots available."
                                        : "Please select a barber first.",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.gray500,
                                  ),
                                )
                              : SizedBox(
                                  height: controller
                                          .selectedTimeSlotId.value.isNotEmpty
                                      ? 95.h
                                      : 70.h,
                                  child: ListView.separated(
                                    itemCount: freeSlots.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      final slot = freeSlots[index];
                                      return GestureDetector(
                                        onTap: () {
                                          // Check if services are selected
                                          if (controller.selectedServicesIds.isEmpty) {
                                            EasyLoading.showInfo("Please select at least one service");
                                            // showCustomSnackBar("Please select at least one service", isError: true);
                                            // toastMessage(message: "Please select at least one service first");
                                            return;
                                          }

                                          // Calculate total duration
                                          final totalDuration = controller.getTotalDurationOfSelectedServices();

                                          // Show time picker bottom sheet
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            builder: (context) => custom.TimePickerDialog(
                                              slotStartTime: slot.start,
                                              slotEndTime: slot.end,
                                              totalServiceDuration: totalDuration,
                                              initialSelectedTime: controller.selectedTimeSlotId.value == slot.hashCode.toString()
                                                  ? controller.selectedTimeSlot.value
                                                  : null,
                                              onTimeSelected: (selectedTime) {
                                                debugPrint("Custom time selected: $selectedTime");
                                                controller.selectedTimeSlot.value = selectedTime;
                                                controller.selectedTimeSlotId.value = slot.hashCode.toString();
                                              },
                                            ),
                                          );
                                        },
                                        child: Obx(() {
                                          final isSelected = controller.selectedTimeSlotId.value == slot.hashCode.toString();
                                          // Show custom time if selected, otherwise show slot times
                                          final displayStartTime = isSelected && controller.selectedTimeSlot.value.isNotEmpty
                                              ? controller.selectedTimeSlot.value
                                              : slot.start;
                                          
                                          // Calculate end time based on selected start time and service duration
                                          final displayEndTime = isSelected && controller.selectedTimeSlot.value.isNotEmpty
                                              ? controller.endTimeSlot(controller.selectedTimeSlot.value)
                                              : slot.end;
                                          
                                          return timeSlotCard(
                                            startTime: displayStartTime,
                                            endTime: displayEndTime,
                                            isSelected: isSelected,
                                          );
                                        }),
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        SizedBox(height: 10.h),
                                  ),
                                );
                    },
                  ),
                  SizedBox(height: 15.h),
                  CustomText(
                    text: "Additional Notes",
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                  SizedBox(height: 12.h),
                  CustomTextField(
                    hintText: "Additional Notes",
                    maxLines: 2,
                    isColor: true,
                    textEditingController: controller.bookingNotesController,
                  ),
                  SizedBox(height: 30.h),
                  CustomBookingButton(
                    text: "Confirm Booking",
                    onTap: () async {
                        // Using GoRouter for pushing a route
                  if(controller.isAllFilled())  context.pushNamed(
                      RoutePath.summeryScreen,
                      extra: {
                        'seloonOwnerId': userId,
                        'userRole': userRole,
                        'controller': controller,
                        'seloonName': seloonName,
                        'seloonImage': seloonImage,
                        'seloonAddress': seloonAddress,
                      },
                      );


                      // if (controller.isAllFilled()) {
                      //   final result = await controller.createSelonBooking(
                      //       saloonOwnerId: userId);
                      //   if (result) {
                      //     controller.seletedBarberFreeSlots.clear();
                      //     controller.seletedBarberFreeSlots.refresh();
                      //     controller.clearControllers();
                      //     AppRouter.route.pop();
                      //   }
                      // }
                    },
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
