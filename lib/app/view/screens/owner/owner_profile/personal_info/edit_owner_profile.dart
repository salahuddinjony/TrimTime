import 'dart:io';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_from_card/custom_from_card.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_radio_button/custom_radio_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/controller/owner_profile_controller.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/models/profile_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class EditOwnerProfile extends StatefulWidget {
  final UserRole userRole;
  final ProfileData data;
  final OwnerProfileController controller;
  const EditOwnerProfile({
    super.key,
    required this.userRole,
    required this.data,
    required this.controller,
  });

  @override
  State<EditOwnerProfile> createState() => _EditOwnerProfileState();
}

class _EditOwnerProfileState extends State<EditOwnerProfile> {
  File? _imageFile;
  String? _videoThumbnailPath;
  File? videoFile;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final ProfileData initialData = widget.controller.profileDataList.value != null
        ? widget.controller.profileDataList.value!
        : widget.data;
    widget.controller.setInitialValue(initialData);
  }

  Future<void> showPickerOptions() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.of(context).pop();
                _showCameraOptions();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.of(context).pop();
                _showGalleryOptions();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCameraOptions() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Capture Image'),
              onTap: () async {
                Navigator.of(context).pop();
                final XFile? pickedImage = await _picker.pickImage(
                  source: ImageSource.camera,
                );
                if (pickedImage != null) {
                  setState(() {
                    _imageFile = File(pickedImage.path);
                    _videoThumbnailPath = null;
                    videoFile = null;
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: const Text('Capture Video'),
              onTap: () async {
                Navigator.of(context).pop();
                final XFile? pickedVideo = await _picker.pickVideo(
                  source: ImageSource.camera,
                );
                if (pickedVideo != null) {
                  final thumb = await VideoThumbnail.thumbnailFile(
                    video: pickedVideo.path,
                    imageFormat: ImageFormat.PNG,
                    maxWidth: 200,
                    quality: 75,
                  );
                  setState(() {
                    videoFile = File(pickedVideo.path);
                    _videoThumbnailPath = thumb;
                    _imageFile = null;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showGalleryOptions() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Pick Image from Gallery'),
              onTap: () async {
                Navigator.of(context).pop();
                final XFile? pickedImage =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (pickedImage != null) {
                  setState(() {
                    _imageFile = File(pickedImage.path);
                    _videoThumbnailPath = null;
                    videoFile = null;
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_library),
              title: const Text('Pick Video File'),
              onTap: () async {
                Navigator.of(context).pop();
                final result = await FilePicker.platform.pickFiles(type: FileType.video);
                if (result != null && result.files.isNotEmpty) {
                  final videoPath = result.files.first.path;
                  if (videoPath != null) {
                    final thumb = await VideoThumbnail.thumbnailFile(
                      video: videoPath,
                      imageFormat: ImageFormat.PNG,
                      maxWidth: 200,
                      quality: 75,
                    );
                    setState(() {
                      videoFile = File(videoPath);
                      _videoThumbnailPath = thumb;
                      _imageFile = null;
                    });
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildThumbnail() {
    if (_imageFile != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(
          _imageFile!,
          height: 78,
          width: 96,
          fit: BoxFit.cover,
        ),
      );
    } else if (_videoThumbnailPath != null) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              File(_videoThumbnailPath!),
              height: 78,
              width: 96,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          AppConstants.demoImage,
          height: 78,
          width: 96,
          fit: BoxFit.cover,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final extra = GoRouter.of(context).state.extra;
    UserRole? userRole;
    if (extra is UserRole) {
      userRole = extra;
    } else if (extra is Map) {
      try {
        userRole = extra['userRole'] as UserRole?;
      } catch (_) {
        userRole = null;
      }
    }

    debugPrint("===================${userRole?.name}");
    if (userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }

    return Scaffold(
      appBar: const CustomAppBar(
        appBarContent: AppStrings.editProfile,
        iconData: Icons.arrow_back,
        appBarBgColor: AppColors.linearFirst,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xCCEDC4AC),
                Color(0xFFE9874E),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    Obx(() {
                      final ProfileData currentData =
                          widget.controller.profileDataList.value != null
                              ? widget.controller.profileDataList.value!
                              : widget.data;
                      final imageUrl =
                          widget.controller.imagepath.value.isNotEmpty
                              ? widget.controller.imagepath.value
                              : (currentData.image != null &&
                                      currentData.image!.isNotEmpty
                                  ? currentData.image!
                                  : AppConstants.demoImage);
                      return CustomNetworkImage(
                        boxShape: BoxShape.circle,
                        imageUrl: imageUrl,
                        height: 102,
                        width: 102,
                        isFile: !widget.controller.isNetworkImage.value,
                      );
                    }),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          widget.controller.pickImage();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(6),
                          child: const Icon(
                            Icons.camera_alt,
                            color: AppColors.black,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomFromCard(
                        isBgColor: true,
                        isBorderColor: true,
                        title: AppStrings.name,
                        controller: widget.controller.nameController,
                        validator: (v) {
                          return null;
                        }),
                    CustomFromCard(
                        onTap: () => widget.controller.selectDate(context),
                        suffixIcon: const Icon(
                          Icons.calendar_month,
                          color: AppColors.white50,
                        ),
                        isRead: true,
                        isBgColor: true,
                        isBorderColor: true,
                        title: AppStrings.dateOfBirth,
                        controller: widget.controller.dateController,
                        validator: (v) {
                          return null;
                        }),
                    const CustomText(
                      color: AppColors.black,
                      text: AppStrings.gender,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      bottom: 8,
                    ),
                    CustomRadioButtonRow(
                      controller: widget.controller,
                      genderController: widget.controller.genderController,
                    ),
                    const CustomText(
                      color: AppColors.black,
                      text: AppStrings.phoneNumber,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      bottom: 8,
                    ),
                    InternationalPhoneNumberInput(
                      onInputChanged: (PhoneNumber number) {
                        debugPrint('Phone number: ${number.phoneNumber}');
                      },
                      onInputValidated: (bool value) {
                        debugPrint('Is phone number valid: $value');
                      },
                      selectorConfig: const SelectorConfig(
                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                        useBottomSheetSafeArea: true,
                      ),
                      ignoreBlank: false,
                      autoValidateMode: AutovalidateMode.disabled,
                      selectorTextStyle: const TextStyle(color: Colors.black),
                      textFieldController: widget.controller.phoneController,
                      formatInput: true,
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      inputBorder: const OutlineInputBorder(),
                      onSaved: (PhoneNumber number) {
                        debugPrint('Saved phone number: ${number.phoneNumber}');
                      },
                    ),
                    CustomFromCard(
                        isBgColor: true,
                        isBorderColor: true,
                        title: AppStrings.location,
                        controller: widget.controller.locationController,
                        validator: (v) {
                          return null;
                        }),
                    SizedBox(
                      height: 20.h,
                    ),
                    // Row(
                    //   children: [
                    //     _buildThumbnail(),
                    //     SizedBox(width: 10.w),
                    //     GestureDetector(
                    //       onTap: _showPickerOptions,
                    //       child: Container(
                    //         height: 78,
                    //         width: 96,
                    //         decoration: BoxDecoration(
                    //           color: Colors.white,
                    //           border: Border.all(color: Colors.blueAccent),
                    //           borderRadius: BorderRadius.circular(10),
                    //         ),
                    //         child: const Icon(
                    //           Icons.add_circle_outline_outlined,
                    //           color: Colors.blueAccent,
                    //           size: 30,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomButton(
                      textColor: AppColors.white50,
                      fillColor: AppColors.black,
                      onTap: () async {
                        final isSuccess =
                            await widget.controller.ownerProfileUpdate();
                        if (isSuccess) {
                          AppRouter.route.pushNamed(RoutePath.profileScreen,
                              extra: userRole);
                        }
                      },
                      title: AppStrings.save,
                    ),
                    SizedBox(
                      height: 100.h,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileHeaderWidget extends StatefulWidget {
  const ProfileHeaderWidget({super.key});

  @override
  State<ProfileHeaderWidget> createState() => _ProfileHeaderWidgetState();
}

class _ProfileHeaderWidgetState extends State<ProfileHeaderWidget> {
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Image.network(
            AppConstants.demoImage,
            height: 196,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 130,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: ClipOval(
                    child: _pickedImage == null
                        ? Image.network(
                            AppConstants.demoImage,
                            height: 102,
                            width: 102,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            _pickedImage!,
                            height: 102,
                            width: 102,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

