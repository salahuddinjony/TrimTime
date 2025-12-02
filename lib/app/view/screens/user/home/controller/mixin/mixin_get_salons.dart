import 'dart:convert';

import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/view/screens/user/home/controller/user_home_controller.dart';
import 'package:barber_time/app/view/screens/user/home/models/selons_models/get_selons_data.dart';
import 'package:get/get.dart';

mixin MixinGetSalons {
  RxList<Saloon> allSaloons = <Saloon>[].obs;
  RxList<Saloon> searchesSaloons = <Saloon>[].obs;
  RxList<Saloon> nearbySaloons = <Saloon>[].obs;
  RxList<Saloon> topRatedSaloons = <Saloon>[].obs;

  Rx<RxStatus> fetchStatus = Rx<RxStatus>(RxStatus.loading());

  Future<void> fetchSelons(
      {tags? tag, double? lat, double? lng, String? searchQuery}) async {
    try {
      fetchStatus.value = RxStatus.loading();
      final Map<String, dynamic> queryParameters = {
        'page': '1',
        'limit': '100',
      };

      if (tag != null) {
        if (tag == tags.topRated) {
          queryParameters['topRated'] = '1';
        } else if (tag == tags.nearby) {
          queryParameters['latitude'] = lat?.toString() ?? '23.9323';
          queryParameters['longitude'] = lng?.toString() ?? '90.4170';
        } else if (tag == tags.searches) {
          queryParameters['searchTerm'] = searchQuery!;
        }
      }
      final response = await ApiClient.getData(
        ApiUrl.fetchSelon,
        query: queryParameters.isNotEmpty ? queryParameters : null,
      );

      if (response.statusCode == 200) {
        final data = response.body;
        final salonsData = GetSelonsDataResponse.fromJson(data);
        if (tag == tags.topRated) {
          topRatedSaloons.value = salonsData.data;
        } else if (tag == tags.nearby) {
          nearbySaloons.value = salonsData.data;
        } else if (tag == tags.searches) {
          searchesSaloons.value = salonsData.data;
        } else {
          allSaloons.value = salonsData.data;
        }
        fetchStatus.value = RxStatus.success();
      }
    } catch (e) {
      print("Error fetching salons: $e");
    } finally {}
  }

  //favorite sallon toggle

  Future<void> toggleFavoriteSalon(
      {required String salonId,
      required bool isFavorite,
      required int index,
      required tags tag}) async {
    try {
      // Optimistically update UI immediately in the specific list by index
      if (tag == tags.topRated) {
        if (index >= 0 && index < topRatedSaloons.length) {
          topRatedSaloons[index].isFavorite =
              !topRatedSaloons[index].isFavorite;
        }
      } else if (tag == tags.nearby) {
        if (index >= 0 && index < nearbySaloons.length) {
          nearbySaloons[index].isFavorite = !nearbySaloons[index].isFavorite;
        }
      } else if (tag == tags.searches) {
        if (index >= 0 && index < searchesSaloons.length) {
          searchesSaloons[index].isFavorite =
              !searchesSaloons[index].isFavorite;
        }
      }
      // Note: customerReviews list is handled separately in its own mixin

      // Also update the same salon in ALL other lists (by userId)
      for (var salon in nearbySaloons) {
        if (salon.userId == salonId) {
          salon.isFavorite = !isFavorite;
        }
      }
      for (var salon in topRatedSaloons) {
        if (salon.userId == salonId) {
          salon.isFavorite = !isFavorite;
        }
      }
      for (var salon in searchesSaloons) {
        if (salon.userId == salonId) {
          salon.isFavorite = !isFavorite;
        }
      }
      for (var salon in allSaloons) {
        if (salon.userId == salonId) {
          salon.isFavorite = !isFavorite;
        }
      }

      // Force UI update for all lists
      nearbySaloons.refresh();
      topRatedSaloons.refresh();
      searchesSaloons.refresh();
      allSaloons.refresh();

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
        // Revert the change in the specific list by index
        if (tag == tags.topRated) {
          if (index >= 0 && index < topRatedSaloons.length) {
            topRatedSaloons[index].isFavorite =
                !topRatedSaloons[index].isFavorite;
          }
        } else if (tag == tags.nearby) {
          if (index >= 0 && index < nearbySaloons.length) {
            nearbySaloons[index].isFavorite = !nearbySaloons[index].isFavorite;
          }
        } else if (tag == tags.searches) {
          if (index >= 0 && index < searchesSaloons.length) {
            searchesSaloons[index].isFavorite =
                !searchesSaloons[index].isFavorite;
          }
        }

        // Also revert in ALL other lists
        for (var salon in nearbySaloons) {
          if (salon.userId == salonId) {
            salon.isFavorite = isFavorite;
          }
        }
        for (var salon in topRatedSaloons) {
          if (salon.userId == salonId) {
            salon.isFavorite = isFavorite;
          }
        }
        for (var salon in searchesSaloons) {
          if (salon.userId == salonId) {
            salon.isFavorite = isFavorite;
          }
        }
        for (var salon in allSaloons) {
          if (salon.userId == salonId) {
            salon.isFavorite = isFavorite;
          }
        }

        // Force UI update after revert
        nearbySaloons.refresh();
        topRatedSaloons.refresh();
        searchesSaloons.refresh();
        allSaloons.refresh();
      }
    } catch (e) {
      print("Error toggling favorite salon: $e");
      // Revert on error
      if (tag == tags.topRated) {
        if (index >= 0 && index < topRatedSaloons.length) {
          topRatedSaloons[index].isFavorite =
              !topRatedSaloons[index].isFavorite;
        }
      } else if (tag == tags.nearby) {
        if (index >= 0 && index < nearbySaloons.length) {
          nearbySaloons[index].isFavorite = !nearbySaloons[index].isFavorite;
        }
      } else if (tag == tags.searches) {
        if (index >= 0 && index < searchesSaloons.length) {
          searchesSaloons[index].isFavorite =
              !searchesSaloons[index].isFavorite;
        }
      }

      // Also revert in ALL other lists
      for (var salon in nearbySaloons) {
        if (salon.userId == salonId) {
          salon.isFavorite = isFavorite;
        }
      }
      for (var salon in topRatedSaloons) {
        if (salon.userId == salonId) {
          salon.isFavorite = isFavorite;
        }
      }
      for (var salon in searchesSaloons) {
        if (salon.userId == salonId) {
          salon.isFavorite = isFavorite;
        }
      }
      for (var salon in allSaloons) {
        if (salon.userId == salonId) {
          salon.isFavorite = isFavorite;
        }
      }

      // Force UI update after revert
      nearbySaloons.refresh();
      topRatedSaloons.refresh();
      searchesSaloons.refresh();
      allSaloons.refresh();
    }
  }
}
