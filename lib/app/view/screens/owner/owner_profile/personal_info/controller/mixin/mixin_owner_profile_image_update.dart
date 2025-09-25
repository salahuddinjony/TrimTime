import 'dart:io';

import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:flutter/material.dart';

mixin OwnerProfileImageUpdateMixin {
  Future<bool> updateProfileImage(
      {required String imagePath, bool? isNetwork}) async {
    try {
      // Prepare multipart body
      final multipart = <MultipartBody>[
        MultipartBody("profileImage", File(imagePath))
      ];

      // Call PUT multipart endpoint (matches Postman screenshot: PUT /users/update-profile-image)
      final response = await ApiClient.putMultipart(
        ApiUrl.profileImageUpload,
        {},
        multipartBody: multipart,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("Profile image updated successfully");
        return true;
      } else {
        debugPrint(
            "Failed to update profile image: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("Error updating profile image: $e");
      return false;
    }
  }
}
