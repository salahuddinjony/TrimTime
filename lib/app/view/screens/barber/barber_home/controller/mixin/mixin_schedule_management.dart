import 'package:barber_time/app/global/helper/extension/extension.dart';
import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/models/schedule/schedule_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin ScheduleManagementMixin on GetxController {
  RxList<BarberSchedule> scheduleList = <BarberSchedule>[].obs;
  Rx<RxStatus> fetchScheduleStatus = Rx<RxStatus>(RxStatus.loading());
  

  Future<void> fetchScheduleData({bool useDay = false}) async {
    final DateTime now = DateTime.now().toLocal();
    final String todaysName = now.dayName().toLowerCase();
    debugPrint("Today's day name: $todaysName, useDay: $useDay");

     fetchScheduleStatus.value = RxStatus.loading();

    try {
      final url = ApiUrl.fetchBarberSchedule+ (useDay ? '/$todaysName' : '');
    

        final response = await ApiClient.getData(
          url,
        );

        if (response.statusCode == 200) {
          final responseData = response.body;
          final scheduleData = BarberScheduleResponse.fromJson(responseData);
          scheduleList.value = scheduleData.data;
          debugPrint("Schedule data fetched successfully");
          debugPrint('Schedule Data: ${scheduleList}');
          fetchScheduleStatus.value = RxStatus.success();
        } else {
          debugPrint(
              'Failed to fetch schedule data: ${response.statusCode} - ${response.statusText}');

          ApiClient.handleResponse;
          fetchScheduleStatus.value = RxStatus.error(
              "Failed to fetch schedule data: ${response.statusCode} - ${response.statusText}");
        }
    } catch (e) {
      debugPrint("Error fetching schedule data: ${e.toString()}");
      fetchScheduleStatus.value =
          RxStatus.error("Error fetching schedule data: ${e.toString()}");
    } finally {
      fetchScheduleStatus.value = RxStatus.success();
    }
  }


}