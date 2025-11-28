import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/view/screens/user/home/create_booking/models/selected_barber_free_slots_model.dart';
import 'package:get/get.dart';

mixin MixinSelectedBarberFreeSlot{
  RxList<TimeSlot> seletedBarberFreeSlots = <TimeSlot>[].obs;
  Rx<RxStatus> selectedBarberFreeSlotsStatus = Rx<RxStatus>(RxStatus.empty());

  Future<void> getSelectedBarberFreeSlots(
      {required String barberId,
      required String saloonId,
      required String date}) async {
    try {
      selectedBarberFreeSlotsStatus.value = RxStatus.loading();
      final response = await ApiClient.getData(
        ApiUrl.getSelonBarberFreeSlots(
            barberId: barberId, saloonId: saloonId, date: date),
        query: {
          'date': date,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body;
        final freeslotsData = SelectedBarberFreeSlotsResponse.fromJson(data);
        seletedBarberFreeSlots.value = freeslotsData.data.freeSlots;
      }
      selectedBarberFreeSlotsStatus.value = RxStatus.success();
    } catch (e) {
      selectedBarberFreeSlotsStatus.value =
          RxStatus.error("Error fetching free slots: ${e.toString()}");
    } finally {
      selectedBarberFreeSlotsStatus.refresh();
    }
  }
}
