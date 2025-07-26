import 'dart:io';

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
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class EditOwnerProfile extends StatefulWidget {
  const EditOwnerProfile({
    super.key,
  });

  @override
  State<EditOwnerProfile> createState() => _EditOwnerProfileState();
}

class _EditOwnerProfileState extends State<EditOwnerProfile> {
  File? _imageFile;
  String? _videoThumbnailPath;

  final ImagePicker _picker = ImagePicker();


  File? _videoFile;


  Future<void> _showPickerOptions() async {
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
                    _videoFile = null;
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
                    _videoFile = File(pickedVideo.path);
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
                    _videoFile = null;
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
                      _videoFile = File(videoPath);
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

  Widget _buildThumbnail() {
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
    final userRole = GoRouter.of(context).state.extra as UserRole?;

    debugPrint("===================${userRole?.name}");
    if (userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }
    return Scaffold(
      ///============================ Header ===============================
      appBar: const CustomAppBar(
        appBarContent: AppStrings.editProfile,
        iconData: Icons.arrow_back,
        appBarBgColor: AppColors.linearFirst,
      ),

      ///============================ body ===============================
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
              const ProfileHeaderWidget(),
           SizedBox(height: 30.h,),

              //name
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 20),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 CustomFromCard(
                     isBgColor: true,
                     isBorderColor: true,
                     title: AppStrings.name,
                     controller: TextEditingController(text: " james"),
                     validator: (v) {
                       return null;
                     }),
                 //dateOfBirth
                 CustomFromCard(
                     suffixIcon: const Icon(
                       Icons.calendar_month,
                       color: AppColors.white50,
                     ),
                     isRead: true,
                     isBgColor: true,
                     isBorderColor: true,
                     title: AppStrings.dateOfBirth,
                     controller: TextEditingController(text: '22/10/2024'),
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
                 //Gender
                 CustomRadioButtonRow(
                   genderController: TextEditingController(),
                 ),
                 //======================Phone Number=================
                 const CustomText(
                   color: AppColors.black,
                   text: AppStrings.phoneNumber,
                   fontWeight: FontWeight.w400,
                   fontSize: 16,
                   bottom: 8,
                 ),

                 // CountryCodePickerField(
                 //   readOnly: true, // Set to false if you want the user to be able to edit the phone number directly
                 //   onTap: () {
                 //     // Handle tap action (e.g., show dialog or perform other actions)
                 //     print("Country code picker tapped!");
                 //   },
                 // ),
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
                   // initialValue: ,
                   textFieldController: TextEditingController(),
                   formatInput: true,
                   keyboardType: const TextInputType.numberWithOptions(
                       signed: true, decimal: true),
                   inputBorder: const OutlineInputBorder(),
                   onSaved: (PhoneNumber number) {
                     debugPrint('Saved phone number: ${number.phoneNumber}');
                   },
                 ),

                 //location
                 CustomFromCard(
                     isBgColor: true,
                     isBorderColor: true,
                     title: AppStrings.location,
                     controller: TextEditingController(text: 'Abu Dhabi'),
                     validator: (v) {
                       return null;
                     }),

                 SizedBox(
                   height: 20.h,
                 ),
                 Row(
                   children: [
                     _buildThumbnail(),
                     SizedBox(width: 10.w),
                     GestureDetector(
                       onTap: _showPickerOptions,
                       child: Container(
                         height: 78,
                         width: 96,
                         decoration: BoxDecoration(
                           color: Colors.white,
                           border: Border.all(color: Colors.blueAccent),
                           borderRadius: BorderRadius.circular(10),
                         ),
                         child: const Icon(
                           Icons.add_circle_outline_outlined,
                           color: Colors.blueAccent,
                           size: 30,
                         ),
                       ),
                     ),
                   ],
                 ),


                 SizedBox(
                   height: 20.h,
                 ),
                 //========================Save Button===============
                 CustomButton(
                   textColor: AppColors.white50,
                   fillColor: AppColors.black,
                   onTap: () {
                     context.pop();
                   },
                   title: AppStrings.save,
                 ),
                 SizedBox(
                   height: 100.h,
                 ),
               ],
             ),
           )
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
          // Background image (optional)
          Image.network(
            AppConstants.demoImage, // Replace with AppConstants.demoImage if needed
            height: 196,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 130,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                // Profile Image with GestureDetector
                GestureDetector(
                  onTap: _pickImage,
                  child: ClipOval(
                    child: _pickedImage == null
                        ? Image.network(
                      AppConstants.demoImage, // Replace with AppConstants.demoImage if needed
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
                // Camera Icon button
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: AppColors.secondary, // Replace with AppColors.secondary
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
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

