
import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/view/screens/owner/owner_que/controller/mixin/services/model/services_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


mixin MixinGetServices {
  Rx<RxStatus> getServicesStatus = Rx<RxStatus>(RxStatus.loading());
  
  RxList<ServiceItem> servicesList = RxList<ServiceItem>();

  Future<void> getServices() async {
    try {
      getServicesStatus.value = RxStatus.loading();

      final response = await ApiClient.getData(
        ApiUrl.getServices,
      );
      if (response.statusCode == 200) {
        final responseData = response.body;
        final servicesResponse = ServicesResponse.fromJson(responseData);

        servicesList.value = servicesResponse.data;
        getServicesStatus.value = RxStatus.success();
      } else {
        getServicesStatus.value = RxStatus.error(
            "Failed to fetch services: ${response.statusCode} - ${response.statusText}");
      }

      debugPrint("Services fetched successfully");
    } catch (e) {
      debugPrint("Error fetching services: ${e.toString()}");
      getServicesStatus.value =
          RxStatus.error("Error fetching services: ${e.toString()}");
    } finally {
      getServicesStatus.refresh();
    }
  }
}