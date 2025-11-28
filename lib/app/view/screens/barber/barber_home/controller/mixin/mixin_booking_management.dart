
import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/models/barber_booking/barber_booking_model.dart';
import 'package:get/get.dart';

mixin BookingManagementMixin {
  RxList<BarberBookingData> bookings = RxList<BarberBookingData>([]);
  Rx<RxStatus> bookingStatus = Rx<RxStatus>(RxStatus.empty());

  Future<void> fetchBookings() async {
    try {
      bookingStatus.value = RxStatus.loading();
      final response = await ApiClient.getData(
        ApiUrl.getBarberBookings,
      );
      if (response.statusCode == 200) {
        final responseData = response.body;
        // Parse the response using the model
        final barberBookingResponse = BarberBookingResponse.fromJson(responseData);
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
}

 
