import 'dart:convert';
import 'package:barber_time/app/data/local/shared_prefs.dart';
import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/view/common_widgets/show_custom_snackbar/show_custom_snackbar.dart';
import 'package:barber_time/app/view/screens/barber/barber_feed/controller/mixin_barber_crud.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/settings/faq/models/faq_model.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/settings/info_controller/mixin/mixin_get_all_my_fav.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/settings/info_controller/mixin/mixin_get_revires.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/settings/privacy_policy/models/privacy_model.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/settings/terms/models/terms_model.dart';
import 'package:barber_time/app/view/screens/barber/barber_que_screen/model/barber_queue_capacity_model.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class InfoController extends GetxController
    with BarberFeedCRUDMixin, MixinGetAllMyFav, MixinGetReviews {
  var selectedIndex = Rx<int?>(null);

// Toggle the selected FAQ item
  void toggleItem(int index) {
    selectedIndex.value = selectedIndex.value == index ? null : index;
  }

  final RxList<FaqItem> faqs = <FaqItem>[].obs;
  final RxList<TermItem> terms = <TermItem>[].obs;
  final RxList<PrivacyItem> privacyPolicy = <PrivacyItem>[].obs;

  final RxList<BarberQueueCapacityData> barberQueueCapacity =
      <BarberQueueCapacityData>[].obs;

  @override
  void onInit() async {
    super.onInit();
    final userRole = await SharePrefsHelper.getString(AppConstants.role);
    debugPrint("User Role in InfoController: $userRole");

    if (userRole != 'CUSTOMER') {
      initialFunctions();
    }

    fetchFaqs();
    fetchTerms();
    fetchPrivacyPolicy();

    // getAllFeeds();
  }

  void initialFunctions() {
    getBarberReviews();
    fetchAllFavourite();
    fetchBarberQueueCapacity();
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
