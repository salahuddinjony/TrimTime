import 'package:barber_time/app/core/bottom_navbar.dart';
import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
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

import '../../../common_widgets/user_nav_bar/user_nav_bar.dart';

class BerberTimes extends StatelessWidget {
  const BerberTimes({super.key});

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
        bottomNavigationBar: CustomNavBar(currentIndex: 1, role: userRole),

        // floatingActionButton: userRole == UserRole.user
        //     ? IconButton(
        //   onPressed: () {
        //     AppRouter.route.pushNamed(RoutePath.scannerScreen, extra: userRole);
        //   },
        //   icon:Container(
        //     height: 85,
        //     width: 85,
        //     padding: EdgeInsets.all(12.r),  // You can adjust the padding as needed
        //     decoration: const BoxDecoration(
        //       shape: BoxShape.circle,
        //       color: AppColors.navColor,  // Custom color for the button
        //     ),
        //     child: Assets.images.bxScan.image(color: AppColors.black),  // Scanner icon
        //   ),
        // )
        //     : null, // Return null if the role is not 'user'
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        // bottomNavigationBar: BottomNavbar(currentIndex: 1, role: userRole),
        backgroundColor: AppColors.linearFirst,
        appBar: const CustomAppBar(
          appBarContent: AppStrings.barbersTime,
          appBarBgColor: AppColors.linearFirst,
        ),
        body: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomNetworkImage(
                    imageUrl: AppConstants.shop, height: 184, width: double.infinity),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CustomText(
                            top: 10,
                            text: "Barber time",
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: AppColors.gray500,
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: (){
                              AppRouter.route.pushNamed(RoutePath.mapViewScreen,
                                  extra: userRole);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                  color: AppColors.black,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(14))),
                              child: Row(
                                children: [
                                  Assets.icons.liveLocation.svg(),
                                  const CustomText(
                                    left: 10,
                                    text: AppStrings.liveLocation,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10,
                                    color: AppColors.white50,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Row(
                            children: List.generate(5, (index) {
                              return const Icon(
                                Icons.star,
                                color: Colors.black,
                                size: 16,
                              );
                            }),
                          ),
                          const CustomText(
                            text: "(550)",
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                            color: AppColors.gray500,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Row(
                        children: [
                          Icon(
                            Icons.place,
                            color: Colors.black,
                            size: 21,
                          ),
                          CustomText(
                            left: 10,
                            text: "Oldesloer Strasse 82",
                            fontWeight: FontWeight.w500,
                            fontSize: 21,
                            color: AppColors.gray500,
                          ),
                        ],
                      ),
                      const CustomText(
                        top: 16,
                        text: AppStrings.availableBarber,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: AppColors.gray500,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 200,
                        child: GridView.builder(
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 1,
                          ),
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomNetworkImage(
                                  boxShape: BoxShape.circle,
                                  imageUrl: AppConstants.demoImage,
                                  height: 62,
                                  width: 62,
                                ),
                                const SizedBox(height: 8),
                                const CustomText(
                                  text: "Jane Cooper",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: AppColors.gray500,
                                ),
                              ],
                            );
                          },
                        ),
                      ),


                      CustomButton(
                        onTap: () {
                          showChooseBarberDialog(context);
                          // AppRouter.route.pushNamed(RoutePath.queScreen,
                          //     extra: userRole);
                        },
                        fillColor: AppColors.black,
                        title: AppStrings.add,
                        textColor: Colors.white,
                      ),




                      SizedBox(
                        height: 20.h,
                      ),




                    ],
                  ),
                )
              ],
            ),
          ],
        ));
  }

  void showChooseBarberDialog(BuildContext context) {
    // Define a list of selected barbers and services
    List<bool> selectedBarbers = List.filled(5, false);  // Assuming 5 barbers
    List<bool> selectedServices = List.filled(4, false); // 4 service options

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Choice Barber',
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
                // Auto selection
                Row(
                  children: [
                    const Text('Auto', style: TextStyle(fontWeight: FontWeight.w600)),
                    const Spacer(),
                    Checkbox(
                      value: selectedBarbers[4], // Assuming Auto is the last option in the list
                      onChanged: (bool? value) {
                        selectedBarbers[4] = value ?? false;
                        (context as Element).markNeedsBuild();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Services Section
                const Text("Choice you’s Service", style: TextStyle(fontWeight: FontWeight.w600)),
                Column(
                  children: List.generate(4, (index) {
                    List<String> services = ['Hair Cut', 'Shaving', 'Beard Trim', 'Massage'];
                    return Row(
                      children: [
                        Text(services[index]),
                        const Spacer(),
                        Checkbox(
                          value: selectedServices[index],
                          onChanged: (bool? value) {
                            selectedServices[index] = value ?? false;
                            // Refresh the UI
                            (context as Element).markNeedsBuild();
                          },
                        ),
                      ],
                    );
                  }),
                ),
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
                print("Selected Barbers: ${selectedBarbers.where((e) => e).toList()}");
                print("Selected Services: ${selectedServices.where((e) => e).toList()}");
                AppRouter.route.pushNamed(RoutePath.queScreen,
                    extra: UserRole.user);
                // Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Save Queue'),
            ),
          ],
        );
      },
    );
  }
}
