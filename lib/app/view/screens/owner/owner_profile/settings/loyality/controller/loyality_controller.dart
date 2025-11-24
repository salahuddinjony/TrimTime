import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/settings/loyality/model/loyality_model.dart';
import 'package:get/get.dart';

class LoyalityController extends GetxController {

  RxList<LoyalityItem> loyalityData = RxList<LoyalityItem>([]);
  Rx<RxStatus> loyalityStatus = Rx<RxStatus>(RxStatus.empty());

  Future<void> fetchLoyalityData() async {
    try {
      loyalityStatus.value = RxStatus.loading();
     final response = await ApiClient.getData(ApiUrl.loyalityProgram);
      if (response.statusCode == 200) {
        final data = response.body;
        final responseObj = LoyalityResponse.fromJson(data);
        loyalityData.value = responseObj.data;
        loyalityStatus.value = RxStatus.success();
      } else {
        loyalityStatus.value = RxStatus.error('Failed to fetch loyality data');
      }
      
    } catch (e) {
      loyalityStatus.value = RxStatus.error('Failed to fetch loyality data');
    }
  }
  


}