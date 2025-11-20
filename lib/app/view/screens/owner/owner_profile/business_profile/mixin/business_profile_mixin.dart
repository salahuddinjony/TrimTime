import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/business_profile/model/business_profile_data.dart';
import 'package:get/get.dart';

mixin BusinessProfileMixin {
  Rx<BusinessProfileData?> businessProfileData = Rx<BusinessProfileData?>(null);
  Rx<RxStatus> businessProfileStatus = Rx<RxStatus>(RxStatus.empty());

  Future<void> fetchBusinessProfiles() async {
    try {
      businessProfileStatus.value = RxStatus.loading();
      final response = await ApiClient.getData(ApiUrl.businessProfile);

      if (response.statusCode == 200) {
        final data = response.body;
        final responseObj = BusinessProfileResponse.fromJson(data);
        businessProfileData.value = responseObj.data;
        businessProfileStatus.value = RxStatus.success();
      } else {
        businessProfileStatus.value =
            RxStatus.error('Failed to fetch business profiles');
      }
    } catch (e) {
      businessProfileStatus.value =
          RxStatus.error('Failed to fetch business profiles');
    }
  }

  RxString selectedType = 'Queue'.obs;
  final RxString selectedBarberId = ''.obs;

  void selectType(String type) {
    selectedType.value = type;
  }
}
