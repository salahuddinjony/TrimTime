import 'dart:convert';

import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/controller/mixin/mixin_seloon_mng/models/get_seloons_services.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/models/selon_model/single_selon_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin MixinSelonManagement {
  Rx<RxStatus> getSelonStatus = Rx<RxStatus>(RxStatus.loading());

  Rxn<SingleSaloonModel> selonList = Rxn<SingleSaloonModel>();

  Future<void> getSelonData({String? userId}) async {
    try {
      getSelonStatus.value = RxStatus.loading();

      final response = await ApiClient.getData(
        ApiUrl.getSelonData(userId: userId),
      );
      if (response.statusCode == 200) {
        final responseData = response.body;
        final selonData = SingleSaloonModel.fromJson(responseData);

        selonList.value = selonData;
        // Set isFollowing after data is successfully fetched
        isFollowing.value = selonData.isFollowing;
        getSelonStatus.value = RxStatus.success();
      } else {
        getSelonStatus.value = RxStatus.error(
            "Failed to fetch selon data: ${response.statusCode} - ${response.statusText}");
      }

      debugPrint("Selon data fetched successfully");
    } catch (e) {
      debugPrint("Error fetching selon data: ${e.toString()}");
      getSelonStatus.value =
          RxStatus.error("Error fetching selon data: ${e.toString()}");
    } finally {
      getSelonStatus.refresh();
    }
  }

  RxBool isFollowing = false.obs;

  void setIsFollowing() {
    debugPrint("isFollowing before toggle: ${this.isFollowing.value}");
    isFollowing.value = !isFollowing.value;
    debugPrint("isFollowing after toggle: ${this.isFollowing.value}");
  }

  Future<bool> toggleFollow(
      {required String userId,
      bool isFollowing = false,
      bool isfollowUnfollow = true}) async {
    // Optimistically update the follow status
    if (isfollowUnfollow) {
      setIsFollowing();
    }

    try {
      final response =
          (this.isFollowing.value == true && isfollowUnfollow == true)
              ? await ApiClient.postData(
                  ApiUrl.toggleFollowSalon,
                  jsonEncode({"followingId": userId}),
                )
              : await ApiClient.deleteData(
                  ApiUrl.makeUnfollow(id: userId),
                );

      if (response.statusCode == 200) {
        return true;
      } else {
        debugPrint(
            "Failed to toggle follow status: ${response.statusCode} - ${response.statusText}");
        return false;
      }
    } catch (e) {
      debugPrint("Error toggling follow status: ${e.toString()}");
      return false;
    } finally {}
  }

  // create booking for selon
  RxList<String> selectedServicesIds = <String>[].obs;


  void addOrRemoveServiceId(String serviceId) {
    if (selectedServicesIds.contains(serviceId)) {
      selectedServicesIds.remove(serviceId);
    } else {
      selectedServicesIds.add(serviceId);
    }
    selectedServicesIds.refresh();
  }


  // get selons service list
  RxList<SaloonService> selonServicesList = <SaloonService>[].obs;
  Rx<RxStatus> getSelonServicesStatus = Rx<RxStatus>(RxStatus.loading());

  Future<void> fetchSelonServices({String? userId}) async {
    try {
      getSelonServicesStatus.value = RxStatus.loading();

      final response = await ApiClient.getData(
        ApiUrl.getSelonServices(userId: userId),
      );
      if (response.statusCode == 200) {
        final responseData = response.body;
        final servicesData =
            GetSeloonsServicesResponse.fromJson(responseData).data;

        selonServicesList.value = servicesData;
        getSelonServicesStatus.value = RxStatus.success();
      } else {
        getSelonServicesStatus.value = RxStatus.error(
            "Failed to fetch selon services: ${response.statusCode} - ${response.statusText}");
      }

      debugPrint("Selon services fetched successfully");
    } catch (e) {
      debugPrint("Error fetching selon services: ${e.toString()}");
      getSelonServicesStatus.value =
          RxStatus.error("Error fetching selon services: ${e.toString()}");
    } finally {
      getSelonServicesStatus.refresh();
    }
  }

  // // get selons available barbers free slot based on seledted date
  // RxList<dynamic> selonBarbersList = <dynamic>[].obs;
  // Rx<RxStatus> getSelonBarbersStatus = Rx<RxStatus>(RxStatus.loading());

  // Future<void> fetchSelonBarbers({String? userId}) async {
  //   try {
  //     getSelonBarbersStatus.value = RxStatus.loading();

  //     final response = await ApiClient.getData(
  //       ApiUrl.getSelonAvailableBarbers(userId: userId),
  //     );
  //     if (response.statusCode == 200) {
  //       final responseData = response.body;
  //       final barbersData = responseData['barbers'] as List<dynamic>;

  //       selonBarbersList.value = barbersData;
  //       getSelonBarbersStatus.value = RxStatus.success();
  //     } else {
  //       getSelonBarbersStatus.value = RxStatus.error(
  //           "Failed to fetch selon barbers: ${response.statusCode} - ${response.statusText}");
  //     }

  //     debugPrint("Selon barbers fetched successfully");
  //   } catch (e) {
  //     debugPrint("Error fetching selon barbers: ${e.toString()}");
  //     getSelonBarbersStatus.value =
  //         RxStatus.error("Error fetching selon barbers: ${e.toString()}");
  //   } finally {
  //     getSelonBarbersStatus.refresh();
  //   }
  // }

  // // get selons available barbers list based on the selected service
  // RxList<dynamic> selonAvailableBarbersList = <dynamic>[].obs;
  // Rx<RxStatus> getSelonAvailableBarbersStatus =
  //     Rx<RxStatus>(RxStatus.loading());

  // Future<void> fetchSelonAvailableBarbers(
  //     {String? userId, String? serviceId}) async {
  //   try {
  //     getSelonAvailableBarbersStatus.value = RxStatus.loading();

  //     final response = await ApiClient.getData(
  //       ApiUrl.getSelonAvailableBarbers(userId: userId, serviceId: serviceId),
  //     );
  //     if (response.statusCode == 200) {
  //       final responseData = response.body;
  //       final availableBarbersData =
  //           responseData['availableBarbers'] as List<dynamic>;

  //       selonAvailableBarbersList.value = availableBarbersData;
  //       getSelonAvailableBarbersStatus.value = RxStatus.success();
  //     } else {
  //       getSelonAvailableBarbersStatus.value = RxStatus.error(
  //           "Failed to fetch available barbers: ${response.statusCode} - ${response.statusText}");
  //     }

  //     debugPrint("Available barbers fetched successfully");
  //   } catch (e) {
  //     debugPrint("Error fetching available barbers: ${e.toString()}");
  //     getSelonAvailableBarbersStatus.value =
  //         RxStatus.error("Error fetching available barbers: ${e.toString()}");
  //   } finally {
  //     getSelonAvailableBarbersStatus.refresh();
  //   }
  // }

  // // get selons available time slots based on the selected barber and date
  // RxList<dynamic> selonAvailableBarbersFreeSlotsList = <dynamic>[].obs;
  // Rx<RxStatus> getSelonAvailableBarbersFreeSlotsStatus =
  //     Rx<RxStatus>(RxStatus.loading());
}
