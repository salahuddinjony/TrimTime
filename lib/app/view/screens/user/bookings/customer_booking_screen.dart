import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/global/helper/extension/extension.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_booking_card/custom_booking_card.dart';
import 'package:barber_time/app/view/screens/user/home/controller/user_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class CustomerBookingScreen extends StatelessWidget {
  final UserRole userRole;
  final String bookingType;

  CustomerBookingScreen(
      {super.key, required this.userRole, required this.bookingType});

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
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        appBarBgColor: AppColors.searchScreenBg,
        appBarContent: "Customer ${bookingType.safeCap()}'s",
        iconData: Icons.arrow_back,
        onTap: () {
          AppRouter.route.pop();
        },
      ),
      floatingActionButton: Obx(() {
        // Hide FAB when loading
        if (userHomeController.customerBookingStatus.value.isLoading) {
          return const SizedBox.shrink();
        }
        return FloatingActionButton(
          onPressed: () {
            if(bookingType.toLowerCase() == 'queue') {
              AppRouter.route.pushNamed(
                RoutePath.scannerScreen,
                extra: {
                  'userRole': userRole,
                },
              );
              return;
            }
        AppRouter.route.pushNamed(
          RoutePath.nearYouShopScreen,
          extra: {
            'userRole': userRole,
          },
        );
          },
          backgroundColor: AppColors.app, 
          child:  Icon(
       bookingType.toLowerCase() == 'queue' ? Icons.qr_code_scanner : Icons.add,
        color: Colors.white,
          ),
        );
      }),
      body: Stack(
        children: [
          // Curved banner background
          ClipPath(
            clipper: CurvedBannerClipper(),
            child: Container(
              height: 600.h,
              decoration: const BoxDecoration(
                color: AppColors.searchScreenBg,
              ),
            ),
          ),
          // Content on top
          Obx(() {
            // Filter bookings based on type
            final filteredBookings =
                userHomeController.customerBookingList.where((booking) {
              return booking.bookingType.toLowerCase() ==
                  bookingType.toLowerCase();
            }).toList();

            // Check loading state
            if (userHomeController.customerBookingStatus.value.isLoading) {
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 10.h),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildShimmerBookingCard(),
                  );
                },
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
                      bookingType.toLowerCase() == 'queue'
                          ? Icons.qr_code_scanner
                          : Icons.calendar_today_outlined,
                      size: 64,
                      color: Colors.white.withValues(alpha: .8),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      bookingType.toLowerCase() == 'queue'
                          ? 'No queues found'
                          : 'No bookings found',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (bookingType.toLowerCase() == 'queue') ...[
                      SizedBox(height: 24.h),
                      ElevatedButton.icon(
                        onPressed: () {
                          AppRouter.route.pushNamed(
                            RoutePath.scannerScreen,
                            extra: userRole,
                          );
                        },
                        icon: const Icon(Icons.qr_code_scanner),
                        label: const Text('Scan Shop QR Code'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.black,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 12.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }

            // Show bookings list
            return RefreshIndicator(
              onRefresh: () async {
                await userHomeController.fetchCustomerBookings();
              },
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 10.h),
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
                            'bookingType': bookingType,
                          },
                        );
                      },
                      imageUrl: booking.barberImage,
                      title: booking.barberName,
                      dateTime: booking.date.formatDateApi(),
                      location: booking.saloonAddress,
                      price: "£${booking.totalPrice.toStringAsFixed(2)}",
                      // Status Badge
                      badge: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color:
                              userHomeController.getStatusColor(booking.status),
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
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildShimmerBookingCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.all(10.w),
        child: Row(
          children: [
            // Image placeholder
            Container(
              height: 83.h,
              width: 115.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            SizedBox(width: 10.w),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title placeholder
                  Container(
                    width: 120.w,
                    height: 13.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  // DateTime placeholder
                  Container(
                    width: 100.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Location placeholder
                  Row(
                    children: [
                      Container(
                        width: 16.w,
                        height: 16.h,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Container(
                          height: 12.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            // Badge and Price column
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Badge placeholder
                Container(
                  width: 50.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                SizedBox(height: 24.h),
                // Price placeholder
                Container(
                  width: 60.w,
                  height: 14.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
