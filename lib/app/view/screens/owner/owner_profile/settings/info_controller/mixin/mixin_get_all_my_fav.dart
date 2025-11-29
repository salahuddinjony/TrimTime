import 'dart:convert';

import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/view/common_widgets/show_custom_snackbar/show_custom_snackbar.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/my_favorite/models/favorite_feed_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin MixinGetAllMyFav {
  final RxList<FavoriteFeedItem> favoriteItems = <FavoriteFeedItem>[].obs;
  final RxBool isLoading = false.obs;
  Future<void> fetchAllFavourite() async {
    try {
      isLoading.value = true;
      final response = await ApiClient.getData(ApiUrl.getMyAllFavourites);

      if (response.statusCode == 200) {
        final body =
            response.body is String ? jsonDecode(response.body) : response.body;
        final resp =
            FavoriteFeedResponse.fromJson(body as Map<String, dynamic>);
        favoriteItems.value = resp.data?.data ?? [];
        debugPrint("Favorite items length: ${favoriteItems.length}");
        debugPrint("Favorite Items Data: ${favoriteItems}");
      } else {
        toastMessage(
            message: response.statusText ?? 'Failed to load favorites');
      }
    } catch (e) {
      toastMessage(message: 'Failed to load favorites');
    } finally {
      isLoading.value = false;
    }
  }
}
