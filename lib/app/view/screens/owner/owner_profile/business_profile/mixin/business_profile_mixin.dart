import 'dart:convert';
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

  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;

  final RxList<String> shopImages = <String>[].obs;
  final RxList<String> shopVideo = <String>[].obs;
  final RxList<String> shopLogo = <String>[].obs;

  Rx<RxStatus> professionalStatus = Rx<RxStatus>(RxStatus.empty());
  Future<bool> updateProfessionalProfile() async {
    EasyLoading.show(status: 'Updating Profile...');
    try {
      final Map<String, dynamic> body = {};
      if (shopName.text.isNotEmpty) body['shopName'] = shopName.text;
      if (registrationNumber.text.isNotEmpty)
        body['registrationNumber'] = registrationNumber.text;
      if (shopAddress.text.isNotEmpty) body['shopAddress'] = shopAddress.text;
      if (shopBio.text.isNotEmpty) body['shopBio'] = shopBio.text;

      professionalStatus.value = RxStatus.loading();
      // Prepare multipartBody only if there are files to send
      final List<MultipartBody> multipartBody = [];
      final shopImagesFiles = shopImages
          .where((path) => path.isNotEmpty && File(path).existsSync())
          .map((path) => MultipartBody('shop_images', File(path)))
          .toList();
      final shopVideosFiles = shopVideo
          .where((path) => path.isNotEmpty && File(path).existsSync())
          .map((path) => MultipartBody('shop_videos', File(path)))
          .toList();
      if (shopImagesFiles.isNotEmpty) multipartBody.addAll(shopImagesFiles);
      if (shopVideosFiles.isNotEmpty) multipartBody.addAll(shopVideosFiles);
      if (shopLogo.isNotEmpty && File(shopLogo.first).existsSync()) {
        multipartBody
            .addAll([MultipartBody('shop_logo', File(shopLogo.first))]);
      }

      final response = multipartBody.isNotEmpty
          ? await ApiClient.patchMultipart(
              ApiUrl.updateBusinessProfile,
              {"bodyData": jsonEncode(body)},
              multipartBody: multipartBody,
            )
          : await ApiClient.patchData(
              ApiUrl.baseUrl + ApiUrl.updateBusinessProfile,
              jsonEncode(body),
            );

      if (response.statusCode == 200 || response.statusCode == 201) {
        professionalStatus.value = RxStatus.success();
        fetchBusinessProfiles();
        EasyLoading.showSuccess('Profile Updated Successfully');
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
