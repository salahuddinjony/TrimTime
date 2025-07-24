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
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class BarberFeed extends StatefulWidget {
  const BarberFeed({
    super.key,
  });

  @override
  State<BarberFeed> createState() => _BarberFeedState();
}

class _BarberFeedState extends State<BarberFeed> {
  final ImagePicker _picker = ImagePicker();
  PlatformFile? _mediaFile;
  String? _videoThumbnailPath;

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
          maxWidth: 200, // Adjust as needed
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
                  _pickMediaFromCamera(); // call updated method

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
    final userRole = GoRouter.of(context).state.extra as UserRole?;

    debugPrint("===================${userRole?.name}");
    if (userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }

    return Scaffold(
      bottomNavigationBar: BottomNavbar(
        currentIndex: 2,
        role: userRole,
      ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.linearFirst,
        title: const Text(AppStrings.addFeed),
      ),
      body: Column(
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
                      children: [
                        SizedBox(
                          width: 10.w,
                        ),
                        Center(
                          child: DottedBorder(
                            padding: const EdgeInsets.all(25),
                            child: GestureDetector(
                              onTap: () => _showBottomSheet(context),
                              child: Column(
                                children: [
                                  _mediaFile == null
                                      ? const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  )
                                      : _mediaFile!.extension == 'mp4'
                                      ? Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(12),
                                        child: _videoThumbnailPath !=
                                            null
                                            ? Image.file(
                                          File(
                                              _videoThumbnailPath!),
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                        )
                                            : Container(
                                          height: 100,
                                          width: 100,
                                          color:
                                          Colors.black26,
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
                                              padding:
                                              EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.play_arrow,
                                                color: Colors.white,
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
                                  ),
                                  const CustomText(
                                    text: AppStrings.upload,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.black,
                                    fontSize: 16,
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
                    const CustomTextField(),
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
              title: AppStrings.post,
              textColor: AppColors.white50,
              onTap: () {
                AppRouter.route
                    .pushNamed(RoutePath.myFeed, extra: userRole);
              },
              fillColor: AppColors.black,
            ),
          )
        ],
      ),
    );
  }
}
