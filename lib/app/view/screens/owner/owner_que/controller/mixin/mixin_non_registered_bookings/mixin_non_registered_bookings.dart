import 'dart:convert';

import 'package:barber_time/app/global/helper/extension/extension.dart';
import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

mixin MixinNonRegisteredBookings {
  Rx<RxStatus> nonRegisteredBookingStatus = Rx<RxStatus>(RxStatus.empty());
  Future<bool> registerNonRegisteredBookings(
      {required String fullName,
      required String email,
      required String barberId,
      required String appointmentAt,
      required List<String>? services,
      required String notes}) async {
    try {
      nonRegisteredBookingStatus.value = RxStatus.loading();
      EasyLoading.show(status: 'Creating booking...');
      final Map<String, dynamic> body = {
        "fullName": fullName,
        "email": email,
        "barberId": barberId,
        "bookingType": "QUEUE",
        "appointmentAt": appointmentAt,
        "date": DateTime.now().formatDateApi(),
        "services": services,
        "notes": notes
      };

      final response = await ApiClient.postData(
        ApiUrl.nonRegisteredBooking,
        jsonEncode(body),
      );
      if (response.statusCode == 200) {
        nonRegisteredBookingStatus.value = RxStatus.success();
        debugPrint('Non-registered booking successful: ${response.body}');
        EasyLoading.showSuccess('Booking created successfully');
        return true;
      } else {
        EasyLoading.showError('Failed to create booking');
        nonRegisteredBookingStatus.value = RxStatus.error(
            'Failed to create non-registered booking: ${response.statusCode}');
        debugPrint(
            'Failed to create non-registered booking: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      EasyLoading.showError('Error creating booking');
      nonRegisteredBookingStatus.value =
          RxStatus.error('Error in non-registered booking: $e');
      debugPrint('Error in fetchNonRegisteredBookings: $e');
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }
}
