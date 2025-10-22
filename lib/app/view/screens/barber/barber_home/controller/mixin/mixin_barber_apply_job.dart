import 'dart:convert';
import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

mixin MixinBarberApplyJob {
  Rx<RxStatus> applyJobStatus = Rx<RxStatus>(RxStatus.loading());

  Future<bool> applyJob({required String jobId}) async {
    try {
      final Map<String, dynamic> applyJobData = {
        "jobPostId": jobId,
      };

      debugPrint("Apply Job Data: $applyJobData");

      final response = await ApiClient.postData(
        ApiUrl.applyJobUri,
        jsonEncode(applyJobData), // Encode the map as JSON string
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        applyJobStatus.value = RxStatus.success();
        debugPrint("Job applied successfully");
        return true;
      } else {
        applyJobStatus.value = RxStatus.error(
            "Failed to apply job: ${response.statusCode} - ${response.statusText}");
        return false;
      }
    } catch (e) {
      debugPrint("Error applying job: ${e.toString()}");
      applyJobStatus.value =
          RxStatus.error("Error applying job: ${e.toString()}");
      return false;
    }
  }
}
