import 'dart:convert';
import 'dart:io';

import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/pixmatch/models/analyze_salon_response.dart';
import 'package:barber_time/app/view/screens/user/home/models/selons_models/get_selons_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin MixinAnalyzeSalon {
  RxList<Saloon> analyzedSaloons = <Saloon>[].obs;
  Rx<RxStatus> analyzeStatus = Rx<RxStatus>(RxStatus.empty());

  Future<AnalyzeSalonResponse?> analyzeSalon({
    required String imagePath,
    required double latitude,
    required double longitude,
  }) async {
    try {
      analyzeStatus.value = RxStatus.loading();

      final response = await ApiClient.postMultipartData(
        ApiUrl.analyzeSaloon,
        {
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
        },
        multipartBody: [
          MultipartBody('image', File(imagePath)),
        ],
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.body;
        if (responseData is String) {
          final jsonData = jsonDecode(responseData);
          final analyzeResponse = AnalyzeSalonResponse.fromJson(jsonData);
          
          analyzedSaloons.value = analyzeResponse.data.nearestSaloons;
          analyzeStatus.value = RxStatus.success();
          
          return analyzeResponse;
        } else {
          final analyzeResponse = AnalyzeSalonResponse.fromJson(responseData);
          
          analyzedSaloons.value = analyzeResponse.data.nearestSaloons;
          analyzeStatus.value = RxStatus.success();
          
          return analyzeResponse;
        }
      } else {
        analyzeStatus.value = RxStatus.error(response.statusText ?? 'Failed to analyze salon');
        debugPrint('Error analyzing salon: ${response.statusCode} - ${response.statusText}');
        return null;
      }
    } catch (e) {
      analyzeStatus.value = RxStatus.error('Error analyzing salon: $e');
      debugPrint('Error analyzing salon: $e');
      return null;
    }
  }
}

