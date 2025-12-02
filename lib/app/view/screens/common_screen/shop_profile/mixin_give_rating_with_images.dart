import 'dart:convert';
import 'dart:io';

import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/view/screens/common_screen/shop_profile/mixin_select_multiple_images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

mixin GiveRatingWithImagesMixin on SelectMultipleImagesMixin {
  final TextEditingController reviewController = TextEditingController();
  RxDouble rating = 0.0.obs;
  Rx<RxStatus> giveRatingStatus = Rx<RxStatus>(RxStatus.empty());

  void clearFirelds() {
    reviewController.clear();
    rating.value = 0.0;
    imagePaths.clear();
  } 

  Future<bool> giveRating({
    required String saloonOwnerId,
    required String bookingId,
    required String barberId,
    String? userRole,
  }) async {
    try {
      EasyLoading.show(status: 'Submitting Review...');
      final Map<String, dynamic> payload = {
        'barberId': barberId,
        'saloonOwnerId': saloonOwnerId,
        'bookingId': bookingId,
        'rating': rating.value,
        'comment': reviewController.text,
      };
      // Add images to payload if any
      final List<MultipartBody> multipartBody = [];
      final reviewImages = imagePaths
          .where((file) => file.path.isNotEmpty && file.existsSync())
          .map((file) => MultipartBody('reviewImages', file))
          .toList();
      if (reviewImages.isNotEmpty) multipartBody.addAll(reviewImages);

      final response = await ApiClient.postMultipartData(
        ApiUrl.userGiveRating,
        {
          'bodyData': jsonEncode(payload),
        },
        multipartBody: multipartBody,
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        EasyLoading.showError('Failed to give rating');
        giveRatingStatus.value = RxStatus.error('Failed to give rating');
        return false;
      }

      EasyLoading.showSuccess('Review Submitted Successfully');
      return true;
    } catch (e) {
      EasyLoading.showError('Failed to give rating');
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }

  void clearReview() {
    reviewController.clear();
    imagePaths.clear();
  }
}
