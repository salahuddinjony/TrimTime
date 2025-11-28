import 'package:barber_time/app/data/local/shared_prefs.dart';
import 'package:barber_time/app/global/helper/extension/extension.dart';
import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/view/screens/owner/owner_que/controller/mixin/mixin_get_barber_with_date_time/model/date_time_wise_barber.dart';
import 'package:get/get.dart';

mixin GetBarberWithDateTimeMixin {
  RxList<DateTimeWiseBarber> barberWithDateTimeList =
      RxList<DateTimeWiseBarber>();
  Rx<RxStatus> getBarberWithDateTimeStatus = Rx<RxStatus>(RxStatus.empty());
  RxString msg = RxString('');

  Future<void> getBarberWithDateTime(
      {String? time, String? totalServicesTime}) async {
    try {
      getBarberWithDateTimeStatus.value = RxStatus.loading();
      final saloonOwnerId =
          await SharePrefsHelper.getString(AppConstants.userId);
      final Map<String, String> queryParams = {};
      
      queryParams['saloonOwnerId'] = saloonOwnerId;
      queryParams['date'] =DateTime.now().formatDateApi(); // Current date
      queryParams['type'] = 'QUEUE';
    
      if (time != null) {
        queryParams['time'] = time;
      }
      if (totalServicesTime != null) {
        queryParams['totalServiceTime'] = totalServicesTime;
      }

      final response = await ApiClient.getData(
        ApiUrl.getBarberWithDateTime,
        query: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.body;
        barberWithDateTimeList.value =
            DateTimeWiseBarberResponse.fromJson(data).data;

        getBarberWithDateTimeStatus.value = RxStatus.success();
        msg.value= '';
      } else {
        msg.value = response.body['message'] ?? 'Unknown error';
        getBarberWithDateTimeStatus.value = RxStatus.error();
      }
    } catch (e) {
      getBarberWithDateTimeStatus.value = RxStatus.error(
          "Error fetching barber with date time: ${e.toString()}");
    } finally {
      getBarberWithDateTimeStatus.refresh();
    }
  }
}
