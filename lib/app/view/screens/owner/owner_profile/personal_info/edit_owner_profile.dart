import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_from_card/custom_from_card.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_radio_button/custom_radio_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/controller/owner_profile_controller.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/models/profile_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class EditOwnerProfile extends StatefulWidget {
  final UserRole userRole;
  final ProfileData data;
  final OwnerProfileController controller;
  const EditOwnerProfile({
    super.key,
    required this.userRole,
    required this.data,
    required this.controller,
  });

  @override
  State<EditOwnerProfile> createState() => _EditOwnerProfileState();
}

class _EditOwnerProfileState extends State<EditOwnerProfile> {
  @override
  void initState() {
    super.initState();
    // Prefer the freshest data from the controller if available, otherwise use the passed-in data.
    final ProfileData initialData = widget.controller.profileDataList.isNotEmpty
        ? widget.controller.profileDataList.first
        : widget.data;
    widget.controller.setInitialValue(initialData);
  }

  @override
  Widget build(BuildContext context) {
    // state.extra may be passed as a UserRole or as a Map (from other navigations).
    final extra = GoRouter.of(context).state.extra;
    UserRole? userRole;
    if (extra is UserRole) {
      userRole = extra;
    } else if (extra is Map) {
      // Some navigations pass a Map with a 'userRole' field.
      try {
        userRole = extra['userRole'] as UserRole?;
      } catch (_) {
        userRole = null;
      }
    }

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
        child: ClipPath(
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        Obx(() {
                          final ProfileData currentData = widget.controller.profileDataList.isNotEmpty
                              ? widget.controller.profileDataList.first
                              : widget.data;
                          final imageUrl = widget.controller.imagepath.value.isNotEmpty
                              ? widget.controller.imagepath.value
                              : (currentData.image != null && currentData.image!.isNotEmpty
                                  ? currentData.image!
                                  : AppConstants.demoImage);
                          return CustomNetworkImage(
                            boxShape: BoxShape.circle,
                            imageUrl: imageUrl,
                            height: 102,
                            width: 102,
                            isFile: !widget.controller.isNetworkImage.value,
                          );
                        }),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                              onTap: () {
                              widget.controller.pickImage();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(6),
                              child: const Icon(
                                Icons.camera_alt,
                                color: AppColors.black,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //name
                  CustomFromCard(
                      isBgColor: true,
                      isBorderColor: true,
                      title: AppStrings.name,
                      controller: widget.controller.nameController,
                      validator: (v) {
                        return null;
                      }),
                  //dateOfBirth
                  CustomFromCard(
                      onTap: () => widget.controller.selectDate(context),
                      suffixIcon: const Icon(
                        Icons.calendar_month,
                        color: AppColors.white50,
                      ),
                      isRead: true,
                      isBgColor: true,
                      isBorderColor: true,
                      title: AppStrings.dateOfBirth,
                      controller: widget.controller.dateController,
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
                    controller: widget.controller,
                    genderController: widget.controller.genderController,
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
                    textFieldController: widget.controller.phoneController,
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
                      controller: widget.controller.locationController,
                      validator: (v) {
                        return null;
                      }),

                  SizedBox(
                    height: 20.h,
                  ),

                  //========================Save Button===============
                  CustomButton(
                    textColor: AppColors.white50,
                    fillColor: AppColors.black,
                      onTap: () async{
                     final isSuccess = await widget.controller.ownerProfileUpdate();
                      if(isSuccess){
                        AppRouter.route
                            .pushNamed(RoutePath.profileScreen, extra: userRole);
                      }
                    },
                    title: AppStrings.save,
                  ),
                  SizedBox(
                    height: 100.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
