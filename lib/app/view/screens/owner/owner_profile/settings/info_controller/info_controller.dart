import 'dart:convert';

import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/view/common_widgets/show_custom_snackbar/show_custom_snackbar.dart';
import 'package:barber_time/app/view/screens/barber/barber_feed/controller/mixin_barber_crud.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/my_favorite/models/favorite_feed_model.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/rate/models/review_response_model.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/settings/faq/models/faq_model.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/settings/privacy_policy/models/privacy_model.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/settings/terms/models/terms_model.dart';
import 'package:barber_time/app/view/screens/barber/barber_que_screen/model/barber_queue_capacity_model.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class InfoController extends GetxController with BarberFeedCRUDMixin {
  var selectedIndex = Rx<int?>(null);

// Toggle the selected FAQ item
  void toggleItem(int index) {
    selectedIndex.value = selectedIndex.value == index ? null : index;
  }

  final RxList<FaqItem> faqs = <FaqItem>[].obs;
  final RxList<TermItem> terms = <TermItem>[].obs;
  final RxList<PrivacyItem> privacyPolicy = <PrivacyItem>[].obs;
  final RxList<ReviewData> barberReviews = <ReviewData>[].obs;
  final RxList<FavoriteFeedItem> favoriteItems = <FavoriteFeedItem>[].obs;
  final RxList<BarberQueueCapacityData> barberQueueCapacity =
      <BarberQueueCapacityData>[].obs;

  final RxBool isLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
    fetchFaqs();
    fetchTerms();
    fetchPrivacyPolicy();
    getBarberReviews();
    fetchAllFavourite();
    fetchBarberQueueCapacity();
    // getAllFeeds();
  }

  Future<void> fetchFaqs() async {
    try {
      isLoading.value = true;
      final response = await ApiClient.getData(
        ApiUrl.getFaqs,
      );

      if (response.statusCode == 200) {
        final body =
            response.body is String ? jsonDecode(response.body) : response.body;
        final resp = FaqResponse.fromJson(body as Map<String, dynamic>);
        faqs.value = resp.data;
      } else {
        ApiClient.handleResponse;
        toastMessage(message: response.statusText ?? 'Failed to load faqs');
      }
    } catch (e) {
      toastMessage(message: 'Failed to load faqs');
    } finally {
      isLoading.value = false;
      refresh();
    }
  }

  Future<void> fetchTerms() async {
    try {
      isLoading.value = true;
      final response = await ApiClient.getData(ApiUrl.termsAndCondition);

      if (response.statusCode == 200) {
        final body =
            response.body is String ? jsonDecode(response.body) : response.body;
        final resp = TermsResponse.fromJson(body as Map<String, dynamic>);
        terms.value = resp.data;
      } else {
        toastMessage(message: response.statusText ?? 'Failed to load terms');
      }
    } catch (e) {
      toastMessage(message: 'Failed to load terms');
    } finally {
      isLoading.value = false;
      refresh();
    }
  }

  Future<void> fetchPrivacyPolicy() async {
    try {
      isLoading.value = true;
      final response = await ApiClient.getData(ApiUrl.privacyPolicy);

      if (response.statusCode == 200) {
        final body =
            response.body is String ? jsonDecode(response.body) : response.body;
        final resp = TermsResponse.fromJson(body as Map<String, dynamic>);
        terms.value = resp.data;
      } else {
        toastMessage(
            message: response.statusText ?? 'Failed to load privacy policy');
      }
    } catch (e) {
      debugPrint("Error fetching privacy policy: ${e.toString()}");
      toastMessage(message: 'Failed to load privacy policy');
    } finally {
      isLoading.value = false;
      refresh();
    }
  }

  Future<void> getBarberReviews() async {
    try {
      isLoading.value = true;
      final response = await ApiClient.getData(ApiUrl.getBarberReviews);

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
      isLoading.value = false;
      refresh();
    }
  }

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
      refresh();
    }
  }

  Future<void> fetchBarberQueueCapacity() async {
    try {
      isLoading.value = true;
      final response = await ApiClient.getData(ApiUrl.BarberQueueCapacity);

      if (response.statusCode == 200) {
        final body =
            response.body is String ? jsonDecode(response.body) : response.body;
        final resp =
            BarberQueueCapacityResponse.fromJson(body as Map<String, dynamic>);
        barberQueueCapacity.value = resp.data;
        debugPrint(
            "Barber Queue Capacity data length: ${barberQueueCapacity.length}");
        debugPrint("Barber Queue Capacity Data: ${barberQueueCapacity}");
      } else {
        debugPrint(
            "Failed to load barber queue capacity: ${response.statusCode} - ${response.statusText}");
        toastMessage(
            message:
                response.statusText ?? 'Failed to load barber queue capacity');
      }
    } catch (e) {
      debugPrint("Error fetching barber queue capacity: ${e.toString()}");
      toastMessage(message: 'Failed to load barber queue capacity');
    } finally {
      isLoading.value = false;
      refresh();
    }
  }
}
