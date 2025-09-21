import 'dart:convert';

import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/view/common_widgets/show_custom_snackbar/show_custom_snackbar.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/models/barber_professional_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin BarberProfessionalProfile {

  RxBool isBarberProfessionalProfileLoading = false.obs;
  RxList<BarberProfile> barberProfessionalProfileList = <BarberProfile>[].obs;

  Future<void> barberProfileFetch() async {
    try {
      isBarberProfessionalProfileLoading.value = true;
      final response = await ApiClient.getData(
        ApiUrl.barberProfileFetchInfo,
      );

      if (response.statusCode == 200) {
        final body =
            response.body is String ? jsonDecode(response.body) : response.body;
        final resp = BarberProfileResponse.fromJson(body as Map<String, dynamic>);
        barberProfessionalProfileList.value = [resp.data];
        debugPrint("Professional profile data fetched successfully");
        debugPrint('Professional Profile Data: ${barberProfessionalProfileList}');
        isBarberProfessionalProfileLoading.value = false;
      } else {
        debugPrint(
            'Failed to load profile: ${response.statusCode} - ${response.body}');
        ApiClient.handleResponse;
        toastMessage(message: response.statusText ?? 'Failed to load profile');
        isBarberProfessionalProfileLoading.value = false;
      }
    } catch (e) {
      toastMessage(message: 'Failed to load profile');
      debugPrint('Error fetching profile: $e');
      isBarberProfessionalProfileLoading.value = false;
    } finally {
      isBarberProfessionalProfileLoading.value = false;
    }
  }
}