import 'dart:io';

import 'package:barber_time/app/core/bottom_navbar.dart';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/common_widgets/custom_text_field/custom_text_field.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class BarberFeed extends StatefulWidget {
  const BarberFeed({
    super.key,
  });

  @override
  State<BarberFeed> createState() => _BarberFeedState();
}

class _BarberFeedState extends State<BarberFeed> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  Future<void> _pickImage() async {
    // Open gallery to pick an image
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
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
                    Color(0xCCEDC4AC), // First color (with opacity)
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
                      text: AppStrings.choiceImage,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                      fontSize: 16,
                      bottom: 8,
                    ),
                    Row(
                      children: [
                        CustomNetworkImage(
                            imageUrl: AppConstants.demoImage,
                            height: 100,
                            width: 100),
                        SizedBox(
                          width: 10.w,
                        ),
                Center(
                  child: DottedBorder(
                    padding: const EdgeInsets.all(25),
                    // Border thickness
                    child: GestureDetector(
                      onTap: _pickImage, // Open gallery when clicked
                      child: Column(
                        children: [
                          _imageFile == null
                              ? const Icon(
                            Icons.add,
                            color: Colors.white,
                          )
                              : Image.file(
                            File(_imageFile!.path),
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
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
