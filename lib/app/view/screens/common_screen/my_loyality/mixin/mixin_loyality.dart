import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/view/screens/common_screen/my_loyality/models/loyality_data_model.dart';
import 'package:get/get.dart';

mixin MixinLoyality {
  RxList<VisitedSaloon> loyalityList = RxList<VisitedSaloon>([]);
  Rx<RxStatus> loyalityStatus = Rx<RxStatus>(RxStatus.empty());

  Future<void> fetchLoyalityRewards() async {
    loyalityStatus.value = RxStatus.loading();
    try {
      final response = await ApiClient.getData(ApiUrl.getLoyalityRewards);

      if (response.statusCode == 200) {
        final data = LoyaltyDataModel.fromJson(response.body);
        loyalityList.value = data.data;
        loyalityStatus.value = RxStatus.success();
      } else {
        loyalityStatus.value = RxStatus.error('Failed to load loyality data');
        throw Exception('Failed to load loyality data');
      }
    } catch (e) {
      loyalityStatus.value = RxStatus.error(e.toString());
    } finally {}
  }
}
