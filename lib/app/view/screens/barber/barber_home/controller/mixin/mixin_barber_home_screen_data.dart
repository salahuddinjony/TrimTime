import 'dart:convert';

import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/view/common_widgets/show_custom_snackbar/show_custom_snackbar.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/models/barber_job_post/barber_job_post.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin BarberHomeScreenDataMixin {
  var isJobLoading = false.obs;
RxList<JobPost> jobPostList = <JobPost>[].obs;

 Future<void> getAllJobPost() async {
    try {
      isJobLoading.value = true;
      final response = await ApiClient.getData(ApiUrl.getAllJobPost);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body =
          response.body is String ? jsonDecode(response.body) : response.body;
      final resp = JobPostResponse.fromJson(body as Map<String, dynamic>);
      jobPostList.value = resp.data ?? <JobPost>[];
        debugPrint("All Job Post data length: ${jobPostList.length}");
        debugPrint("All Job Post Data: ${jobPostList}");
      } else {
        debugPrint(
            "Failed to load all job post: ${response.statusCode} - ${response.statusText}");
        toastMessage(
            message: response.statusText ?? 'Failed to load all job post');
      }
    } catch (e) {
      debugPrint("Error fetching all job post: ${e.toString()}");
      toastMessage(message: 'Failed to load all job post');
    } finally {
      isJobLoading.value = false;
    }
  }
}