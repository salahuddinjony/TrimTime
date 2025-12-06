import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/global/helper/extension/extension.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_booking_card/custom_booking_card.dart';
import 'package:barber_time/app/view/common_widgets/custom_tab_bar/custom_tab_bar.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/controller/barber_home_controller.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/models/barber_booking/barber_booking_model.dart';
import 'package:barber_time/app/view/screens/user/home/controller/user_home_controller.dart';
import 'package:barber_time/app/view/screens/user/bookings/models/customer_bookins_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class BookingScreen extends StatefulWidget {
  final UserRole userRole;
  final bool isBarber;
  final UserHomeController? controller;
  const BookingScreen(
      {super.key,
      required this.userRole,
      this.isBarber = false,
      this.controller});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  bool isUpcomingSelected = true;
  BarberHomeController? barberHomeController;
  UserHomeController? userHomeController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers based on user role
    if (widget.isBarber) {
      barberHomeController = Get.find<BarberHomeController>();
      barberHomeController!.fetchBookings();
    } else {
      userHomeController = widget.controller ?? Get.find<UserHomeController>();
      userHomeController!.fetchCustomerBookings();
    }
  }

  // Method to handle the tab change
  void _onTabSelected(bool isUpcoming) {
    setState(() {
      isUpcomingSelected = isUpcoming; // Update the selected tab state
    });
  }

  // Filter barber bookings based on status
  List<BarberBookingData> getFilteredBarberBookings() {
    if (isUpcomingSelected) {
      // Upcoming: CONFIRMED and PENDING status
      return barberHomeController!.bookings
          .where((booking) =>
              (booking.status == 'CONFIRMED' || booking.status == 'PENDING') &&
              booking.bookingType != 'QUEUE')
          .toList();
    } else {
      // Previous: COMPLETED and CANCELLED status
      return barberHomeController!.bookings
          .where((booking) =>
              booking.status == 'COMPLETED' || booking.status == 'CANCELLED')
          .toList();
    }
  }

  // Filter customer bookings based on type
  List<CustomerBooking> getFilteredCustomerBookings() {
    if (isUpcomingSelected) {
      // Bookings: Regular bookings (not QUEUE)
      return userHomeController!.customerBookingList
          .where((booking) => booking.bookingType != 'QUEUE')
          .toList();
    } else {
      // Queues: Only QUEUE type bookings
      return userHomeController!.customerBookingList
          .where((booking) => booking.bookingType == 'QUEUE')
          .toList();
    }
  }

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
      appBar: CustomAppBar(
        iconData: Icons.arrow_back,
        appBarContent: widget.isBarber ? "Bookings" : "Bookings & Queues",
        appBarBgColor: AppColors.white,
      ),
      floatingActionButton: Obx(() {
        // Check if data is loading
        final isLoading = widget.isBarber
            ? barberHomeController!.bookingStatus.value.isLoading
            : userHomeController!.customerBookingStatus.value.isLoading;

        // Hide FAB when loading or when user is barber
        if (widget.isBarber || isLoading) {
          return const SizedBox.shrink();
        }

        return FloatingActionButton(
          onPressed: () {
            // Determine bookingType based on selected tab
            final bookingType = isUpcomingSelected ? 'booking' : 'queue';
            
            if (bookingType.toLowerCase() == 'queue') {
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
          child: Icon(
            isUpcomingSelected ? Icons.add : Icons.qr_code_scanner,
            color: Colors.white,
          ),
        );
      }),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 20),
        child: Column(
          children: [
            // Pass the isUpcomingSelected state to the CustomTabBar to manage the tab state and color
            CustomTabBar(
              onTabSelected: _onTabSelected,
              isUpcomingSelected: isUpcomingSelected,
              firstTabLabel: widget.isBarber ? 'Upcoming' : 'Bookings',
              secondTabLabel: widget.isBarber ? 'Previous' : 'Queues',
            ),
            SizedBox(
              height: 10.h,
            ),
            // Show bookings based on API data
            Expanded(
              child: Obx(() {
                // Check loading state
                final isLoading = widget.isBarber
                    ? barberHomeController!.bookingStatus.value.isLoading
                    : userHomeController!.customerBookingStatus.value.isLoading;

                if (isLoading) {
                  return ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildShimmerBookingCard(),
                    ),
                  );
                }

                // Check error state
                final isError = widget.isBarber
                    ? barberHomeController!.bookingStatus.value.isError
                    : userHomeController!.customerBookingStatus.value.isError;

                if (isError) {
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
                          onPressed: () {
                            if (widget.isBarber) {
                              barberHomeController!.fetchBookings();
                            } else {
                              userHomeController!.fetchCustomerBookings();
                            }
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                // Get filtered bookings based on role with refresh indicator
                return RefreshIndicator(
                  onRefresh: () async {
                    if (widget.isBarber) {
                      await barberHomeController!.fetchBookings();
                    } else {
                      await userHomeController!.fetchCustomerBookings();
                    }
                  },
                  child: widget.isBarber
                      ? _buildBarberBookingsList(userRole!)
                      : _buildCustomerBookingsList(userRole!),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarberBookingsList(UserRole userRole) {
    final filteredBookings = getFilteredBarberBookings();

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
            Text(
              isUpcomingSelected
                  ? 'No upcoming bookings'
                  : 'No previous bookings',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredBookings.length,
      itemBuilder: (context, index) {
        final booking = filteredBookings[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomBookingCard(
            onTap: () {
              debugPrint('Navigating to Booking Details for Barber');
              AppRouter.route.pushNamed(
                RoutePath.bookingDetailsScreen,
                extra: {
                  'userRole': userRole,
                  'bookingData': booking,
                  'controller': barberHomeController,
                },
              );
            },
            imageUrl: booking.userImage ?? AppConstants.shop,
            title: booking.userFullName,
            dateTime: booking.startDateTime.formatDateApi(),
            location: booking.userEmail,
            price: "£${booking.totalPrice.toStringAsFixed(2)}",
            badge: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 8.w,
                vertical: 4.h,
              ),
              decoration: BoxDecoration(
                color: barberHomeController!.getStatusColor(booking.status),
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
  }

  Widget _buildCustomerBookingsList(UserRole userRole) {
    final filteredBookings = getFilteredCustomerBookings();

    if (filteredBookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isUpcomingSelected
                  ? Icons.calendar_today_outlined
                  : Icons.qr_code_scanner,
              size: 64,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16.h),
            Text(
              isUpcomingSelected ? 'No bookings found' : 'No queues found',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            if (!isUpcomingSelected) ...[
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
                  backgroundColor: AppColors.secondary,
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
                  'bookingType': isUpcomingSelected ? 'BOOKING' : 'QUEUE',
                },
              );
            },
            imageUrl: booking.barberImage.isNotEmpty
                ? booking.barberImage
                : AppConstants.shop,
            title: booking.barberName,
            dateTime: booking.date.formatDateApi(),
            location: booking.saloonAddress,
            price: "£${booking.totalPrice.toStringAsFixed(2)}",
            badge: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 8.w,
                vertical: 4.h,
              ),
              decoration: BoxDecoration(
                color: _getCustomerStatusColor(booking.status),
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
  }

  Color _getCustomerStatusColor(String status) {
    switch (status) {
      case 'CONFIRMED':
        return Colors.green;
      case 'PENDING':
        return Colors.orange;
      case 'COMPLETED':
        return Colors.blue;
      case 'CANCELLED':
        return Colors.red;
      default:
        return Colors.grey;
    }
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
                SizedBox(height: 30.h),
                // Price placeholder
                Container(
                  width: 60.w,
                  height: 15.h,
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
