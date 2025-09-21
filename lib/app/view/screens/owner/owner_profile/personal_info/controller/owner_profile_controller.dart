import 'dart:convert';

import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/view/common_widgets/show_custom_snackbar/show_custom_snackbar.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/controller/mixin/mixin_barber_professional_profile.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/models/profile_response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/settings/info_controller/info_controller.dart';

class OwnerProfileController extends GetxController with BarberProfessionalProfile {
  var selectedValue = ''.obs;

  RxList<ProfileData> profileDataList = <ProfileData>[].obs;
  var isLoading = false.obs;


  void updateSelection(String value, TextEditingController controller) {
    selectedValue.value = value;
    controller.text = value;
  }

  @override
  void onInit() {
    super.onInit();
    fetchProfileInfo();
    barberProfileFetch();
    // Ensure InfoController is initialized for fetch the data
     final infoController = Get.find<InfoController>(); 
      selectedValue.value = '';

  }

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
  profileDataList.assignAll(resp.data != null ? [resp.data!] : []);
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
      refresh();
    }
  }
}
