import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/global/helper/extension/extension.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_booking_card/custom_booking_card.dart';
import 'package:barber_time/app/view/screens/user/home/controller/user_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class CustomerBookingScreen extends StatelessWidget {
  final UserRole userRole;
  CustomerBookingScreen({super.key, required this.userRole});

  final UserHomeController userHomeController = Get.find<UserHomeController>();

  @override
  Widget build(BuildContext context) {
  
    final extra = GoRouter.of(context).state.extra;
    UserRole? userRole;

    if (extra is UserRole) {
      userRole = extra;
    } else if (extra is Map<String, dynamic>) {
      userRole = extra['userRole'] as UserRole?;
    }

    debugPrint("===================${userRole?.name}");
    if (userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.white50,
      appBar: const CustomAppBar(
        iconData: Icons.arrow_back,
        appBarContent: "Customer Bookings",
        appBarBgColor: AppColors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 20),
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await userHomeController.fetchCustomerBookings();
                },
                child: Obx(() {
                  // Filter bookings based on type
                  final filteredBookings =
                      userHomeController.customerBookingList.where((booking) {
                    return booking.bookingType == 'BOOKING';
                  }).toList();

                  // Check loading state
                  if (userHomeController
                      .customerBookingStatus.value.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  // Check error state
                  if (userHomeController.customerBookingStatus.value.isError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline,
                              size: 48, color: Colors.red),
                          SizedBox(height: 16.h),
                          Text(
                            'Failed to load bookings',
                            style: TextStyle(fontSize: 16.sp),
                          ),
                          SizedBox(height: 8.h),
                          ElevatedButton(
                            onPressed: () =>
                                userHomeController.fetchCustomerBookings(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  // Check if no bookings
                  if (filteredBookings.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16.h),
                          // Text(
                          //   isUpcomingSelected
                          //       ? 'No upcoming bookings'
                          //       : 'No previous bookings',
                          //   style: TextStyle(
                          //     fontSize: 18.sp,
                          //     fontWeight: FontWeight.w500,
                          //     color: Colors.grey[600],
                          //   ),
                          // ),
                        ],
                      ),
                    );
                  }

                  // Show bookings list
                  return ListView.builder(
                    itemCount: filteredBookings.length,
                    itemBuilder: (context, index) {
                      final booking = filteredBookings[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomBookingCard(
                          onTap: () {
                            AppRouter.route.pushNamed(
                              RoutePath.bookingDetailsScreen,
                              extra: {
                                'userRole': userRole,
                                'bookingData': booking,
                                'controller': userHomeController,
                              },
                            );
                          },
                          imageUrl: booking.barberImage,
                          title: booking.barberName,
                          dateTime:
                             booking.date.formatDateApi(),
                          location: booking.saloonAddress,
                          price: "£${booking.totalPrice.toStringAsFixed(2)}",
                          // Status Badge
                          badge: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: userHomeController
                                  .getStatusColor(booking.status),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              booking.status,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
