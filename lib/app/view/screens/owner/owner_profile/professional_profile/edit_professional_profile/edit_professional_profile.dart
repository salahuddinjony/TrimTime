import 'dart:io';

import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_from_card/custom_from_card.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/controller/owner_profile_controller.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/models/barber_professional_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class EditProfessionalProfile extends StatefulWidget {
  final UserRole userRole;
  final BarberProfile professionalData;
  final OwnerProfileController controller;

  const EditProfessionalProfile(
      {super.key,
      required this.userRole,
      required this.professionalData,
      required this.controller});

  @override
  State<EditProfessionalProfile> createState() =>
      _EditProfessionalProfileState();
}

class _EditProfessionalProfileState extends State<EditProfessionalProfile> {
  final ImagePicker _picker = ImagePicker();
  final List<dynamic> _portfolioImages = []; // Can be File or String (URL)

  @override
  void initState() {
    super.initState();
    // Initialize with existing images from professionalData.portfolio
    _portfolioImages.addAll(widget.professionalData.portfolio);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.setInitialData(widget.professionalData);
    });
  }

  //CLICK TO SELECT MULTIPLE IMAGES AND add profolio images function
  Future<void> _pickImages() async {
    final List<XFile>? picked = await _picker.pickMultiImage();
    if (picked != null) {
      setState(() {
        _portfolioImages.addAll(picked.map((x) => File(x.path)));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _portfolioImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                            color: Colors.white.withValues(alpha: 0.1),
                            blurRadius: 8,
                            spreadRadius: 2,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 50.h),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              "Portfolio Images",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 90,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _portfolioImages.length + 1,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 10),
                              itemBuilder: (context, index) {
                                if (index < _portfolioImages.length) {
                                  final img = _portfolioImages[index];
                                  return Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: img is File
                                            ? Image.file(
                                                img,
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.cover,
                                              )
                                            : CachedNetworkImage(
                                                imageUrl: img,
                                                width: 80,
                                                height: 80,
                                              ),
                                      ),
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: GestureDetector(
                                          onTap: () => _removeImage(index),
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: 12,
                                            child: const Icon(Icons.close,
                                                size: 16, color: Colors.red),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return GestureDetector(
                                    onTap: _pickImages,
                                    child: buildAddTile(),
                                  );
                                }
                              },
                            ),
                          ),
                          CustomFromCard(
                            hinText: "Enter your bio",
                            title: "Bio",
                            maxLine: 5,
                            controller: widget.controller.bioController,
                            validator: (v) => null,
                          ),
                          SizedBox(height: 15.h),
                          CustomFromCard(
                            hinText: "Enter your experience in years",
                            title: "Experience",
                            controller: widget.controller.experienceController,
                            validator: (v) => null,
                          ),
                          SizedBox(height: 15.h),
                          CustomFromCard(
                            hinText: "Enter your current work place",
                            title: "Current Work",
                            controller: widget.controller.currentWorkController,
                            validator: (v) => null,
                          ),
                          SizedBox(height: 15.h),
                          CustomFromCard(
                            hinText: "Enter your skills",
                            title: "Add Skill",
                            controller: widget.controller.addSkillsController,
                            validator: (v) => null,
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
                          // Always show professionalData.image at the top
                          Obx(() {
                            final imagePath = widget.controller.imagepath.value;
                            final isNetwork =
                                widget.controller.isNetworkImage.value;
                            String imageToDisplay =
                                (widget.professionalData.image?.isNotEmpty ==
                                        true)
                                    ? widget.professionalData.image!
                                    : AppConstants.demoImage;
                            return CustomNetworkImage(
                              imageUrl: imageToDisplay,
                              height: 100,
                              width: 100,
                              isFile: !isNetwork && imagePath.isNotEmpty,
                              boxShape: BoxShape.circle,
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                CustomButton(
                  title: AppStrings.update,
                  onTap: () async {
                    widget.controller.portfolioImages.value = _portfolioImages
                        .map((f) => f is File ? f.path : f)
                        .toList()
                        .cast<String>();
                    final bool isSuccess =
                        await widget.controller.updateBarberProfile();
                    if (isSuccess) {
                      context.pop();
                    }
                  },
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildAddTile({IconData icon = Icons.add}) {
  return Container(
    width: 80,
    height: 80,
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: .3),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Icon(icon, color: Colors.grey),
  );
}

InputDecoration inputDecoration({String hintText = ""}) {
  return InputDecoration(
    hintText: hintText,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
  );
}
