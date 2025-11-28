import 'dart:io';

import 'package:barber_time/app/core/bottom_navbar.dart';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/common_widgets/custom_text_field/custom_text_field.dart';
import 'package:barber_time/app/view/screens/barber/barber_feed/controller/barber_feed_controller.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/my_feed/model/feed_model.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:get/get.dart';

class BarberFeed extends StatefulWidget {
  final bool isEdit;
  final FeedItem? item;
  final String? image;

  const BarberFeed({
    super.key,
    this.item,
    required this.isEdit,
    this.image,
  });

  @override
  State<BarberFeed> createState() => _BarberFeedState();
}

class _BarberFeedState extends State<BarberFeed> {
  final ImagePicker _picker = ImagePicker();
  PlatformFile? _mediaFile;
  String? _videoThumbnailPath;
  final BarberFeedController feedController = Get.find<BarberFeedController>();

  @override
  void initState() {
    super.initState();
    // If editing, initialize the imagepath with the existing image URL.
    feedController.imagepath.value = widget.image ?? '';
    // Mark whether the initial imagepath is a network URL so preview uses the
    // correct image provider (File vs Network). Also ensure cleared flag is
    // reset when opening the editor.
    feedController.isNetworkImage.value = (widget.image != null &&
        ((widget.image?.startsWith('http') ?? false) ||
            (widget.image?.startsWith('https') ?? false)));
    feedController.clearedInitialImage.value = false;
  }

  Future<void> _pickMediaFromCamera() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Capture Image'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? pickedFile = await _picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (pickedFile != null) {
                    setState(() {
                      _mediaFile = PlatformFile(
                        name: pickedFile.name,
                        path: pickedFile.path,
                        size: File(pickedFile.path).lengthSync(),
                      );
                      _videoThumbnailPath = null;
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.videocam),
                title: const Text('Capture Video'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? pickedFile = await _picker.pickVideo(
                    source: ImageSource.camera,
                  );
                  if (pickedFile != null) {
                    setState(() {
                      _mediaFile = PlatformFile(
                        name: pickedFile.name,
                        path: pickedFile.path,
                        size: File(pickedFile.path).lengthSync(),
                      );
                    });

                    final thumb = await VideoThumbnail.thumbnailFile(
                      video: pickedFile.path,
                      imageFormat: ImageFormat.PNG,
                      maxWidth: 200,
                      quality: 75,
                    );
                    setState(() {
                      _videoThumbnailPath = thumb;
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Pick image or video from gallery
  Future<void> _pickMediaFromGallery() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4'],
    );

    if (result != null && result.files.isNotEmpty) {
      final pickedFile = result.files.first;
      setState(() {
        _mediaFile = pickedFile;
      });

      if (pickedFile.extension == 'mp4') {
        final thumb = await VideoThumbnail.thumbnailFile(
          video: pickedFile.path!,
          imageFormat: ImageFormat.PNG,
          maxWidth: 200,
          quality: 75,
        );
        setState(() {
          _videoThumbnailPath = thumb;
        });
      } else {
        setState(() {
          _videoThumbnailPath = null;
        });
      }
    }
  }

  // Show bottom sheet for options
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickMediaFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickMediaFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final extra = GoRouter.of(context).state.extra;
    // Determine user role whether passed directly or inside an extra map.
    UserRole? userRole;
    if (extra is UserRole) {
      userRole = extra;
    } else if (extra is Map && extra['userRole'] is UserRole) {
      userRole = extra['userRole'] as UserRole;
    } else {
      userRole = null;
    }

    // Resolve the feed item to edit. It may come from the widget constructor
    // or from the GoRouter extra (map or direct FeedItem).
    FeedItem? feedItem = widget.item;
    if (widget.isEdit && feedItem == null) {
      if (extra is Map && extra['feedItem'] is FeedItem) {
        feedItem = extra['feedItem'] as FeedItem;
      } else if (extra is FeedItem) {
        feedItem = extra;
      }
    }

    final captionController =
        TextEditingController(text: feedItem?.caption ?? '');

    debugPrint("===================${userRole?.name}");
    if (!widget.isEdit && userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }

    return Scaffold(
      bottomNavigationBar: BottomNavbar(
        currentIndex: 2,
        role: userRole ?? UserRole.barber,
      ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.linearFirst,
        title: const Text(AppStrings.addFeed),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: CurvedBannerClipper(),
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
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CustomText(
                        text: "Upload Video or Image",
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                        fontSize: 16,
                        bottom: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 10.w,
                          ),
                          Center(
                            child: DottedBorder(
                              padding: const EdgeInsets.all(25),
                              child: GestureDetector(
                                onTap: () => _showBottomSheet(context),
                                child: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        // Show existing network image when editing
                                        if (widget.isEdit &&
                                            (feedItem?.images.isNotEmpty ??
                                                false) &&
                                            _mediaFile == null &&
                                            !feedController
                                                .clearedInitialImage.value)
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: CustomNetworkImage(
                                              imageUrl: widget.image ??
                                                  feedItem!.images.first,
                                              height: 100,
                                              width: 100,
                                            ),
                                          )
                                        // Show selected media file
                                        else if (_mediaFile != null)
                                          _mediaFile!.extension == 'mp4'
                                              ? Stack(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      child:
                                                          _videoThumbnailPath !=
                                                                  null
                                                              ? Image.file(
                                                                  File(
                                                                      _videoThumbnailPath!),
                                                                  height: 100,
                                                                  width: 100,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                              : Container(
                                                                  height: 100,
                                                                  width: 100,
                                                                  color: Colors
                                                                      .black26,
                                                                ),
                                                    ),
                                                    Positioned.fill(
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                            color:
                                                                Colors.black54,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child: Icon(
                                                              Icons.play_arrow,
                                                              color:
                                                                  Colors.white,
                                                              size: 32,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: Image.file(
                                                    File(_mediaFile!.path!),
                                                    height: 100,
                                                    width: 100,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                        // Show default upload icon
                                        else
                                          const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                        const CustomText(
                                          text: AppStrings.upload,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.black,
                                          fontSize: 16,
                                        ),
                                      ],
                                    ),
                                    // Show clear button when there's media or existing image
                                    if (_mediaFile != null ||
                                        (widget.isEdit &&
                                            (feedItem?.images.isNotEmpty ??
                                                false) &&
                                            !feedController
                                                .clearedInitialImage.value))
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _mediaFile = null;
                                              _videoThumbnailPath = null;
                                              if (widget.isEdit) {
                                                feedController
                                                    .clearedInitialImage
                                                    .value = true;
                                              }
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.black
                                                  .withValues(alpha: 0.6),
                                              shape: BoxShape.circle,
                                            ),
                                            padding: const EdgeInsets.all(4),
                                            child: const Icon(
                                              Icons.clear,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.w,
                      ),
                      const CustomText(
                        text: AppStrings.caption,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                        fontSize: 16,
                        bottom: 8,
                      ),
                      CustomTextField(
                        textEditingController: captionController,
                        maxLines: 3,
                      ),
                      SizedBox(
                        height: 40.w,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: CustomButton(
                title: widget.isEdit ? AppStrings.update : AppStrings.post,
                textColor: AppColors.white50,
                onTap: () async {
                  if (captionController.text.isEmpty ||
                      _mediaFile == null &&
                          !(widget.isEdit &&
                              (feedItem?.images.isNotEmpty ?? false) &&
                              !feedController.clearedInitialImage.value)) {
                    EasyLoading.showInfo(AppStrings.pleaseFillAllFields);
                    return;
                  }
                  if (widget.isEdit) {
                    final bool isUpdateSuccess =
                        await feedController.updateFeed(
                      feedId: feedItem?.id ?? '',
                      caption: captionController.text,
                      mediaFile: _mediaFile, // Add this parameter
                    );
                    if (isUpdateSuccess) {
                      AppRouter.route
                          .pushNamed(RoutePath.myFeed, extra: userRole);
                      return;
                    }
                    return;
                  }
                  final bool isCreateSuccess = await feedController.createFeed(
                    caption: captionController.text,
                    mediaFile: _mediaFile, // Add this parameter
                  );

                  if (isCreateSuccess) {
                    AppRouter.route
                        .pushNamed(RoutePath.myFeed, extra: userRole);
                    return;
                  }
                },
                fillColor: AppColors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}
