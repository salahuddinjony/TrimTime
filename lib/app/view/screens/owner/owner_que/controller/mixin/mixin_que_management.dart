import 'dart:convert';
import 'package:barber_time/app/data/local/shared_prefs.dart';
import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/view/screens/owner/owner_que/model/que_model_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin QueManagementMixin {
  RxInt selectedIndex = 0.obs;
  RxList<QueBarber> queList = <QueBarber>[].obs;
  Rx<RxStatus> queListStatus = Rx<RxStatus>(RxStatus.empty());
  RxBool isQueueEnabled = false.obs; // Track the toggle state

  Future<void> fetchQueList() async {
    queListStatus.value = RxStatus.loading();

    try {
      final String selonOwnerId = await SharePrefsHelper.getString(AppConstants.userId);
      debugPrint('Fetching que list for owner ID: $selonOwnerId');
      final response = await ApiClient.getData(ApiUrl.getQueList(id: selonOwnerId));

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        final data = QueResponse.fromJson(decodedJson).data;

        queList.value = data.barbers;

        queListStatus.value = RxStatus.success();
      } else {
        queListStatus.value = RxStatus.error('Failed to load que list');
      }
    } catch (e) {
      queListStatus.value = RxStatus.error(e.toString());
    }
  }

  // Function to handle the toggle state change
  void toggleQueueStatus(bool value) {
    isQueueEnabled.value = value;
    debugPrint('Queue is ${isQueueEnabled.value ? 'enabled' : 'disabled'}');
  }
}
