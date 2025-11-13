import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/owner_payment/hiring_barber/model/hired_barber_model.dart';
import 'package:get/get.dart';

mixin MixinHiredBarbers {
  RxList<HiredBarber> hiredBarberList = <HiredBarber>[].obs;
  Rx<RxStatus> hiredBarberStatus = Rx<RxStatus>(RxStatus.empty());

  
  Future<void> fetchHiredBarbers() async {
    hiredBarberStatus.value = RxStatus.loading();
    try {
      final response = await ApiClient.getData(ApiUrl.getHiredBarbers);
      if (response.statusCode == 200) {
        final data = HiredBarberResponse.fromJson(response.body).data;

        hiredBarberList.value = data;
        hiredBarberStatus.value = RxStatus.success();
      } else {
        hiredBarberStatus.value =
            RxStatus.error('Failed to load hired barbers');
      }
    } catch (e) {
      hiredBarberStatus.value = RxStatus.error(e.toString());
    } finally {
      if (hiredBarberStatus.value.isLoading) {
        hiredBarberStatus.value = RxStatus.empty();
      }
    }
  }
}
