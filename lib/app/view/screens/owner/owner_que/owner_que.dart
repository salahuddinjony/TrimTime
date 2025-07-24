import 'package:barber_time/app/core/bottom_navbar.dart';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';

class OwnerQue extends StatefulWidget {
  const OwnerQue({super.key});

  @override
  State<OwnerQue> createState() => _OwnerQueState();
}

class _OwnerQueState extends State<OwnerQue> {
  bool isQueueEnabled = false; // State for the toggle switch

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
          currentIndex: 1,
          role: userRole,
        ),
        backgroundColor: AppColors.white,
        appBar: const CustomAppBar(
          appBarContent: AppStrings.activeNow,
          appBarBgColor: AppColors.linearFirst,
        ),
        body: ClipPath(
            clipper: CurvedBannerClipper(),
            child: Container(
              height: MediaQuery.of(context).size.height / 1.5,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xCCEDBC9F), // First color (with opacity)
                    Color(0xFFE98952),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            CustomNetworkImage(
                              imageUrl: AppConstants.demoImage,
                              height: 62,
                              width: 62,
                              boxShape: BoxShape.circle,
                            ),
                            CustomText(
                              text: "Jane Cooper",
                              fontSize: 13.sp,
                              top: 8,
                              fontWeight: FontWeight.w500,
                              color: AppColors.gray500,
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 20.h,
                            ),
                            CustomText(
                              textAlign: TextAlign.end,
                              text: "9:00-11:00",
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.gray500,
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10.r),
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: AppColors.black),
                                      shape: BoxShape.circle),
                                  child: CustomText(
                                    text: "1",
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 20.h,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    AppRouter.route.pushNamed(
                                        RoutePath.queScreen,
                                        extra: userRole);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10.r),
                                    decoration: BoxDecoration(
                                      color: AppColors.black,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: CustomText(
                                      text: "See Queue",
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 35.h,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            CustomNetworkImage(
                              imageUrl: AppConstants.demoImage,
                              height: 62,
                              width: 62,
                              boxShape: BoxShape.circle,
                            ),
                            CustomText(
                              text: "Jane Cooper",
                              fontSize: 13.sp,
                              top: 8,
                              fontWeight: FontWeight.w500,
                              color: AppColors.gray500,
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 20.h,
                            ),
                            CustomText(
                              textAlign: TextAlign.end,
                              text: "9:00-11:00",
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.gray500,
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10.r),
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: AppColors.black),
                                      shape: BoxShape.circle),
                                  child: CustomText(
                                    text: "2",
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 20.h,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    AppRouter.route.pushNamed(
                                        RoutePath.queScreen,
                                        extra: userRole);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10.r),
                                    decoration: BoxDecoration(
                                      color: AppColors.black,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: CustomText(
                                      text: "See Queue",
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.all(5.r),
                          decoration: BoxDecoration(
                              border: Border.all(color: AppColors.black),
                              borderRadius: BorderRadius.circular(8)),
                          child: const Text(
                            'Enable',
                            style:
                                TextStyle(fontSize: 16, color: AppColors.white),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Switch(
                          activeTrackColor: AppColors.black,
                          activeColor: AppColors.secondary,
                          value: isQueueEnabled,
                          onChanged: (bool value) {
                            setState(() {
                              isQueueEnabled = value; // Update the state
                            });
                            debugPrint(
                                'Queue is ${isQueueEnabled ? 'enabled' : 'disabled'}');
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    CustomButton(
                      onTap: () {
                        showChooseBarberDialog(context);
                      },
                      textColor: AppColors.white,
                      fillColor: AppColors.black,
                      title: AppStrings.addNewCustomer,
                    ),
                    SizedBox(
                      height: 20.h,
                    )
                  ],
                ),
              ),
            )));
  }

  void showChooseBarberDialog(BuildContext context) {
    // Define a list of selected barbers and services
    List<bool> selectedBarbers = List.filled(5, false); // Assuming 5 barbers
    List<bool> selectedServices = List.filled(4, false); // 4 service options

    showDialog(
      context: context,
      barrierDismissible: false,
      // Prevent dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Chose Customer',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // List of Barbers
                Column(
                  children: List.generate(5, (index) {
                    return Row(
                      children: [
                        CustomNetworkImage(
                          imageUrl: AppConstants.demoImage,
                          height: 30,
                          width: 30,
                          boxShape: BoxShape.circle,
                        ),
                        const SizedBox(width: 12),
                        Text('Jane Cooper'),
                        const Spacer(),
                        Checkbox(
                          value: selectedBarbers[index],
                          onChanged: (bool? value) {
                            selectedBarbers[index] = value ?? false;
                            // Refresh the UI
                            (context as Element).markNeedsBuild();
                          },
                        ),
                      ],
                    );
                  }),
                ),
                const SizedBox(height: 20),
                // // Auto selection
                // Row(
                //   children: [
                //     const Text('Auto', style: TextStyle(fontWeight: FontWeight.w600)),
                //     const Spacer(),
                //     Checkbox(
                //       value: selectedBarbers[4], // Assuming Auto is the last option in the list
                //       onChanged: (bool? value) {
                //         selectedBarbers[4] = value ?? false;
                //         (context as Element).markNeedsBuild();
                //       },
                //     ),
                //   ],
                // ),
                // const SizedBox(height: 20),
                // // Services Section
                // const Text("Choice you’s Service", style: TextStyle(fontWeight: FontWeight.w600)),
                // Column(
                //   children: List.generate(4, (index) {
                //     List<String> services = ['Hair Cut', 'Shaving', 'Beard Trim', 'Massage'];
                //     return Row(
                //       children: [
                //         Text(services[index]),
                //         const Spacer(),
                //         Checkbox(
                //           value: selectedServices[index],
                //           onChanged: (bool? value) {
                //             selectedServices[index] = value ?? false;
                //             // Refresh the UI
                //             (context as Element).markNeedsBuild();
                //           },
                //         ),
                //       ],
                //     );
                //   }),
                // ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle saving the queue
                // Print selected barbers and services (you can replace this with saving functionality)
                print(
                    "Selected Barbers: ${selectedBarbers.where((e) => e).toList()}");
                print(
                    "Selected Services: ${selectedServices.where((e) => e).toList()}");

                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Save Queue'),
            ),
          ],
        );
      },
    );
  }
}
