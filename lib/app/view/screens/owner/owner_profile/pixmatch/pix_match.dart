import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/route_path.dart';
import '../../../../../core/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_strings.dart';
import '../../../../../utils/enums/user_role.dart';
import '../../../../common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import '../../../../common_widgets/custom_text/custom_text.dart';

class PixMatch extends StatefulWidget {
  const PixMatch({super.key});

  @override
  State<PixMatch> createState() => _PixMatchState();
}

class _PixMatchState extends State<PixMatch> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  UserRole? userRole;

  Future<void> _pickImage() async {
    // Open camera instead of gallery
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });

      // Show processing dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => ProcessingDialog(imagePath: pickedFile.path),
      );

      // Wait 5 seconds before navigating
      await Future.delayed(const Duration(seconds: 5));

      if (!mounted) return;

      // Close the dialog
      Navigator.of(context).pop();

      // Navigate to the target screen
      AppRouter.route.pushNamed(RoutePath.nearYouShopScreen, extra: userRole);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userRole ??= GoRouter.of(context).state.extra as UserRole?;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("===================${userRole?.name}");
    if (userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.linearFirst,
        title: const Text("Add Image"),
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
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Center(
                          child: DottedBorder(
                            padding: const EdgeInsets.all(25),
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: Column(
                                children: [
                                  _imageFile == null
                                      ? const Icon(Icons.add, color: Colors.white)
                                      : Image.file(
                                    File(_imageFile!.path),
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  const CustomText(
                                    text: "Upload a current picture",
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
                    SizedBox(height: 100.w),
                  ],
                ),
              ),
            ),
          ),
          // Uncomment below if you want a button for additional actions
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
          //   child: CustomButton(
          //     title: AppStrings.post,
          //     textColor: AppColors.white50,
          //     onTap: () {},
          //     fillColor: AppColors.black,
          //   ),
          // )
        ],
      ),
    );
  }
}

class ProcessingDialog extends StatelessWidget {
  final String imagePath;

  const ProcessingDialog({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              color: AppColors.linearFirst,
            ),
            const SizedBox(height: 20),
            const Text(
              "Processing your image...",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                File(imagePath),
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
