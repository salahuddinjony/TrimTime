import 'dart:convert';

import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/view/common_widgets/show_custom_snackbar/show_custom_snackbar.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/models/barber_professional_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

mixin BarberProfessionalProfile {
  RxBool isBarberProfessionalProfileLoading = false.obs;
  RxList<BarberProfile> barberProfessionalProfileList = <BarberProfile>[].obs;

  // For viewing other barber's profile
  RxBool isOtherBarberProfileLoading = false.obs;
  Rx<BarberProfile?> otherBarberProfile = Rx<BarberProfile?>(null);

  var imagepath = ''.obs;
  var isNetworkImage = false.obs;
  var clearedInitialImage = false.obs;
  RxBool isFollowing = false.obs;
  RxBool isMe = false.obs;

  final bioController = TextEditingController();
  final experienceController = TextEditingController();
  final currentWorkController = TextEditingController();
  final addSkillsController = TextEditingController();

  Future<void> barberProfileFetch() async {
    try {
      isBarberProfessionalProfileLoading.value = true;
      final response = await ApiClient.getData(
        ApiUrl.barberProfileFetchInfo,
      );

      if (response.statusCode == 200) {
        final body =
            response.body is String ? jsonDecode(response.body) : response.body;
        final resp =
            BarberProfileResponse.fromJson(body as Map<String, dynamic>);
        barberProfessionalProfileList.value = [resp.data];
        isMe.value = resp.data.isMe;
        debugPrint("Professional profile data fetched successfully");
        debugPrint(
            'Professional Profile Data: ${barberProfessionalProfileList}');
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

  // Fetch barber profile by userId
  Future<void> fetchBarberProfileById(String barberId) async {
    try {
      isOtherBarberProfileLoading.value = true;
      final response = await ApiClient.getData(
        ApiUrl.barberProfileById(barberId),
      );

      if (response.statusCode == 200) {
        final body =
            response.body is String ? jsonDecode(response.body) : response.body;
        final resp =
            BarberProfileResponse.fromJson(body as Map<String, dynamic>);
        otherBarberProfile.value = resp.data;
        isFollowing.value = resp.data.isFollowing;
        isMe.value = resp.data.isMe;
        debugPrint("Other barber profile data fetched successfully");
        debugPrint('Other Barber Profile Data: ${otherBarberProfile.value}');
      } else {
        debugPrint(
            'Failed to load barber profile: ${response.statusCode} - ${response.body}');
        ApiClient.handleResponse;
        toastMessage(
            message: response.statusText ?? 'Failed to load barber profile');
      }
    } catch (e) {
      toastMessage(message: 'Failed to load barber profile');
      debugPrint('Error fetching barber profile: $e');
    } finally {
      isOtherBarberProfileLoading.value = false;
    }
  }

  void isBarberFollowing() {
    debugPrint("isFollowing before toggle: ${isFollowing.value}");
    // Toggle the follow status
    isFollowing.value = !isFollowing.value;
    debugPrint("isFollowing after toggle: ${isFollowing.value}");
  }

  Future<bool> toggleBarberFollow({required String userId}) async {
    try {
      final response = (isFollowing == true)
          ? await ApiClient.postData(
              ApiUrl.toggleFollowSalon,
              jsonEncode({"followingId": userId}),
            )
          : await ApiClient.deleteData(
              ApiUrl.makeUnfollow(id: userId),
            );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        // Revert the follow status on failure
        isFollowing.value = !isFollowing.value;

        debugPrint(
            "Failed to toggle follow status: ${response.statusCode} - ${response.statusText}");
        return false;
      }
    } catch (e) {
      // Revert the follow status on error
      isFollowing.value = !isFollowing.value;
      debugPrint("Error toggling follow status: ${e.toString()}");
      return false;
    } finally {}
  }

  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();
      final XFile? result = await picker.pickImage(source: ImageSource.gallery);
      if (result != null) {
        imagepath.value = result.path;
        isNetworkImage.value = false; // Mark as local file
        debugPrint("Picked image path: ${imagepath.value.toString()}");
      }
    } catch (e) {
      debugPrint("Error picking image: ${e.toString()}");
      toastMessage(message: 'Failed to pick image');
    }
  }

  Future<bool> updateBarberProfile() async {
    EasyLoading.show(status: 'Updating...');
    try {
      isBarberProfessionalProfileLoading.value = true;
      final body = {
        "currentWorkDes": currentWorkController.text,
        "bio": bioController.text,
        "experienceYears": experienceController.text,
        "skills":
            addSkillsController.text.split(',').map((e) => e.trim()).toList(),
        "isAvailable": true,
        // Add other fields as necessary
      };
      final multipart = <MultipartBody>[];
      // Only add image if it's a local file, not a network URL ... multiple images not supported yet
      if (imagepath.value.isNotEmpty && !isNetworkImage.value) {
        multipart.add(MultipartBody("portfolioImages", File(imagepath.value)));
      }

      final response = multipart.isNotEmpty
          ? await ApiClient.patchMultipart(
              ApiUrl.barberProfileUpdateInfo,
              {
                "bodyData": jsonEncode(body),
              },
              multipartBody: multipart)
          : await ApiClient.patchData(
              ApiUrl.baseUrl + ApiUrl.barberProfileUpdateInfo,
              jsonEncode(body),
            );

      if (response.statusCode == 200 || response.statusCode == 201) {
        barberProfileFetch();
        EasyLoading.showSuccess('Updated successfully');
        debugPrint("Professional profile updated successfully");
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
      isBarberProfessionalProfileLoading.value = false;
    }
  }
}
