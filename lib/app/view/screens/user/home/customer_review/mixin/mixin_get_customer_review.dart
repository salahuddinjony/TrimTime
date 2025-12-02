import 'dart:convert';

import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/view/screens/user/home/customer_review/models/customer_review_models.dart';
import 'package:get/get.dart';

mixin MixinGetCustomerReview {
  RxList<CustomerReviewData> customerReviewsList =
      RxList<CustomerReviewData>([]);
  Rx<RxStatus> customerReviewStatus = Rx<RxStatus>(RxStatus.empty());

  Future<void> fetchCustomerReviews() async {
    try {
      customerReviewStatus.value = RxStatus.loading();

      final response = await ApiClient.getData(
        ApiUrl.getCustomerReviews,
      );

      if (response.statusCode == 200) {
        final responseData = response.body;
        // Parse the response using the model
        final data = CustomerReviewResponse.fromJson(responseData);
        customerReviewsList.value = data.data;
        customerReviewStatus.value = RxStatus.success();
      } else {
        customerReviewStatus.value = RxStatus.error(
            "Failed to fetch customer reviews: ${response.statusCode} - ${response.statusText}");
      }
    } catch (e) {
      customerReviewStatus.value = RxStatus.error(e.toString());
    }
  }

  Future<void> toggleCustomerReviewFavorite({
    required String salonId,
    required bool isFavorite,
    required int index,
  }) async {
    // This method needs access to other salon lists from MixinGetSalons
    // We'll update them dynamically if they exist
    dynamic controller = this;

    try {
      // Optimistically update UI immediately in customer reviews list
      if (index >= 0 && index < customerReviewsList.length) {
        customerReviewsList[index].isFavorite =
            !customerReviewsList[index].isFavorite;
        customerReviewsList.refresh();
      }

      // Also update the same salon in ALL other lists (if they exist)
      // This handles the case where the controller has MixinGetSalons
      try {
        if (controller.nearbySaloons != null) {
          for (var salon in controller.nearbySaloons) {
            if (salon.userId == salonId) {
              salon.isFavorite = !isFavorite;
            }
          }
          controller.nearbySaloons.refresh();
        }
      } catch (e) {
        // Ignore if nearbySaloons doesn't exist
      }

      try {
        if (controller.topRatedSaloons != null) {
          for (var salon in controller.topRatedSaloons) {
            if (salon.userId == salonId) {
              salon.isFavorite = !isFavorite;
            }
          }
          controller.topRatedSaloons.refresh();
        }
      } catch (e) {
        // Ignore if topRatedSaloons doesn't exist
      }

      try {
        if (controller.searchesSaloons != null) {
          for (var salon in controller.searchesSaloons) {
            if (salon.userId == salonId) {
              salon.isFavorite = !isFavorite;
            }
          }
          controller.searchesSaloons.refresh();
        }
      } catch (e) {
        // Ignore if searchesSaloons doesn't exist
      }

      try {
        if (controller.allSaloons != null) {
          for (var salon in controller.allSaloons) {
            if (salon.userId == salonId) {
              salon.isFavorite = !isFavorite;
            }
          }
          controller.allSaloons.refresh();
        }
      } catch (e) {
        // Ignore if allSaloons doesn't exist
      }

      final url = ApiUrl.toggleFavoriteSalon;
      final response = isFavorite
          ? await ApiClient.deleteData(
              "${ApiUrl.baseUrl}$url/$salonId",
            )
          : await ApiClient.postData(
              url,
              jsonEncode({"saloonId": salonId}),
            );

      if (response.statusCode != 200) {
        // Revert the change on error in customer reviews list
        if (index >= 0 && index < customerReviewsList.length) {
          customerReviewsList[index].isFavorite =
              !customerReviewsList[index].isFavorite;
          customerReviewsList.refresh();
        }

        // Revert in all other lists
        try {
          if (controller.nearbySaloons != null) {
            for (var salon in controller.nearbySaloons) {
              if (salon.userId == salonId) {
                salon.isFavorite = isFavorite;
              }
            }
            controller.nearbySaloons.refresh();
          }
        } catch (e) {}

        try {
          if (controller.topRatedSaloons != null) {
            for (var salon in controller.topRatedSaloons) {
              if (salon.userId == salonId) {
                salon.isFavorite = isFavorite;
              }
            }
            controller.topRatedSaloons.refresh();
          }
        } catch (e) {}

        try {
          if (controller.searchesSaloons != null) {
            for (var salon in controller.searchesSaloons) {
              if (salon.userId == salonId) {
                salon.isFavorite = isFavorite;
              }
            }
            controller.searchesSaloons.refresh();
          }
        } catch (e) {}

        try {
          if (controller.allSaloons != null) {
            for (var salon in controller.allSaloons) {
              if (salon.userId == salonId) {
                salon.isFavorite = isFavorite;
              }
            }
            controller.allSaloons.refresh();
          }
        } catch (e) {}
      }
    } catch (e) {
      print("Error toggling favorite for customer review: $e");
      // Revert on error
      if (index >= 0 && index < customerReviewsList.length) {
        customerReviewsList[index].isFavorite =
            !customerReviewsList[index].isFavorite;
        customerReviewsList.refresh();
      }
    }
  }
}
