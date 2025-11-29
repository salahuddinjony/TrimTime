import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/view/screens/user/home/create_booking/models/get_barber_with_date_wise_model.dart';
import 'package:get/get.dart';

mixin MixinGetBarberDatewise {
  Rxn<BarbersData> barberDatewiseBookings = Rxn<BarbersData>();
  Rx<RxStatus> getBarberDatewiseStatus = Rx<RxStatus>(RxStatus.empty());
  RxString noBarbersMessage = RxString('');

  Future<void> getBarberDatewiseBookings({required String barberId, required String date}) async {
    try {
      getBarberDatewiseStatus.value = RxStatus.loading();
      noBarbersMessage.value = '';

      final respose = await ApiClient.getData(
        ApiUrl.getBarberDateWiseBookings(barberId: barberId, date: date),
      );
      if (respose.statusCode == 200 || respose.statusCode == 201) {
        final data = respose.body;
        final barberDatewiseData = GetBarberWithDateWiseResponse.fromJson(data);
        barberDatewiseBookings.value = barberDatewiseData.data;
        
        // Check if there's a message indicating no barbers
        if (barberDatewiseData.data.message != null && barberDatewiseData.data.barbers.isEmpty) {
          noBarbersMessage.value = barberDatewiseData.data.message!;
        } else if (barberDatewiseData.data.barbers.isEmpty) {
          noBarbersMessage.value = 'No barbers available for this date.';
        }
      }

      getBarberDatewiseStatus.value = RxStatus.success();
    } catch (e) {
      getBarberDatewiseStatus.value =
          RxStatus.error("Error fetching bookings: \\${e.toString()}");
    } finally {
      getBarberDatewiseStatus.refresh();
    }
  }
}