import 'dart:convert';

import 'package:barber_time/app/global/helper/extension/extension.dart';
import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/controller/mixin/mixin_seloon_mng/mixin_selon_management.dart';
import 'package:barber_time/app/view/screens/owner/owner_home/controller/mixin/mixin_date_wise_bookings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

mixin MixinCreateBookingOrQueue on MixinSelonManagement, DateWiseBookingsMixin{
  Rx<RxStatus> createBookingStatus = Rx<RxStatus>(RxStatus.loading());
  final TextEditingController bookingNotesController = TextEditingController();
  RxString selectedBarberId = ''.obs;
  RxString selectedTimeSlot = ''.obs;
  RxString selectedTimeSlotId = ''.obs;

  String endTimeSlot(String startTime) {
    try {
      // Remove spaces and handle AM/PM
      String cleaned = startTime.replaceAll(' ', '');
      RegExp regex = RegExp(r'^(\d{1,2}):(\d{2})(AM|PM)?$', caseSensitive: false);
      final match = regex.firstMatch(cleaned);
      int hour, minute;
      if (match != null) {
        hour = int.parse(match.group(1)!);
        minute = int.parse(match.group(2)!);
        String? period = match.group(3)?.toUpperCase();
        if (period != null) {
          if (period == 'PM' && hour != 12) hour += 12;
          if (period == 'AM' && hour == 12) hour = 0;
        }
      } else {
        // fallback: try to parse as HH:mm
        final parts = cleaned.split(':');
        hour = int.parse(parts[0]);
        minute = int.parse(parts[1]);
      }

      minute += 45; // Adding 45 minutes
      if (minute >= 60) {
        minute -= 60;
        hour += 1;
      }
      if (hour >= 24) {
        hour -= 24;
      }

      String period = hour >= 12 ? 'PM' : 'AM';
      int displayHour = hour % 12 == 0 ? 12 : hour % 12;

      final endHourStr = displayHour.toString().padLeft(2, '0');
      final endMinuteStr = minute.toString().padLeft(2, '0');

      return '$endHourStr:$endMinuteStr $period';
    } catch (e) {
      debugPrint('Error calculating end time: $e, input: $startTime');
      return startTime; // Return start time in case of error
    }
  }
  
  bool isAllFilled() {
    if (selectedBarberId.value.isEmpty) {
      EasyLoading.showInfo("Please select a barber");
      debugPrint("Barber not selected");
      return false;
    }
    if (selectedTimeSlot.value.isEmpty) {
      EasyLoading.showInfo("Please select a time slot");
      debugPrint("Time slot not selected");
      return false;
    }
    if (selectedServicesIds.isEmpty) {
      EasyLoading.showInfo("Please select at least one service");
      debugPrint("No services selected");
      return false;
    }
    if (selectedDate.formatDateApi().isEmpty) {
      EasyLoading.showInfo("Please select a date");
      debugPrint("Date not selected");
      return false;
    }
    debugPrint("All fields are filled");
    debugPrint("Selected barber id: ${selectedBarberId.value}");
    debugPrint("Selected time slot: ${selectedTimeSlot.value}");
    debugPrint("Selected services ids: ${selectedServicesIds.toList()}");
    debugPrint("Selected time slot id: ${selectedTimeSlotId.value}");
    debugPrint("Selected date: ${selectedDate.formatDateApi()}");
    debugPrint("Selected booking notes: ${bookingNotesController.text}");
    return true;
  }
  clearControllers(){
    selectedBarberId.value = '';
    selectedTimeSlot.value = '';
    selectedTimeSlotId.value = '';
    bookingNotesController.text = '';
    selectedServicesIds.clear();
  }

  Future<bool> createSelonBooking({
    required String saloonOwnerId,
  }) async {
    try {
      final Map<String, dynamic> bookingData = {
        "barberId": selectedBarberId.value,
        "saloonOwnerId": saloonOwnerId,
        "appointmentAt": selectedTimeSlot.value,
        "date":  selectedDate.formatDateApi(),
        "services": selectedServicesIds.toList(),
        "notes": bookingNotesController.text,
        "type": "BOOKING" // BOOKING QUEUE
      };
      EasyLoading.show(status: "Creating booking... Please wait...");
      createBookingStatus.value = RxStatus.loading();

      final response = await ApiClient.postData(
        ApiUrl.createBookingForSelon,
        jsonEncode(bookingData),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        createBookingStatus.value = RxStatus.success();
        EasyLoading.showSuccess("Booking created successfully");
        return true;
      } else {
        EasyLoading.showError("Failed to create booking");
        createBookingStatus.value = RxStatus.error(
            "Failed to create booking: ${response.statusCode} - ${response.statusText}");
        return false;
      }
    } catch (e) {
      EasyLoading.showError("Error creating booking");
      debugPrint("Error creating booking: ${e.toString()}");
      createBookingStatus.value =
          RxStatus.error("Error creating booking: ${e.toString()}");
      return false;
    } finally {
      createBookingStatus.refresh();
      EasyLoading.dismiss();
    }
  }

  // create queue for selon

  // Future<bool> createSelonQueue(
  //     {required String userId,
  //     required String bookingDate,
  //     required String saloonOwnerId,
  //     required String barberId}) async {
  //   try {
  //     final Map<String, dynamic> queueData = {
  //       "barberId": barberId,
  //       "saloonOwnerId": saloonOwnerId,
  //       "appointmentAt": DateTime.now().toIso8601String(),
  //       "date": "2025-11-27",
  //       "services": selectedServicesIds.toList(),
  //       "notes": bookingNotesController.text,
  //       "type": "QUEUE" // QUEUE
  //     };
  //     createBookingStatus.value = RxStatus.loading();

  //     final response = await ApiClient.postData(
  //       ApiUrl.createBookingForSelon,
  //       jsonEncode(queueData),
  //     );
  //     if (response.statusCode == 200) {
  //       createBookingStatus.value = RxStatus.success();
  //       return true;
  //     } else {
  //       createBookingStatus.value = RxStatus.error(
  //           "Failed to create queue: ${response.statusCode} - ${response.statusText}");
  //       return false;
  //     }
  //   } catch (e) {
  //     debugPrint("Error creating queue: ${e.toString()}");
  //     createBookingStatus.value =
  //         RxStatus.error("Error creating queue: ${e.toString()}");
  //     return false;
  //   } finally {
  //     createBookingStatus.refresh();
  //   }
  // }
}
