import 'dart:convert';

import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/view/common_widgets/show_custom_snackbar/show_custom_snackbar.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/rate/models/review_response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin MixinGetReviews {
    final RxList<ReviewData> barberReviews = <ReviewData>[].obs;
    final RxBool isLoadingReviews = false.obs;
      Future<void> getBarberReviews({String? userId}) async {
    try {
      isLoadingReviews.value = true;
      final url = userId != null
          ? '${ApiUrl.getBarberReviews}/saloon/$userId'
          : ApiUrl.getBarberReviews;
      final response = await ApiClient.getData(url);

      if (response.statusCode == 200) {
        final body =
            response.body is String ? jsonDecode(response.body) : response.body;
        final resp = ReviewResponse.fromJson(body as Map<String, dynamic>);
        barberReviews.value = resp.data;
        debugPrint("Barber Reviews data length: ${barberReviews.length}");
        debugPrint("Barber Reviews Data: ${barberReviews}");
      } else {
        debugPrint(
            "Failed to load reviews: ${response.statusCode} - ${response.statusText}");
        toastMessage(message: response.statusText ?? 'Failed to load reviews');
      }
    } catch (e) {
      debugPrint("Error fetching reviews: ${e.toString()}");
      toastMessage(message: 'Failed to load reviews');
    } finally {
      isLoadingReviews.value = false;
  
    }
  }
}