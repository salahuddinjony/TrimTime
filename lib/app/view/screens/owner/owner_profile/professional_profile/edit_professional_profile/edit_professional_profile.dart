import 'dart:io';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_from_card/custom_from_card.dart';
import 'package:flutter/material.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class EditProfessionalProfile extends StatefulWidget {
  const EditProfessionalProfile({super.key});

  @override
  State<EditProfessionalProfile> createState() => _EditProfessionalProfileState();
}

class _EditProfessionalProfileState extends State<EditProfessionalProfile> {
  File? _pickedImage;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );

    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userRole = GoRouter.of(context).state.extra as UserRole?;

    if (userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.linearFirst,
      appBar: const CustomAppBar(
        appBarBgColor: AppColors.linearFirst,
        appBarContent: "Edit Barber Profile",
        iconData: Icons.arrow_back,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 60),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.1),
                            blurRadius: 8,
                            spreadRadius: 2,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 50.h),
                          CustomFromCard(
                            title: AppStrings.name,
                            controller: TextEditingController(),
                            validator: (v) => null,
                          ),
                          SizedBox(height: 20.h),
                          CustomFromCard(
                            title: "Bio",
                            maxLine: 5,
                            controller: TextEditingController(),
                            validator: (v) => null,
                          ),
                          SizedBox(height: 15.h),
                          CustomFromCard(
                            title: "Experience",
                            controller: TextEditingController(),
                            validator: (v) => null,
                          ),
                          SizedBox(height: 15.h),
                          CustomFromCard(
                            title: "Current Work",
                            controller: TextEditingController(),
                            validator: (v) => null,
                          ),
                          SizedBox(height: 15.h),
                          CustomFromCard(
                            title: "Add Skill",
                            controller: TextEditingController(),
                            validator: (v) => null,
                          ),
                          CustomButton(
                            onTap: () {
                              context.pop();
                            },
                            title: AppStrings.save,
                            fillColor: AppColors.black,
                            textColor: AppColors.white,
                          ),
                          SizedBox(height: 15.h),
                        ],
                      ),
                    ),

                    // ================= IMAGE ====================
                    Positioned(
                      top: 0,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          ClipOval(
                            child: _pickedImage != null
                                ? Image.file(
                              _pickedImage!,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            )
                                : CustomNetworkImage(
                              imageUrl: AppConstants.demoImage,
                              height: 100,
                              width: 100,
                              boxShape: BoxShape.circle,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: const CircleAvatar(
                                radius: 16,
                                backgroundColor: AppColors.black,
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
