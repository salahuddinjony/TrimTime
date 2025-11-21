import 'dart:convert';
import 'dart:io';

import 'package:barber_time/app/data/local/shared_prefs.dart';
import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/view/common_widgets/show_custom_snackbar/show_custom_snackbar.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/controller/mixin/mixin_selon_management.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/business_profile/mixin/business_profile_mixin.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/flowers/mixin_followers_following/mixin_followers_following.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/controller/mixin/mixin_barber_professional_profile.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/controller/mixin/mixin_hired_barber.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/controller/mixin/mixin_logged_profile_info.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/controller/mixin/mixin_owner_profile_image_update.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/models/barber_professional_profile.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/models/profile_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class OwnerProfileController extends GetxController
    with
        BarberProfessionalProfile,
        OwnerProfileImageUpdateMixin,
        LoggedProfileInfoMixin,
        MixinHiredBarbers,
        MixinSelonManagement,
        MixinFollowersFollowing,
        BusinessProfileMixin {
  var selectedValue = ''.obs;

  void updateSelection(String value, TextEditingController controller) {
    selectedValue.value = value;
    controller.text = value;
  }

  // Owner profile update

  final genderController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();
  var imagepath = ''.obs;
  var isNetworkImage = false.obs;

  @override
  void setInitialValue(ProfileData data) {
    super.setInitialValue(data);

    // phoneNumber is already a String? in the model, but avoid unsafe casts
    phoneController.text = data.phoneNumber ?? '';

    // address may be null
    locationController.text = data.address ?? '';
    imagepath.value = data.image ?? '';
    // If the image from the server is a URL, mark it as network image so UI uses network loader.
    isNetworkImage.value =
        (data.image != null && data.image!.toLowerCase().startsWith('http'));
    // Initialize gender value for radio buttons and the text controller
    if (data.gender.isNotEmpty) {
      genderController.text = data.gender;
      selectedValue.value = data.gender;
    } else {
      genderController.text = '';
      selectedValue.value = '';
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchProfileInfo();
    initializeFunctions();
    // barberProfileFetch();
    // Ensure InfoController is initialized for fetch the data
    //  final infoController = Get.find<InfoController>();
    selectedValue.value = '';
  }

  void initializeFunctions() async {
    final userName = await SharePrefsHelper.getString(AppConstants.role);
    if (userName == 'BARBER') {
      debugPrint("Barber Owner Profile");
      barberProfileFetch();
    }
  }

  // for selecete calender
  DateTime selectedDate = DateTime.now();
  void selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      final dd = selectedDate.day.toString().padLeft(2, '0');
      final mm = selectedDate.month.toString().padLeft(2, '0');
      final yyyy = selectedDate.year.toString();
      dateController.text = '$dd/$mm/$yyyy';
      // update();
    }
  }

  void setInitialData(BarberProfile data) {
    bioController.text = data.bio ?? '';
    experienceController.text = data.experienceYears.toString();
    currentWorkController.text = data.currentWorkDes ?? '';
    addSkillsController.text = data.skills.join(', ');

    // Set image path from portfolio if available
    if (data.portfolio.isNotEmpty) {
      imagepath.value = data.portfolio.first;
      isNetworkImage.value = true; // Portfolio images are network URLs
    } else {
      imagepath.value = '';
      isNetworkImage.value = false;
    }
  }

  // Future<void> fetchProfileInfo() async {
  //   try {
  //     isLoading.value = true;
  //     final response = await ApiClient.getData(
  //       ApiUrl.fetchProfileInfo,
  //     );

  //     if (response.statusCode == 200) {
  //       final body =
  //           response.body is String ? jsonDecode(response.body) : response.body;
  //       final resp = ProfileResponse.fromJson(body as Map<String, dynamic>);
  //       profileDataList.assignAll(resp.data != null ? [resp.data!] : []);
  //       // If we have profile data, update the text controllers to reflect the latest server values.
  //       if (profileDataList.isNotEmpty) {
  //         setInitialValue(profileDataList.first);
  //       }
  //       debugPrint("profile data fetched successfully");
  //       debugPrint('Profile Data: ${profileDataList}');
  //       isLoading.value = false;
  //     } else {
  //       debugPrint(
  //           'Failed to load profile: ${response.statusCode} - ${response.body}');
  //       ApiClient.handleResponse;
  //       toastMessage(message: response.statusText ?? 'Failed to load profile');
  //       isLoading.value = false;
  //     }
  //   } catch (e) {
  //     toastMessage(message: 'Failed to load profile');
  //     debugPrint('Error fetching profile: $e');
  //     isLoading.value = false;
  //   } finally {
  //     isLoading.value = false;
  //     refresh();
  //   }
  // }

  Future<bool> ownerProfileUpdate() async {
    EasyLoading.show(status: 'Updating...');
    // If a local image was selected, upload it first and wait for the server to process it.
    if (imagepath.value.isNotEmpty && !isNetworkImage.value) {
      final uploaded = await updateProfileImage(imagePath: imagepath.value);
      if (uploaded) {
        // After successful upload, treat the profile image as coming from the network
        // The next fetchProfileInfo() will replace `imagepath` with server URL.
        isNetworkImage.value = true;
      }
    }

    try {
      isLoading.value = true;
      final body = {
        "fullName": nameController.text,
        "gender": genderController.text,
        "phoneNumber": phoneController.text,
        "dateOfBirth": dateController.text,
        "address": locationController.text,
        // Add other fields as necessary
      };
      final multipart = <MultipartBody>[];
      if (imagepath.value.isNotEmpty) {
        multipart.add(MultipartBody("portfolioImages", File(imagepath.value)));
      }

      final response = await ApiClient.patchData(
        ApiUrl.ownerProfileUpdateInfo,
        jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.dismiss();
        fetchProfileInfo();
        EasyLoading.showSuccess('Updated successfully');
        debugPrint("owner profile updated successfully");
        return true;
      } else {
        debugPrint(
            'Failed to update profile: ${response.statusCode} - ${response.body}');
        ApiClient.handleResponse;
        toastMessage(
            message: response.statusText ?? 'Failed to update profile');
        return false;
      }
    } catch (e) {
      toastMessage(message: 'Failed to update profile');
      debugPrint('Error updating profile: $e');
      return false;
    } finally {
      EasyLoading.dismiss();
      isLoading.value = false;
    }
  }
}
