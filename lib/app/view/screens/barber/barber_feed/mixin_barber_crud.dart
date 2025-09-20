import 'dart:convert';
import 'dart:io';

import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/view/common_widgets/show_custom_snackbar/show_custom_snackbar.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/my_feed/model/feed_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

mixin BarberFeedCRUDMixin on GetxController {
  var imagepath = ''.obs;
  var isNetworkImage = false.obs;
  /// When editing an existing feed, this becomes true if the user clears
  /// the original network image. The UI should not show the original
  /// image after the user explicitly cleared it.
  var clearedInitialImage = false.obs;


  RxList<FeedItem> allFeeds = <FeedItem>[].obs;
  RxBool isLoadingFeeds = false.obs;

  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();
      final XFile? result = await picker.pickImage(source: ImageSource.gallery);
      if (result != null) {
        imagepath.value = result.path;
        isNetworkImage.value = false;
        // If user picks a new local image, reset the cleared flag so preview
        // will show the newly picked image.
        clearedInitialImage.value = false;
        debugPrint("Picked image path: ${imagepath.value.toString()}");
      }
    } catch (e) {
      debugPrint("Error picking image: ${e.toString()}");
      toastMessage(message: 'Failed to pick image');
    }
  }

  void clearImage() {
    imagepath.value = '';
    // If the current path was a network image (edit mode) mark it as
    // cleared so the UI doesn't fall back to showing the original feed
    // image. Also ensure we don't treat the cleared state as a network
    // image when uploading.
    clearedInitialImage.value = true;
    isNetworkImage.value = false;
  }

  Future<void> getAllFeeds() async {
    try {
      isLoadingFeeds.value = true;
      final response = await ApiClient.getData(ApiUrl.getAllFeed);

      if (response.statusCode == 200) {
        final body =
            response.body is String ? jsonDecode(response.body) : response.body;
        final resp = FeedResponse.fromJson(body as Map<String, dynamic>);
        allFeeds.value = resp.data;
        debugPrint("All Feeds data length: ${allFeeds.length}");
        debugPrint("All Feeds Data: ${allFeeds}");
      } else {
        debugPrint(
            "Failed to load all feeds: ${response.statusCode} - ${response.statusText}");
        toastMessage(
            message: response.statusText ?? 'Failed to load all feeds');
      }
    } catch (e) {
      debugPrint("Error fetching all feeds: ${e.toString()}");
      toastMessage(message: 'Failed to load all feeds');
    } finally {
      isLoadingFeeds.value = false;
    }
  }
  void toggleFavorite(String id) {
    final idx = allFeeds.indexWhere((f) => f.id == id);
    if (idx != -1) {
      final item = allFeeds[idx];
      final current = item.favoriteCount ?? 0;
      final updated = FeedItem(
        id: item.id,
        userId: item.userId,
        userName: item.userName,
        userImage: item.userImage,
        saloonOwner: item.saloonOwner,
        caption: item.caption,
        images: item.images,
        favoriteCount: current > 0 ? 0 : (current + 1),
      );
      allFeeds[idx] = updated;
    }
  }

  Future<bool> createFeed({
    required String caption,
  }) async {
    try {
      if (caption.isEmpty || imagepath.value.isEmpty) {
        EasyLoading.showInfo('Caption or image is required');
        return false;
      }
      EasyLoading.show(status: 'Creating...');

      final body = <String, dynamic>{'caption': caption};

      final response = await ApiClient.postMultipartData(
        ApiUrl.createFeed,
        {
          'bodyData': jsonEncode(body),
        },
        multipartBody: [
          if (imagepath.value.isNotEmpty && !isNetworkImage.value)
            MultipartBody(
              'images',
              File(imagepath.value),
            ),
        ],
      );
      if (response.statusCode == 201) {
        EasyLoading.showSuccess('Feed created');
        toastMessage(message: 'Feed created successfully');
        await getAllFeeds();
        imagepath.value = '';
        return true;
      } else {
        EasyLoading.showError('Failed to create feed');
        debugPrint(
            "Failed to create feed: ${response.statusCode} - ${response.statusText}");
        return false;
      }
    } catch (e) {
      EasyLoading.showError('Error creating feed');
      debugPrint("Error creating feed: ${e.toString()}");
      toastMessage(message: e.toString());
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<bool> updateFeed({
    required String caption,
    required String feedId,
  }) async {
    try {
      if ((caption.isEmpty) &&
          (imagepath.value.isEmpty)) {
        throw 'Caption or image is required';
      }
      EasyLoading.show(status: 'Updating...');
      final body = <String, dynamic>{'caption': caption};

    debugPrint("Update Feed Body: $body");
    debugPrint("My api url: ${ApiUrl.updateFeed(id: feedId)}");

      final response = await ApiClient.patchMultipart(
        ApiUrl.updateFeed(id: feedId),
        {
          'bodyData': jsonEncode(body),
          
        },
         multipartBody: [
            if (imagepath.value.isNotEmpty)
              MultipartBody( 
                'images',
                File(imagepath.value),
              ),
        ],
      );

      if (response.statusCode == 200) {
        EasyLoading.showSuccess('Feed updated');
        await getAllFeeds(); 
        imagepath.value = '';
        return true;
      
      } else {
        EasyLoading.showError('Failed to update feed');
        debugPrint(
            "Failed to update feed: ${response.statusCode} - ${response.statusText}");
        return false;
      }
    } catch (e) {
      EasyLoading.showError('Error updating feed');
      debugPrint("Error updating feed: ${e.toString()}");
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> deleteFeed(String id) async {
    try {
      EasyLoading.show(status: 'Deleting...');
      final url = ApiUrl.deleteFeed(id: id);
      final response = await ApiClient.deleteData(url);

      if (response.statusCode == 200) {
        await getAllFeeds(); 
        EasyLoading.showSuccess('Feed deleted');
        toastMessage(message: 'Feed deleted successfully');
        // Optionally, you can remove the feed from a local list if you have one
      } else {
        EasyLoading.showError('Failed to delete feed');
        debugPrint(
            "Failed to delete feed: ${response.statusCode} - ${response.statusText}");
        throw response.statusText ?? 'Failed to delete feed';
      }
    } catch (e) {
      EasyLoading.showError('Error deleting feed');
      debugPrint("Error deleting feed: ${e.toString()}");
      toastMessage(message: e.toString());
    } finally {
      EasyLoading.dismiss();
    }
  }
}
