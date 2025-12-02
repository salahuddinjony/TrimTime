import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/screens/owner/owner_home/inner_widgets/monitization_date_picar.dart';
import 'package:barber_time/app/view/screens/user/home/controller/user_home_controller.dart';
import 'package:barber_time/app/view/screens/user/home/create_booking/widgets/barber_card.dart';
import 'package:barber_time/app/view/screens/user/home/create_booking/widgets/time_slot.dart';
import 'package:barber_time/app/view/screens/user/home/create_booking/widgets/time_picker_dialog.dart'
    as custom;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' as intl;

class RescheduleScreen extends StatelessWidget {
  final UserRole userRole;
  final UserHomeController controller;
  final String userId;
  final String bookingId;
  final List<String>? serviceNames;
  final List<int>? serviceDurations;
  const RescheduleScreen(
      {super.key,
      required this.userRole,
      required this.controller,
      required this.userId,
      required this.bookingId,
      this.serviceNames,
      this.serviceDurations});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        appBarContent: "Reschedule",
        iconData: Icons.arrow_back,
        appBarBgColor: AppColors.searchScreenBg,
      ),
      body: Stack(
        children: [
          // Curved banner background
          ClipPath(
            clipper: CurvedBannerClipper(),
            child: Container(
              height: 700.h,
              decoration: const BoxDecoration(
                color: AppColors.searchScreenBg,
              ),
            ),
          ),
          // Content on top
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date Selection Row

                // Grid of Dates
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
                                                  .format(
                                                      controller.selectedDate));
                                        });
                                  });
                                },
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: 10.h),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
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
                                        // Calculate total duration from booking services
                                        int totalDuration = 0;
                                        if (serviceDurations != null &&
                                            serviceDurations!.isNotEmpty) {
                                          totalDuration = serviceDurations!
                                              .fold<int>(
                                                  0,
                                                  (sum, duration) =>
                                                      sum + duration);
                                        } else if (controller
                                            .selectedServicesIds.isNotEmpty) {
                                          totalDuration = controller
                                              .getTotalDurationOfSelectedServices();
                                        } else {
                                          EasyLoading.showInfo(
                                              "No services found for this booking");
                                          return;
                                        }

                                        // Show time picker bottom sheet
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (context) =>
                                              custom.TimePickerDialog(
                                            slotStartTime: slot.start,
                                            slotEndTime: slot.end,
                                            totalServiceDuration: totalDuration,
                                            initialSelectedTime: controller
                                                        .selectedTimeSlotId
                                                        .value ==
                                                    slot.hashCode.toString()
                                                ? controller
                                                    .selectedTimeSlot.value
                                                : null,
                                            onTimeSelected: (selectedTime) {
                                              debugPrint(
                                                  "Custom time selected: $selectedTime");
                                              controller.selectedTimeSlot
                                                  .value = selectedTime;
                                              controller.selectedTimeSlotId
                                                      .value =
                                                  slot.hashCode.toString();
                                            },
                                          ),
                                        );
                                      },
                                      child: Obx(() {
                                        final isSelected = controller
                                                .selectedTimeSlotId.value ==
                                            slot.hashCode.toString();
                                        // Show custom time if selected, otherwise show slot times
                                        final displayStartTime = isSelected &&
                                                controller.selectedTimeSlot
                                                    .value.isNotEmpty
                                            ? controller.selectedTimeSlot.value
                                            : slot.start;

                                        // Calculate end time based on selected start time and service duration
                                        final displayEndTime = isSelected &&
                                                controller.selectedTimeSlot
                                                    .value.isNotEmpty
                                            ? controller.endTimeSlot(controller
                                                .selectedTimeSlot.value)
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
                                      SizedBox(width: 15.h),
                                ),
                              );
                  },
                ),
                SizedBox(height: 100.h),
                // Confirm button

                CustomButton(
                  onTap: () async {
                    if (controller.selectedTimeSlot.value.isEmpty) {
                      EasyLoading.showInfo("Please select a time slot");

                      return;
                    }
                    final success = await controller.rescheduleBooking(
                      bookingId: bookingId,
                      newDateTime: controller.selectedDate,
                      timeSlot: controller.selectedTimeSlot.value,
                    );

                    if (success) {
                      debugPrint("Reschedule failed");
                      context.pop();
                      context.pop();
                    }
                    // showSuccessDialog(context);
                  },
                  textColor: AppColors.white,
                  fillColor: AppColors.black,
                  title: "Request for Reschedule",
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
