import 'dart:convert';

import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/view/common_widgets/show_custom_snackbar/show_custom_snackbar.dart';
import 'package:barber_time/app/view/screens/barber/barber_history/models/job_application_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

mixin BarberJobHistoryMixin {
  var isJobHistoryLoading = false.obs;
  RxList<JobApplication> jobHistoryList = <JobApplication>[].obs;

  Future<void> getAllJobHistory({String? status, bool? isBarberOwner}) async {
    try {
      final Map<String, String> queryParams = {};
      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }
      isJobHistoryLoading.value = true;
      final String url = isBarberOwner == true
          ? ApiUrl.barberOwnerApplications
          : ApiUrl.historyOfMyApplications;
      final response = await ApiClient.getData(url, query: queryParams);

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
      isJobHistoryLoading.value = false;
      toastMessage(message: 'Failed to load all job history');
    } finally {
      isJobHistoryLoading.value = false;
    }
  }
  Future<void> updateJobStatus({required String applicationId, required String status, BuildContext? context}) async {
    try {
      EasyLoading.show(status: 'Updating job status...');
      isJobHistoryLoading.value = true;
      final String url = ApiUrl.updateJobApplicationStatus(id: applicationId);
      final response = await ApiClient.patchData(
        url,
         jsonEncode({'status': status})
        );

      if (response.statusCode == 200 || response.statusCode == 201) {

        toastMessage(message: 'Job status updated successfully');
        // Optionally refresh the job history list
        await getAllJobHistory();
        if (context != null) {
          Navigator.of(context).pop(); // Close any open dialog
        }
        EasyLoading.showSuccess(  'Job status updated successfully');
      } else {
        debugPrint(
            "Failed to update job status: ${response.statusCode} - ${response.statusText}");
        toastMessage(
            message: response.statusText ?? 'Failed to update job status');
      }
    } catch (e) {
      debugPrint("Error updating job status: ${e.toString()}");
      toastMessage(message: 'Failed to update job status');
    } finally {
      isJobHistoryLoading.value = false;
      EasyLoading.dismiss();
    }
  }
}
