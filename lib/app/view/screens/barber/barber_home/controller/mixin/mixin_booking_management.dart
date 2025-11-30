import 'package:barber_time/app/global/helper/extension/extension.dart';
import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/models/barber_booking/barber_booking_model.dart';
import 'package:barber_time/app/view/screens/user/bookings/models/customer_bookins_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

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

  Future<void> fetchCustomerBookings() async {
    try {
      customerBookingStatus.value = RxStatus.loading();
      final Map<String, dynamic> query = {
        'limit': '200',
      };
      final response = await ApiClient.getData(
        ApiUrl.getCustomerBookings,
        query: query,
      );
      if (response.statusCode == 200) {
        final responseData = response.body;
        final customerBookingsResponse =
            CustomerBookingsResponse.fromJson(responseData);
        customerBookingList.value = customerBookingsResponse.data;
        customerBookingStatus.value = RxStatus.success();
      } else {
        customerBookingStatus.value = RxStatus.error(
            "Failed to fetch customer bookings: ${response.statusCode} - ${response.statusText}");
      }
    } catch (e) {
      customerBookingStatus.value = RxStatus.error(e.toString());
    }
  }

  //cancel booking
  Future<bool> cancelBooking({required String bookingId}) async {
    try {
      EasyLoading.show(status: 'Cancelling Booking...');
      final response = await ApiClient.patchData(
          ApiUrl.cancelBooking(bookingId: bookingId), {}, isBody: false);
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
    }finally {
      EasyLoading.dismiss();
    }
  }

  //Reschdule booking can be added here
  Future<bool> rescheduleBooking(
      {required String bookingId,
      required DateTime newDateTime,
      required String timeSlot}) async {
    try {
      EasyLoading.show(status: 'Rescheduling Booking...');
      final payload = {
        "bookingId": bookingId,
        "appointmentAt": timeSlot,
        "date": newDateTime.formatDateApi()
      };
      final response =
          await ApiClient.patchData(ApiUrl.rescheduleBooking, payload);
      if (response.statusCode == 200 ||
          response.statusCode == 204 ||
          response.statusCode == 201) {
        EasyLoading.showSuccess('Booking rescheduled successfully');
        return true;
      } else {
        EasyLoading.showError('Failed to reschedule booking');
        return false;
      }
    } catch (e) {
      EasyLoading.showError('Failed to reschedule booking');
      return false;
    }finally {
      EasyLoading.dismiss();
    }
  }
}
