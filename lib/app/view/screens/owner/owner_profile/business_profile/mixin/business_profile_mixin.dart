import 'dart:io';

import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/business_profile/model/business_profile_data.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

mixin BusinessProfileMixin {
  Rx<BusinessProfileData?> businessProfileData = Rx<BusinessProfileData?>(null);
  Rx<RxStatus> businessProfileStatus = Rx<RxStatus>(RxStatus.empty());

  Future<void> fetchBusinessProfiles() async {
    try {
      businessProfileStatus.value = RxStatus.loading();
      final response = await ApiClient.getData(ApiUrl.businessProfile);

      if (response.statusCode == 200) {
        final data = response.body;
        final responseObj = BusinessProfileResponse.fromJson(data);
        businessProfileData.value = responseObj.data;
        businessProfileStatus.value = RxStatus.success();
      } else {
        businessProfileStatus.value =
            RxStatus.error('Failed to fetch business profiles');
      }
    } catch (e) {
      businessProfileStatus.value =
          RxStatus.error('Failed to fetch business profiles');
    }
  }

  RxString selectedType = 'Queue'.obs;
  final RxString selectedBarberId = ''.obs;

  void selectType(String type) {
    selectedType.value = type;
  }

  final TextEditingController shopName = TextEditingController();
  final TextEditingController shopAddress = TextEditingController();
  final TextEditingController shopBio = TextEditingController();
  final TextEditingController registrationNumber = TextEditingController();

  Rx latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;

  final RxList<String> shopImages = <String>[].obs;
  final RxList<String> shopVideo = <String>[].obs;
  final RxString shopLogo = ''.obs;

  Rx<RxStatus> professionalStatus = Rx<RxStatus>(RxStatus.empty());
  Future<bool> updateProfessionalProfile() async {
    EasyLoading.show(status: 'Updating Profile...');
    try {
      final Map<String, dynamic> body = {
        'shopName': shopName.text,
        'registrationNumber': registrationNumber.text,
        'shopAddress': shopAddress.text,
        'shopBio': shopBio.text,
        // 'latitude': double.tryParse(latitude.value.toString()) ?? 0.0,
        // 'longitude': double.tryParse(longitude.value.toString()) ?? 0.0,
      };
      professionalStatus.value = RxStatus.loading();
      final response = await ApiClient.patchMultipart(
        ApiUrl.updateBusinessProfile,
        body,
        multipartBody: [
          ...shopImages
              .where((path) => path.isNotEmpty && File(path).existsSync())
              .map((path) => MultipartBody('shop_images', File(path))),
          ...shopVideo
              .where((path) => path.isNotEmpty && File(path).existsSync())
              .map((path) => MultipartBody('shop_videos', File(path))),
          if (shopLogo.value.isNotEmpty && File(shopLogo.value).existsSync())
            MultipartBody('shop_logo', File(shopLogo.value)),
        ],
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        professionalStatus.value = RxStatus.success();

        fetchBusinessProfiles();
        EasyLoading.showSuccess(
            'Profile Updated Successfully'); // Refresh the business profile data
        return true;
      } else {
        professionalStatus.value =
            RxStatus.error('Failed to update professional profile');
        EasyLoading.showError('Failed to update professional profile');
        return false;
      }
    } catch (e) {
      professionalStatus.value =
          RxStatus.error('Failed to update professional profile');
      EasyLoading.showError('Failed to update professional profile');
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }
}
