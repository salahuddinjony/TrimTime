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
import 'package:barber_time/app/view/screens/owner/owner_que/controller/que_controller.dart';
import 'package:barber_time/app/view/screens/owner/owner_que/widgets/open_bottom_sheet.dart';
import 'package:barber_time/app/view/screens/user/home/controller/user_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class BerberTimes extends StatelessWidget {
  final UserRole? userRole;
  final UserHomeController? controller;
  const BerberTimes({super.key, this.userRole, this.controller});

  @override
  Widget build(BuildContext context) {
    final extra = GoRouter.of(context).state.extra;
    UserRole? extractedUserRole;
    UserHomeController? extractedController;

    if (extra is UserRole) {
      extractedUserRole = extra;
    } else if (extra is Map) {
      try {
        extractedUserRole = extra['userRole'] as UserRole?;
        extractedController = extra['controller'] as UserHomeController?;
      } catch (_) {
        extractedUserRole = null;
      }
    }

    // Use the extracted values or fallback to constructor params
    final activeUserRole = extractedUserRole ?? userRole;
    final activeController =
        extractedController ?? controller ?? Get.find<UserHomeController>();

    if (activeUserRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }

    return Scaffold(
      // bottomNavigationBar: CustomNavBar(currentIndex: 1, role: activeUserRole),
      backgroundColor: AppColors.searchScreenBg,
      appBar: const CustomAppBar(
        appBarContent: AppStrings.barbersTime,
        appBarBgColor: AppColors.searchScreenBg,
      ),
      body: Obx(() {
        // Check loading state
        if (activeController.queListStatus.value.isLoading) {
          return _buildShimmerLoading();
        }

        // Check error state
        if (activeController.queListStatus.value.isError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Failed to load salon data',
                  style: TextStyle(fontSize: 16.sp),
                ),
              ],
            ),
          );
        }

        final salonData = activeController.queList.value;

        // If no data available
        if (salonData == null) {
          return const Center(
            child: Text('No salon data available'),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await activeController.fetchQueList(
              ownerId: salonData.saloonOwnerId,
            );
          },
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomNetworkImage(
                      imageUrl: salonData.shopLogo.isNotEmpty
                          ? salonData.shopLogo
                          : AppConstants.shop,
                      height: 184,
                      width: double.infinity),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.content_cut,
                                    color: AppColors.black,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: CustomText(
                                      top: 10,
                                      text: salonData.shopName,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22,
                                      color: AppColors.black,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                AppRouter.route.pushNamed(
                                  RoutePath.mapViewScreen,
                                  extra: activeUserRole,
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(top: 10),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.black,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Assets.icons.liveLocation
                                        .svg(width: 10, height: 10),
                                    const SizedBox(width: 8),
                                    const CustomText(
                                      text: AppStrings.liveLocation,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: AppColors.white50,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            const Icon(
                              Icons.place,
                              color: Colors.black,
                              size: 21,
                            ),
                            CustomText(
                              left: 10,
                              text: salonData.shopAddress,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: AppColors.gray500,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        GestureDetector(
                          onTap: () {
                            activeController.getBarberReviews(
                                userId: salonData.saloonOwnerId);
                            context.pushNamed(
                              RoutePath.reviewsScreen,
                              extra: {
                                'userRole': activeUserRole,
                                'userId': salonData.saloonOwnerId,
                                'controller': activeController,
                                'salonName': salonData.shopName,
                              },
                            );
                            debugPrint("Rating badge clicked");
                          },
                          child: Center(
                            child: Container(
                              margin: const EdgeInsets.only(top: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.gray500.withOpacity(0.2),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: List.generate(5, (index) {
                                      return Icon(
                                        index < salonData.avgRating.floor()
                                            ? Icons.star
                                            : index < salonData.avgRating
                                                ? Icons.star_half
                                                : Icons.star_border,
                                        color: Colors.amber,
                                        size: 14,
                                      );
                                    }),
                                  ),
                                  const SizedBox(width: 6),
                                  CustomText(
                                    text:
                                        salonData.avgRating.toStringAsFixed(1),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: AppColors.black,
                                  ),
                                  const SizedBox(width: 4),
                                  CustomText(
                                    text: "(${salonData.ratingCount})",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: AppColors.gray500.withOpacity(0.7),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 12,
                                    color: AppColors.gray500.withOpacity(0.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
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
                          child: salonData.barbers.isEmpty
                              ? const Center(
                                  child: Text('No barbers available'),
                                )
                              : GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                    childAspectRatio: 1,
                                  ),
                                  itemCount: salonData.barbers.length,
                                  itemBuilder: (context, index) {
                                    final barber = salonData.barbers[index];
                                    return GestureDetector(
                                      onTap: () {
                                        debugPrint(
                                            "Navigating to Queue Screen for ${barber.name}");
                                        debugPrint(
                                            "Barber ID: ${barber.barberId}");
                                        controller?.fetchBarbersCustomerQue(
                                            isToday: true,
                                            saloonOwnerId:
                                                salonData.saloonOwnerId,
                                            barberId: barber.barberId);
                                        AppRouter.route.pushNamed(
                                          RoutePath.queScreen,
                                          extra: {
                                            'userRole': userRole,
                                            'barberId': barber.barberId,
                                            'controller': controller,
                                            'saloonOwnerId':
                                                salonData.saloonOwnerId,
                                          },
                                        );
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomNetworkImage(
                                            boxShape: BoxShape.circle,
                                            imageUrl: barber.image.isNotEmpty
                                                ? barber.image
                                                : AppConstants.demoImage,
                                            height: 62,
                                            width: 62,
                                          ),
                                          const SizedBox(height: 8),
                                          CustomText(
                                            text: barber.name,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                            color: AppColors.gray500,
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),
                        SizedBox(
                          height: 40.h,
                        ),
                        CustomButton(
                          onTap: () {
                            controller?.getServices();

                            OpenBottomSheet.showChooseBarberBottomSheet<
                                UserHomeController>(
                              context,
                              controller: controller!,
                            );
                          },
                          textColor: AppColors.white,
                          fillColor: AppColors.black,
                          title: "Add to Queue",
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
          ),
        );
      }),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shop image shimmer
              Container(
                height: 184,
                width: double.infinity,
                color: Colors.white,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Shop name and location button shimmer
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(top: 10),
                            height: 24,
                            width: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          height: 40,
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Rating shimmer
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            return Container(
                              margin: const EdgeInsets.only(right: 4),
                              width: 16,
                              height: 16,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            );
                          }),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          height: 16,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Address shimmer
                    Row(
                      children: [
                        Container(
                          width: 21,
                          height: 21,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            height: 18,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Available barber title shimmer
                    Container(
                      height: 20,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Barber grid shimmer
                    SizedBox(
                      height: 200,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1,
                        ),
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 62,
                                width: 62,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 12,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 40.h),
                    // Button shimmer
                    Container(
                      height: 56.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // static void showChooseBarberDialog(BuildContext context) {
  //   // Define a list of selected barbers and services
  //   List<bool> selectedBarbers = List.filled(5, false); // Assuming 5 barbers
  //   List<bool> selectedServices = List.filled(4, false); // 4 service options

  //   showDialog(
  //     context: context,
  //     barrierDismissible:
  //         false, // Prevent dismissing the dialog by tapping outside
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(15),
  //         ),
  //         title: const Text(
  //           'Choice Barber',
  //           style: TextStyle(fontWeight: FontWeight.w600),
  //         ),
  //         content: SingleChildScrollView(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               // List of Barbers
  //               Column(
  //                 children: List.generate(5, (index) {
  //                   return Row(
  //                     children: [
  //                       CustomNetworkImage(
  //                         imageUrl: AppConstants.demoImage,
  //                         height: 30,
  //                         width: 30,
  //                         boxShape: BoxShape.circle,
  //                       ),
  //                       const SizedBox(width: 12),
  //                       Text('Jane Cooper'),
  //                       const Spacer(),
  //                       Checkbox(
  //                         value: selectedBarbers[index],
  //                         onChanged: (bool? value) {
  //                           selectedBarbers[index] = value ?? false;
  //                           // Refresh the UI
  //                           (context as Element).markNeedsBuild();
  //                         },
  //                       ),
  //                     ],
  //                   );
  //                 }),
  //               ),
  //               const SizedBox(height: 20),
  //               // Auto selection
  //               Row(
  //                 children: [
  //                   const Text('Auto',
  //                       style: TextStyle(fontWeight: FontWeight.w600)),
  //                   const Spacer(),
  //                   Checkbox(
  //                     value: selectedBarbers[
  //                         4], // Assuming Auto is the last option in the list
  //                     onChanged: (bool? value) {
  //                       selectedBarbers[4] = value ?? false;
  //                       (context as Element).markNeedsBuild();
  //                     },
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 20),
  //               // Services Section
  //               const Text("Choice you’s Service",
  //                   style: TextStyle(fontWeight: FontWeight.w600)),
  //               Column(
  //                 children: List.generate(4, (index) {
  //                   List<String> services = [
  //                     'Hair Cut',
  //                     'Shaving',
  //                     'Beard Trim',
  //                     'Massage'
  //                   ];
  //                   return Row(
  //                     children: [
  //                       Text(services[index]),
  //                       const Spacer(),
  //                       Checkbox(
  //                         value: selectedServices[index],
  //                         onChanged: (bool? value) {
  //                           selectedServices[index] = value ?? false;
  //                           // Refresh the UI
  //                           (context as Element).markNeedsBuild();
  //                         },
  //                       ),
  //                     ],
  //                   );
  //                 }),
  //               ),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Close the dialog
  //             },
  //             child: const Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               // Handle saving the queue
  //               // Print selected barbers and services (you can replace this with saving functionality)
  //               print(
  //                   "Selected Barbers: ${selectedBarbers.where((e) => e).toList()}");
  //               print(
  //                   "Selected Services: ${selectedServices.where((e) => e).toList()}");
  //               AppRouter.route
  //                   .pushNamed(RoutePath.queScreen, extra: UserRole.user);
  //               // Navigator.of(context).pop(); // Close the dialog
  //             },
  //             child: const Text('Save Queue'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
