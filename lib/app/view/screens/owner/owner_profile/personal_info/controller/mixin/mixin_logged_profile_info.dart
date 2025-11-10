import 'dart:convert';

import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/view/common_widgets/show_custom_snackbar/show_custom_snackbar.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/models/profile_response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin LoggedProfileInfoMixin {
  Rx<ProfileData?> profileDataList = Rx<ProfileData?>(null);
  final nameController = TextEditingController();
  final dateController = TextEditingController();

  void setInitialValue(ProfileData data) {
    nameController.text = data.fullName;
    if (data.dateOfBirth != null) {
      final d = data.dateOfBirth!;
      final dd = d.day.toString().padLeft(2, '0');
      final mm = d.month.toString().padLeft(2, '0');
      final yyyy = d.year.toString();
      dateController.text = '$dd/$mm/$yyyy';
    } else {
      dateController.text = '';
    }
  }

  var isLoading = false.obs;
  Future<void> fetchProfileInfo() async {
    try {
      isLoading.value = true;
      final response = await ApiClient.getData(
        ApiUrl.fetchProfileInfo,
      );

      if (response.statusCode == 200) {
        final body =
            response.body is String ? jsonDecode(response.body) : response.body;
        final resp = ProfileResponse.fromJson(body as Map<String, dynamic>);
        profileDataList.value = resp.data;
        // If we have profile data, update the text controllers to reflect the latest server values.
        if (profileDataList.value != null) {
          setInitialValue(profileDataList.value!);
        }
        debugPrint("profile data fetched successfully");
        debugPrint('Profile Data: ${profileDataList}');
        isLoading.value = false;
      } else {
        debugPrint(
            'Failed to load profile: ${response.statusCode} - ${response.body}');
        ApiClient.handleResponse;
        toastMessage(message: response.statusText ?? 'Failed to load profile');
        isLoading.value = false;
      }
    } catch (e) {
      toastMessage(message: 'Failed to load profile');
      debugPrint('Error fetching profile: $e');
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }
}
