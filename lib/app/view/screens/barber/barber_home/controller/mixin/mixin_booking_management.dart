import 'dart:convert';

import 'package:barber_time/app/global/helper/extension/extension.dart';
import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/models/barber_booking/barber_booking_model.dart';
import 'package:barber_time/app/view/screens/user/bookings/models/customer_bookins_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

mixin BookingManagementMixin {
  RxList<BarberBookingData> bookings = RxList<BarberBookingData>([]);
  Rx<RxStatus> bookingStatus = Rx<RxStatus>(RxStatus.empty());

  // Get status badge color
  Color getStatusColor(String status) {
    switch (status) {
      case 'CONFIRMED':
        return Colors.green;
      case 'PENDING':
        return Colors.orange;
      case 'COMPLETED':
        return Colors.blue;
      case 'STARTED':
        return Colors.purpleAccent;
      case 'ENDED':
        return Colors.cyan;
      case 'CANCELLED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> fetchBookings() async {
    try {
      bookingStatus.value = RxStatus.loading();
      final response = await ApiClient.getData(
        ApiUrl.getBarberBookings,
      );
      if (response.statusCode == 200) {
        final responseData = response.body;
        // Parse the response using the model
        final barberBookingResponse =
            BarberBookingResponse.fromJson(responseData);
        bookings.value = barberBookingResponse.data;
        bookingStatus.value = RxStatus.success();
      } else {
        bookingStatus.value = RxStatus.error(
            "Failed to fetch bookings: ${response.statusCode} - ${response.statusText}");
      }
    } catch (e) {
      bookingStatus.value = RxStatus.error(e.toString());
    }
  }

  RxList<CustomerBooking> customerBookingList = RxList<CustomerBooking>([]);
  Rx<RxStatus> customerBookingStatus = Rx<RxStatus>(RxStatus.empty());

  Future<void> fetchCustomerBookings(
      {bool? isDateWise = false, String? bookingType}) async {
    try {
      customerBookingStatus.value = RxStatus.loading();
      // Note: limit is an integer here, but will be converted to string in URL query params
      // Backend should parse the string query parameter to integer before passing to Prisma
      final Map<String, dynamic> query = {
        "limit": "200",
      };
      if (isDateWise == true) {
        query['date'] = DateTime.now().formatDateApi();
      }
      if (bookingType != null) {
        query['type'] = bookingType.toUpperCase();
      }
      final response = await ApiClient.getData(
        ApiUrl.getCustomerBookings,
        query: query,
      );
      if (response.statusCode == 200) {
        try {
          // Ensure response.body is a Map, if it's a String, decode it
          dynamic responseData = response.body;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }

          // Verify it's a Map before parsing
          if (responseData is! Map<String, dynamic>) {
            throw FormatException('Response body is not a valid JSON object');
          }

          final customerBookingsResponse =
              CustomerBookingsResponse.fromJson(responseData);
          customerBookingList.value = customerBookingsResponse.data;
          customerBookingStatus.value = RxStatus.success();
          debugPrint(
              'Successfully loaded ${customerBookingList.length} customer bookings');
        } catch (e, stackTrace) {
          debugPrint('Error parsing customer bookings response: $e');
          debugPrint('Stack trace: $stackTrace');
          debugPrint('Response body type: ${response.body.runtimeType}');
          debugPrint('Response body: ${response.body}');
          customerBookingStatus.value =
              RxStatus.error("Failed to parse bookings: ${e.toString()}");
        }
      } else {
        customerBookingStatus.value = RxStatus.error(
            "Failed to fetch customer bookings: ${response.statusCode} - ${response.statusText}");
      }
    } catch (e, stackTrace) {
      debugPrint('Error fetching customer bookings: $e');
      debugPrint('Stack trace: $stackTrace');
      customerBookingStatus.value = RxStatus.error(e.toString());
    }
  }

  //cancel booking
  Future<bool> cancelBooking({required String bookingId}) async {
    try {
      EasyLoading.show(status: 'Cancelling Booking...');
      final response = await ApiClient.patchData(
          ApiUrl.cancelBooking(bookingId: bookingId), {},
          isBody: false);
      if (response.statusCode == 200 ||
          response.statusCode == 204 ||
          response.statusCode == 201) {
        EasyLoading.showSuccess('Booking cancelled successfully');
        return true;
      } else {
        EasyLoading.showError('Failed to cancel booking');
        return false;
      }
    } catch (e) {
      EasyLoading.showError('Failed to cancel booking');
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }

  //Reschdule booking can be added here
  Future<bool> rescheduleBooking(
      {required String bookingId,
      required String barberId,
      required DateTime newDateTime,
      required String timeSlot}) async {
    try {
      EasyLoading.show(status: 'Rescheduling Booking...');
      final payload = {
        "barberId": barberId,
        "appointmentAt": timeSlot,
        "date": newDateTime.formatDateApi()
      };
      final apiClient = ApiClient();
      final response = await apiClient.putData(
          ApiUrl.rescheduleBooking(bookingId: bookingId), jsonEncode(payload));
      if (response.statusCode == 200 ||
          response.statusCode == 204 ||
          response.statusCode == 201) {
        EasyLoading.showSuccess('Booking rescheduled successfully');
        return true;
      } else {
        // Extract error message from API response
        String errorMessage = 'Failed to reschedule booking';
        try {
          if (response.body != null) {
            if (response.body is Map<String, dynamic>) {
              final body = response.body as Map<String, dynamic>;
              if (body.containsKey('message') && body['message'] != null) {
                errorMessage = body['message'].toString();
              }
            } else if (response.body is String) {
              // Try to parse as JSON
              final parsed = jsonDecode(response.body);
              if (parsed is Map && parsed.containsKey('message')) {
                errorMessage = parsed['message'].toString();
              }
            }
          }
        } catch (e) {
          debugPrint('Error parsing response message: $e');
        }
        EasyLoading.showError(errorMessage);
        return false;
      }
    } catch (e) {
      EasyLoading.showError('Failed to reschedule booking: ${e.toString()}');
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }

  // update booking status
  Future<bool> updateBookingStatus(
      {required String bookingId,
      required String status,
      BuildContext? context}) async {
    try {
      EasyLoading.show(status: 'Updating Booking Status...');
      final response = await ApiClient.patchData(
        ApiUrl.updateBookingStatus(bookingId: bookingId),
        jsonEncode({'status': status}),
      );
      if (response.statusCode == 200 ||
          response.statusCode == 204 ||
          response.statusCode == 201) {
        EasyLoading.showSuccess('Booking status updated successfully');
        context?.pop();
        return true;
      } else {
        EasyLoading.showError('Failed to update booking status');
        return false;
      }
    } catch (e) {
      EasyLoading.showError('Failed to update booking status');
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }
}
