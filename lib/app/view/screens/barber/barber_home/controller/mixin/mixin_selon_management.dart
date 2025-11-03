import 'dart:convert';

import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
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
      {required String userId, bool isFollowing = false}) async {
    // Optimistically update the follow status
    setIsFollowing();

    try {
      final response = this.isFollowing.value
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
}
