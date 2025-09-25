import 'dart:io';

import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/global/controller/auth_controller/auth_controller.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_from_card/custom_from_card.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class OwnerShopDetails extends StatefulWidget {
  const OwnerShopDetails({super.key});

  @override
  State<OwnerShopDetails> createState() => _OwnerShopDetailsState();
}

class _OwnerShopDetailsState extends State<OwnerShopDetails> {
  final AuthController authController = Get.find<AuthController>();
  // Use AuthController methods for image picking and storage

  @override
  Widget build(BuildContext context) {
    final userRole = GoRouterState.of(context).extra as UserRole?;
    debugPrint("Selected Role============================${userRole?.name}");
    return Scaffold(
      appBar: const CustomAppBar(
        appBarContent: AppStrings.businessDetails,
        appBarBgColor: AppColors.linearFirst,
        // iconData: Icons.arrow_back,
      ),
      body: SingleChildScrollView(
        child: Obx(() {
          return Column(
            children: [
              ClipPath(
                clipper: CurvedBannerClipper(),
                child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xCCEDC4AC), // First color (with opacity)
                          Color(0xFFE9864E),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 30.h,
                          ),

                          //ToDo ==========✅✅ shopName ✅✅==========
                          CustomFromCard(
                              hinText: AppStrings.enterYourSHopName,   
                              title: AppStrings.shopNames,
                              controller: authController.shopNameController,
                              validator: (v) {
                                return null;
                              }), //ToDo ==========✅✅ registrationNumber✅✅==========
                          CustomFromCard(
                              hinText: AppStrings.enterYourRegistrationNumber,
                              title: AppStrings.registrationNumber,
                              controller: authController.regNumberController,
                              // Add a suffix icon button to generate a unique reg code
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  authController.generateRegistrationNumber();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(Icons.autorenew, color: AppColors.black),
                                      SizedBox(width: 6),
                                      Text(
                                        'Generate',
                                        style: TextStyle(
                                            color: AppColors.black, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              validator: (v) {
                                return null;
                              }
                          ),

                          CustomFromCard(
                              hinText: AppStrings.address,
                              title: AppStrings.address,
                              controller: authController.addressController,
                              validator: (v) {
                                return null;
                              }),

                          //ToDo ==========✅✅ registrationNumber✅✅==========
                          // CustomFromCard(
                          //     suffixIcon: const Icon(Icons.add),
                          //     hinText: AppStrings.addService,
                          //     title: AppStrings.addService,
                          //     controller: authController.emailController,
                          //     validator: (v) {
                          //       return null;
                          //     }),
                          const CustomText(
                            top: 12,
                            text: "Upload Shop Logo",
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white50,
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () async {
                              await authController.pickShopLogo();
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.white50.withValues(alpha: .02),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.white50, width: 1),
                              ),
                              child: Row(
                                children: [
                                  // Logo preview or upload icon
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      width: 70,
                                      height: 70,
                                      color: AppColors.white50.withValues(alpha: .05),
                                      child: Builder(builder: (_) {
                                        final File? logo = authController.selectedShopLogo.value;
                                        return logo == null
                                            ? const Icon(Icons.upload_file, color: AppColors.white50, size: 36)
                                            : Image.file(
                                                logo,
                                                fit: BoxFit.cover,
                                              );
                                      }),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Title and status
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Shop Logo',
                                          style: TextStyle(
                                            color: AppColors.white50,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          authController.selectedShopLogo.value == null
                                              ? 'Tap to upload logo'
                                              : 'Tap to change logo',
                                          style: const TextStyle(
                                            color: AppColors.white50,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Remove button when selected
                                  if (authController.selectedShopLogo.value != null)
                                    GestureDetector(
                                      onTap: () {
                                        authController.selectedShopLogo.value = null;
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Icon(Icons.delete, color: AppColors.white50),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const CustomText(
                            top: 12,
                            text: "Shop Pictures (max 4)",
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white50,
                          ),
                          const SizedBox(height: 10),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // দুইটা কলামে দেখাবে
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1,
                            ),
                            itemCount: (authController.shopImages.length < 4)
                                ? authController.shopImages.length + 1
                                : 4,
                            itemBuilder: (context, index) {
                              if (index == authController.shopImages.length &&
                                  authController.shopImages.length < 4) {
                                return GestureDetector(
                                  onTap: () async {
                                    await authController.pickShopImages();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.white50.withValues(alpha: .2),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: AppColors.white50, width: 1),
                                    ),
                                    child: const Icon(
                                      Icons.add_a_photo,
                                      color: AppColors.white50,
                                      size: 40,
                                    ),
                                  ),
                                );
                              } else {
                                final imgFile = authController.shopImages[index];
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    File(imgFile.path),
                                    fit: BoxFit.cover,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    )),
              ),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: authController.isRemember.value,
                            checkColor: AppColors.white50,
                            activeColor: AppColors.black,
                            onChanged: (value) {
                              authController.isRemember.value = value ?? false;
                              debugPrint(
                                  "Checkbox clicked, Remember value: ${authController.isRemember.value}");
                            },
                          ),
                          const CustomText(
                            top: 12,
                            text: AppStrings.iAgreeToThe,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                            bottom: 15,
                          ),
                          GestureDetector(
                            onTap: () {
                              AppRouter.route.pushNamed(RoutePath.termsScreen,
                                  extra: userRole);
                            },
                            child: const CustomText(
                              top: 12,
                              text: " ${AppStrings.termsAndConditions}",
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.red,
                              bottom: 15,
                            ),
                          ),
                        ],
                      ),
                      //===================next Button=================
                      CustomButton(
                        onTap: () async {
                          debugPrint('Email before register: ${authController.emailController.text}');
                          await authController.registerShop();
                        },
                        title: "Next",
                        fillColor: Colors.black,
                        textColor: Colors.white,
                      ),
                      SizedBox(
                        height: 50.h,
                      ),
                    ],
                  )),
            ],
          );
        }),
      ),
    );
  }
}
