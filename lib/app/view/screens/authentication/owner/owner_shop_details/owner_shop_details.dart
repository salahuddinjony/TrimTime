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
import 'package:image_picker/image_picker.dart';

class OwnerShopDetails extends StatefulWidget {
  const OwnerShopDetails({super.key});

  @override
  State<OwnerShopDetails> createState() => _OwnerShopDetailsState();
}

class _OwnerShopDetailsState extends State<OwnerShopDetails> {
  final AuthController authController = Get.find<AuthController>();
  final ImagePicker _picker = ImagePicker();
  List<XFile> _imageFiles = [];

  Future<void> _pickImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        if (_imageFiles.length + pickedFiles.length <= 4) {
          _imageFiles.addAll(pickedFiles);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Maximum 4 images allowed!")),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userRole = GoRouterState.of(context).extra as UserRole?;
    debugPrint("Selected Role============================${userRole?.name}");
    return Scaffold(
      appBar: const CustomAppBar(
        appBarContent:AppStrings.businessDetails,
        appBarBgColor: AppColors.linearFirst,
        iconData: Icons.arrow_back,
      ),
      body: SingleChildScrollView(
        child: Obx(
          () {
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


                            //ToDo ==========✅✅ fullName ✅✅==========
                            CustomFromCard(
                                hinText: AppStrings.enterYourSHopName,
                                title: AppStrings.shopNames,
                                controller: authController.fullNameController,
                                validator: (v) {}),
                            //ToDo ==========✅✅ registrationNumber✅✅==========
                            CustomFromCard(
                                hinText: AppStrings.enterYourRegistrationNumber,
                                title: AppStrings.registrationNumber,
                                controller: authController.emailController,
                                validator: (v) {}),

                            //ToDo ==========✅✅ registrationNumber✅✅==========
                            CustomFromCard(
                              suffixIcon: const Icon(Icons.add),
                                hinText: AppStrings.addService,
                                title: AppStrings.addService,
                                controller: authController.emailController,
                                validator: (v) {}),

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
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // দুইটা কলামে দেখাবে
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 1,
                              ),
                              itemCount: (_imageFiles.length < 4) ? _imageFiles.length + 1 : 4,
                              itemBuilder: (context, index) {
                                if (index == _imageFiles.length && _imageFiles.length < 4) {
                                  return GestureDetector(
                                    onTap: _pickImages,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.white50.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: AppColors.white50, width: 1),
                                      ),
                                      child: const Icon(
                                        Icons.add_a_photo,
                                        color: AppColors.white50,
                                        size: 40,
                                      ),
                                    ),
                                  );
                                } else {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      File(_imageFiles[index].path), // `Image.file` দিয়ে লোকাল ইমেজ দেখানো হচ্ছে
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
                                authController.isRemember.value =
                                    value ?? false;
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
                              onTap: (){
                                AppRouter.route.pushNamed(
                                    RoutePath.termsScreen,
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
                          onTap: () {

                            context.pushNamed(
                              RoutePath.subscriptionPlan,extra: userRole
                            );
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
          }
        ),
      ),
    );
  }
}
