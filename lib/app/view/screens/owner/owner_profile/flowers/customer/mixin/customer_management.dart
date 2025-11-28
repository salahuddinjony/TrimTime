import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/flowers/customer/models/customer_fetch/customer_data.dart';
import 'package:get/get.dart';

mixin CustomerManagement {
  Rx<CustomerData?> customerInfo = Rx<CustomerData?>(null);
  Rx<RxStatus> customerInfoStatus = Rx<RxStatus>(RxStatus.empty());

  Future<void> fetchCustomerInfo({required String customerId}) async {
    try {
      customerInfoStatus.value = RxStatus.loading();
      final response = await ApiClient.getData(
        ApiUrl.getCustomer(customerId),
      );
      if (response.statusCode == 200) {
        final data = response.body;
        customerInfo.value = CustomerFetchResponse.fromJson(data).data;
        customerInfoStatus.value = RxStatus.success();
      } else {
        final errorMessage =
            response.body['message'] ?? 'Failed to load customer info';
        customerInfoStatus.value = RxStatus.error(errorMessage);
      }
    } catch (e) {
      customerInfoStatus.value = RxStatus.error(e.toString());
    } finally {}
  }
}
