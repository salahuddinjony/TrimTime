import 'dart:convert';

import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/my_feed/model/feed_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin MixinFeedsManagement {

  //Get Feeds
 Rx<RxStatus> getFeedsStatus = Rx<RxStatus>(RxStatus.loading());
 RxList<FeedItem> homeFeedsList = RxList<FeedItem>();

  Future<void> getHomeFeeds() async {
    try {
      getFeedsStatus.value = RxStatus.loading();

      final response = await ApiClient.getData(
        ApiUrl.getHomeFeed,
      );
      if (response.statusCode == 200) {
        final responseData = response.body;
        final feedResponse = FeedResponse.fromJson(responseData);

        homeFeedsList.value = feedResponse.data;
        getFeedsStatus.value = RxStatus.success();
      } else {
        getFeedsStatus.value = RxStatus.error(
            "Failed to fetch feeds: ${response.statusCode} - ${response.statusText}");
      }
     
      debugPrint("Feeds fetched successfully");
    } catch (e) {
      debugPrint("Error fetching feeds: ${e.toString()}");
      getFeedsStatus.value =
          RxStatus.error("Error fetching feeds: ${e.toString()}");
    }finally {
      getFeedsStatus.refresh();
    }
  }

  //fav a feed
  Future<bool> toggleLikeFeed({required String feedId, required bool isUnlike}) async {
    try {
      // Find the feed in the list
      final feedIndex = homeFeedsList.indexWhere((feed) => feed.id == feedId);
      
      if (feedIndex != -1) {
        // Optimistically update UI immediately
        final oldIsFavorite = homeFeedsList[feedIndex].isFavorite;
        final oldFavoriteCount = homeFeedsList[feedIndex].favoriteCount ?? 0;
        
        homeFeedsList[feedIndex].isFavorite = isUnlike;
        homeFeedsList[feedIndex].favoriteCount = isUnlike 
            ? (oldFavoriteCount + 1) 
            : (oldFavoriteCount > 0 ? oldFavoriteCount - 1 : 0);
        homeFeedsList.refresh();
        
        // Make API call
        final response = isUnlike == false ? await ApiClient.deleteData(
          'https://barber-shift-app-4n3k.vercel.app/api/v1${ApiUrl.likeFeed}/$feedId', 
        ) : await ApiClient.postData(
          ApiUrl.likeFeed,
          jsonEncode({"feedId": feedId}),
        );
        
        if (response.statusCode == 200 || response.statusCode == 201) {
          debugPrint("Feed liked successfully");
          return true;
        } else {
          // Revert changes on failure
          if (feedIndex != -1 && feedIndex < homeFeedsList.length) {
            homeFeedsList[feedIndex].isFavorite = oldIsFavorite;
            homeFeedsList[feedIndex].favoriteCount = oldFavoriteCount;
            homeFeedsList.refresh();
          }
          debugPrint(
              "Failed to like feed: ${response.statusCode} - ${response.statusText}");
          return false;
        }
      } else {
        // Feed not found in list, just make API call
        final response = isUnlike == false ? await ApiClient.deleteData(
          'https://barber-shift-app-4n3k.vercel.app/api/v1${ApiUrl.likeFeed}/$feedId', 
        ) : await ApiClient.postData(
          ApiUrl.likeFeed,
          jsonEncode({"feedId": feedId}),
        );
        
        if (response.statusCode == 200 || response.statusCode == 201) {
          debugPrint("Feed liked successfully");
          return true;
        } else {
          debugPrint(
              "Failed to like feed: ${response.statusCode} - ${response.statusText}");
          return false;
        }
      }
    } catch (e) {
      // Revert changes on error
      final feedIndex = homeFeedsList.indexWhere((feed) => feed.id == feedId);
      if (feedIndex != -1) {
        homeFeedsList[feedIndex].isFavorite = !isUnlike;
        final currentCount = homeFeedsList[feedIndex].favoriteCount ?? 0;
        homeFeedsList[feedIndex].favoriteCount = isUnlike 
            ? (currentCount > 0 ? currentCount - 1 : 0)
            : (currentCount + 1);
        homeFeedsList.refresh();
      }
      debugPrint("Error liking feed: ${e.toString()}");
      return false;
    }
  }
}