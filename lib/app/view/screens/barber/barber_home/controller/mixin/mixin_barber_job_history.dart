import 'dart:convert';

import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/view/common_widgets/show_custom_snackbar/show_custom_snackbar.dart';
import 'package:barber_time/app/view/screens/barber/barber_history/models/job_application_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin BarberJobHistoryMixin  {
var isJobHistoryLoading = false.obs;
RxList<JobApplication> jobHistoryList = <JobApplication>[].obs;

 Future<void> getAllJobHistory() async {
    try {
      isJobHistoryLoading.value = true;
      final response = await ApiClient.getData(ApiUrl.historyOfMyApplications);

    if (response.statusCode == 200 || response.statusCode == 201) {
    final body =
      response.body is String ? jsonDecode(response.body) : response.body;
    final resp = body is String
      ? JobApplicationResponse.fromJson(body)
      : JobApplicationResponse.fromMap(body as Map<String, dynamic>);
        jobHistoryList.value = resp.data;
        debugPrint("All Job History data length: ${jobHistoryList.length}");
        debugPrint("All Job History Data: ${jobHistoryList}");
      } else {
        debugPrint(
            "Failed to load all job history: ${response.statusCode} - ${response.statusText}");
        toastMessage(
            message: response.statusText ?? 'Failed to load all job history');
      }
    } catch (e) {
      debugPrint("Error fetching all job history: ${e.toString()}");
      toastMessage(message: 'Failed to load all job history');
    } finally {
      isJobHistoryLoading.value = false;
    }
  }
}