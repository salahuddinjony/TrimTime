import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/settings/loyality/model/loyality_model.dart';
import 'package:get/get.dart';

class LoyalityController extends GetxController {
  RxList<LoyalityItem> loyalityData = RxList<LoyalityItem>([]);
  Rx<RxStatus> loyalityStatus = Rx<RxStatus>(RxStatus.empty());

  String? apiErrorMessage;

  Future<void> fetchLoyalityData() async {
    try {
      loyalityStatus.value = RxStatus.loading();
      apiErrorMessage = null;
      final response = await ApiClient.getData(ApiUrl.loyalityProgram);
      if (response.statusCode == 200) {
        final data = response.body;
        final responseObj = LoyalityResponse.fromJson(data);
        loyalityData.value = responseObj.data;
        loyalityStatus.value = RxStatus.success();
      } else {
        // Try to extract message from response body
        String? message;
        try {
          final body = response.body;
          if (body is Map && body['message'] != null) {
            message = body['message'];
          } else if (body is String) {
            message = body;
          }
        } catch (_) {}
        apiErrorMessage = message ?? 'Failed to fetch loyalty data';
        loyalityStatus.value = RxStatus.error(apiErrorMessage!);
      }
    } catch (e) {
      apiErrorMessage = 'Failed to fetch loyalty data';
      loyalityStatus.value = RxStatus.error(apiErrorMessage!);
    }
  }
}
