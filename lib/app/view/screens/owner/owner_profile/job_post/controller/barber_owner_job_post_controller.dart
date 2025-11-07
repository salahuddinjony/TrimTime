import 'dart:io';
import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/view/common_widgets/show_custom_snackbar/show_custom_snackbar.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/job_post/model/barber_owner_job_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class BarberOwnerJobPostController extends GetxController {
  RxList<JobPostData> barberJobPosts = <JobPostData>[].obs;
  Rx<RxStatus> barberJobPostStatus = Rx<RxStatus>(RxStatus.empty());

  RxString imagePath = ''.obs;
  RxBool isNetworkImage = false.obs;
  var clearedInitialImage = false.obs;

  // Form controllers for create/edit job post
  final dateController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final rateController = TextEditingController();
  final shopNameController = TextEditingController();
  final shopLogoController = TextEditingController();
  final descriptionController = TextEditingController();

  Rx<JobPostData?> selectedJobPost = Rx<JobPostData?>(null);
  RxBool isEditMode = false.obs;
  RxBool isFormLoaded = false.obs;
  String? _currentJobId;

  void loadJobPostForEdit(JobPostData jobPost) {
    // Only load if not already loaded to prevent resetting on keyboard appearance
    if (_currentJobId == jobPost.id && isFormLoaded.value) {
      return;
    }

    _currentJobId = jobPost.id;
    selectedJobPost.value = jobPost;
    isEditMode.value = true;

    // Fill date
    if (jobPost.datePosted != null) {
      final date = DateTime.tryParse(jobPost.datePosted!);
      if (date != null) {
        dateController.text =
            '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year.toString().substring(2)}';
      }
    }

    // Fill start time
    if (jobPost.startDate != null) {
      final startDate = DateTime.tryParse(jobPost.startDate!);
      if (startDate != null) {
        final hour = startDate.hour > 12 ? startDate.hour - 12 : startDate.hour;
        final period = startDate.hour >= 12 ? 'PM' : 'AM';
        startTimeController.text =
            '${hour.toString().padLeft(2, '0')}:${startDate.minute.toString().padLeft(2, '0')} $period';
      }
    }

    // Fill end time
    if (jobPost.endDate != null) {
      final endDate = DateTime.tryParse(jobPost.endDate!);
      if (endDate != null) {
        final hour = endDate.hour > 12 ? endDate.hour - 12 : endDate.hour;
        final period = endDate.hour >= 12 ? 'PM' : 'AM';
        endTimeController.text =
            '${hour.toString().padLeft(2, '0')}:${endDate.minute.toString().padLeft(2, '0')} $period';
      }
    }

    // Fill rate
    if (jobPost.salary != null) {
      rateController.text = jobPost.salary.toString();
    } else if (jobPost.hourlyRate != null) {
      rateController.text = jobPost.hourlyRate.toString();
    }

    // Fill shop name
    shopNameController.text = jobPost.shopName ?? '';

    // Fill shop logo path
    if (jobPost.shopLogo?.isNotEmpty == true) {
      imagePath.value = jobPost.shopLogo!;
      isNetworkImage.value = true;
      shopLogoController.text = 'Logo uploaded';
    }

    // Fill description
    descriptionController.text = jobPost.description ?? '';

    // Mark form as loaded
    isFormLoaded.value = true;
  }

  void clearForm() {
    dateController.clear();
    startTimeController.clear();
    endTimeController.clear();
    rateController.clear();
    shopNameController.clear();
    shopLogoController.clear();
    descriptionController.clear();
    imagePath.value = '';
    isNetworkImage.value = false;
    clearedInitialImage.value = false;
    selectedJobPost.value = null;
    isEditMode.value = false;
    isFormLoaded.value = false;
    _currentJobId = null;
  }

  void initializeFormForCreate() {
    // Only clear if we're switching from edit mode to create mode
    // If already in create mode, don't clear
    if (_currentJobId == 'create_mode' && isFormLoaded.value) {
      return; // Already initialized for create, don't clear
    }

    // Clear form only if coming from edit mode or first time
    clearForm();
    _currentJobId = 'create_mode';
    isFormLoaded.value = true;
  }

  @override
  void onClose() {
    dateController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    rateController.dispose();
    shopNameController.dispose();
    shopLogoController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();
      final XFile? result = await picker.pickImage(source: ImageSource.gallery);
      if (result != null) {
        imagePath.value = result.path;
        isNetworkImage.value = false;
        // If user picks a new local image, reset the cleared flag so preview
        // will show the newly picked image.
        clearedInitialImage.value = false;
        debugPrint("Picked image path: ${imagePath.value.toString()}");
      }
    } catch (e) {
      debugPrint("Error picking image: ${e.toString()}");
      toastMessage(message: 'Failed to pick image');
    }
  }

  void clearImage() {
    imagePath.value = '';
    // If the current path was a network image (edit mode) mark it as
    // cleared so the UI doesn't fall back to showing the original feed
    // image. Also ensure we don't treat the cleared state as a network
    // image when uploading.
    clearedInitialImage.value = true;
    isNetworkImage.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    fetchBarberJobPost();
  }

  Future<void> fetchBarberJobPost() async {
    try {
      barberJobPostStatus.value = RxStatus.loading();
      final response = await ApiClient.getData(ApiUrl.getBarberOwnerJobPost);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final bodyData = BarberOwnerJobPost.fromJson(response.body).data;
        barberJobPosts.value = bodyData ?? <JobPostData>[];
        debugPrint(
            "Barber Owner Job Post data length: ${barberJobPosts.length}");

        barberJobPostStatus.value = RxStatus.success();
      } else {
        debugPrint(
            "Failed to load barber owner job posts: ${response.statusCode} - ${response.statusText}");
        barberJobPostStatus.value = RxStatus.error(
            "Failed to load barber owner job posts: ${response.statusText}");
      }
    } catch (e) {
      debugPrint("Error fetching barber owner job posts: $e");
      barberJobPostStatus.value =
          RxStatus.error("Error fetching barber owner job posts: $e");
    } finally {}
  }

  Future<bool> createBarberOwnerJobPost() async {
    try {
      EasyLoading.show(status: 'Creating...');

      final Map<String, dynamic> bodyData = {
        "description": descriptionController.text,
        "hourlyRate": int.tryParse(rateController.text) ?? 0,
        "startDate": startTimeController.text,
        "endDate": endTimeController.text,
        'shopName': shopNameController.text,
        "datePosted": dateController.text,
      };

      // Check if image is selected and it's a valid local file
      bool hasValidImage = imagePath.value.isNotEmpty &&
          !isNetworkImage.value &&
          File(imagePath.value).existsSync();

      final response = await ApiClient.postMultipartData(
        ApiUrl.createBarberOwnerJobPost,
        {
          'bodyData': bodyData,
        },
        multipartBody: hasValidImage
            ? [MultipartBody('shopLogo', File(imagePath.value))]
            : [],
      );

      if (response.statusCode == 201) {
        EasyLoading.showSuccess('Job created');
        fetchBarberJobPost();
        clearForm();
        return true;
      } else {
        EasyLoading.showError('Failed to create job');
        debugPrint(
            "Failed to create job: ${response.statusCode} - ${response.statusText}");
        return false;
      }
    } catch (e) {
      EasyLoading.showError('Error creating job');
      debugPrint("Error creating job: ${e.toString()}");
      toastMessage(message: e.toString());
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<bool> updateJobPost({
    required String jobId,
  }) async {
    try {
      EasyLoading.show(status: 'Updating...');

      debugPrint("My api url: ${ApiUrl.updateJobPost(id: jobId)}");

      final Map<String, dynamic> bodyData = {
        "description": descriptionController.text,
        "hourlyRate": int.tryParse(rateController.text) ?? 0,
        "startDate": startTimeController.text,
        "endDate": endTimeController.text,
        "datePosted": dateController.text,
      };

      // Check if we have a valid local file to upload
      bool hasValidLocalImage = imagePath.value.isNotEmpty &&
          !isNetworkImage.value &&
          File(imagePath.value).existsSync();

      final response = await ApiClient.patchMultipart(
        ApiUrl.updateJobPost(id: jobId),
        {
          'bodyData': bodyData,
        },
        multipartBody: hasValidLocalImage
            ? [MultipartBody('shopLogo', File(imagePath.value))]
            : [],
      );

      if (response.statusCode == 200) {
        EasyLoading.showSuccess('Job updated');
        fetchBarberJobPost();
        clearForm();
        return true;
      } else {
        EasyLoading.showError('Failed to update job');
        debugPrint(
            "Failed to update job: ${response.statusCode} - ${response.statusText}");
        return false;
      }
    } catch (e) {
      EasyLoading.showError('Error updating job');
      debugPrint("Error updating job: ${e.toString()}");
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> deleteJob(String id) async {
    try {
      EasyLoading.show(status: 'Deleting...');
      final url = ApiUrl.deleteJobPost(id: id);
      final response = await ApiClient.deleteData(url);

      if (response.statusCode == 200) {
        await fetchBarberJobPost();
        EasyLoading.showSuccess('Job deleted');
      } else {
        EasyLoading.showError('Failed to delete job');
        debugPrint(
            "Failed to delete job: ${response.statusCode} - ${response.statusText}");
        throw response.statusText ?? 'Failed to delete job';
      }
    } catch (e) {
      EasyLoading.showError('Error deleting job');
      debugPrint("Error deleting job: ${e.toString()}");
      toastMessage(message: e.toString());
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<bool> toggleJobPostStatus(
      {required String jobId, required bool isActive}) async {
    // Optimistically update the UI
    final jobIndex = barberJobPosts.indexWhere((job) => job.id == jobId);
    if (jobIndex != -1) {
      final oldStatus = barberJobPosts[jobIndex].isActive;
      barberJobPosts[jobIndex].isActive = isActive;
      barberJobPosts.refresh();

      try {
        final String status = isActive ? "active" : "deactive";
        final response = await ApiClient.patchData(
          ApiUrl.toggleJobPostStatus(id: jobId, status: status),
          null,
          isBody: false,
        );
        if (response.statusCode == 200) {
          debugPrint("Successfully toggled job post status");
          toastMessage(
              message:
                  'Job post ${isActive ? "activated" : "deactivated"} successfully');
          return true;
        } else {
          // Revert on failure
          barberJobPosts[jobIndex].isActive = oldStatus;
          barberJobPosts.refresh();
          debugPrint(
              "Failed to toggle job post status: ${response.statusCode} - ${response.statusText}");
          toastMessage(message: 'Failed to update job post status');
          return false;
        }
      } catch (e) {
        // Revert on error
        barberJobPosts[jobIndex].isActive = oldStatus;
        barberJobPosts.refresh();
        debugPrint("Error toggling job post status: ${e.toString()}");
        toastMessage(message: 'Error updating job post status');
        return false;
      }
    }
    return false;
  }
}
