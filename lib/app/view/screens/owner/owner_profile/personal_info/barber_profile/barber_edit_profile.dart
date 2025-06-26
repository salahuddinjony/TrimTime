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
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class BarberEditProfile extends StatefulWidget {
  const BarberEditProfile({
    super.key,
  });

  @override
  State<BarberEditProfile> createState() => _EditOwnerProfileState();
}

class _EditOwnerProfileState extends State<BarberEditProfile> {
  final ImagePicker _picker = ImagePicker();
  File? _image;

  // Method to pick an image from the gallery
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Store the selected image
      });
    } else {
      print('No image selected.');
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
              SizedBox(height: 20.h,),
              Center(
                child: Stack(
                  children: [
                    CustomNetworkImage(
                      boxShape: BoxShape.circle,
                      imageUrl: AppConstants.demoImage,
                      height: 102.h,
                      width: 102.w,
                    ),
                    Positioned(
                      bottom: 0,
                      // Position the icon at the bottom of the circle image
                      right: 0,
                      // Position the icon at the right of the circle image
                      child: GestureDetector(
                        onTap: () {
                          _pickImage(ImageSource.camera);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          // Padding around the icon
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            // Background color for the icon button
                            shape: BoxShape.circle,
                            // Make the button round
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.camera_alt, // Camera icon for image picker
                            color: Colors.white, // Icon color
                            size: 24, // Icon size
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

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
                        controller: TextEditingController(text: '22/10/2024l'),
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
