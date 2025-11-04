import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_from_card/custom_from_card.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/controller/owner_profile_controller.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/models/barber_professional_profile.dart';
import 'package:flutter/material.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

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
  @override
  void initState() {
    super.initState();
    // Call setInitialData in initState instead of build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.setInitialData(widget.professionalData);
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
                          CustomFromCard(
                            hinText: "Enter your name",
                            title: AppStrings.name,
                            controller: widget.controller.nameController,
                            validator: (v) => null,
                          ),
                          SizedBox(height: 20.h),
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
                          //==================✅✅Image✅✅===================
                          Obx(() {
                            final imagePath = widget.controller.imagepath.value;
                            final isNetwork =
                                widget.controller.isNetworkImage.value;

                            // Determine the image source
                            String imageToDisplay = imagePath.isNotEmpty
                                ? imagePath
                                : (widget.professionalData.portfolio.isNotEmpty
                                    ? widget.professionalData.portfolio.first
                                    : AppConstants.demoImage);

                            return CustomNetworkImage(
                              imageUrl: imageToDisplay,
                              height: 100,
                              width: 100,
                              isFile: !isNetwork && imagePath.isNotEmpty,
                              boxShape: BoxShape.circle,
                            );
                          }),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: () {
                                widget.controller.pickImage();
                              },
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
                SizedBox(height: 20.h),
                //==================✅✅Save Button✅✅===================
                CustomButton(
                  title: AppStrings.update,
                  onTap: () async {
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
