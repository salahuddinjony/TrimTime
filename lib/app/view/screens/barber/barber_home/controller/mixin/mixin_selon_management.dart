import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/models/selon_model/single_selon_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin MixinSelonManagement {
Rx<RxStatus> getSelonStatus = Rx<RxStatus>(RxStatus.loading());
RxList<SingleSaloonModel> selonList = RxList<SingleSaloonModel>();

  Future<void> getSelonData({String? userId}) async {
    try {
      getSelonStatus.value = RxStatus.loading();

      final response= await ApiClient.getData(
        ApiUrl.getSelonData(userId: userId),
      );
      if (response.statusCode == 200) {
        final responseData = response.body;
        final selonData = SingleSaloonModel.fromJson(responseData);

        selonList.value = [selonData];
        getSelonStatus.value = RxStatus.success();
      } else {
        getSelonStatus.value = RxStatus.error(
            "Failed to fetch selon data: ${response.statusCode} - ${response.statusText}");
      }

      getSelonStatus.value = RxStatus.success();
      debugPrint("Selon data fetched successfully");
    } catch (e) {
      debugPrint("Error fetching selon data: ${e.toString()}");
      getSelonStatus.value =
          RxStatus.error("Error fetching selon data: ${e.toString()}");
    } finally {
      getSelonStatus.refresh();
    }
  }
}