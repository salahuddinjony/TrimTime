import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/view/screens/user/home/customer_review/models/customer_review_models.dart';
import 'package:get/get.dart';

mixin MixinGetCustomerReview {
  RxList<CustomerReviewData> customerReviewsList = RxList<CustomerReviewData>([]);
  Rx<RxStatus> customerReviewStatus = Rx<RxStatus>(RxStatus.empty());

  Future<void> fetchCustomerReviews() async {
    try {
      customerReviewStatus.value = RxStatus.loading();

      final response = await ApiClient.getData(
        ApiUrl.getCustomerReviews,
      );

      if (response.statusCode == 200) {
        final responseData = response.body;
        // Parse the response using the model
        final data = CustomerReviewResponse.fromJson(responseData);
        customerReviewsList.value = data.data;
        customerReviewStatus.value = RxStatus.success();
      } else {
        customerReviewStatus.value = RxStatus.error(
            "Failed to fetch customer reviews: ${response.statusCode} - ${response.statusText}");
      }
    } catch (e) {
      customerReviewStatus.value = RxStatus.error(e.toString());
    }
  }
}
