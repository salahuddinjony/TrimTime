import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_booking_card/custom_booking_card.dart';
import 'package:barber_time/app/view/common_widgets/custom_tab_bar/custom_tab_bar.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/controller/barber_home_controller.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/models/barber_booking/barber_booking_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  final UserRole userRole;
  final bool isBarber;
  const BookingScreen(
      {super.key, required this.userRole, this.isBarber = false});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  bool isUpcomingSelected = true;
  final BarberHomeController barberHomeController =
      Get.find<BarberHomeController>();

  @override
  void initState() {
    super.initState();
    // Fetch bookings when screen loads
    barberHomeController.fetchBookings();
  }

  // Method to handle the tab change
  void _onTabSelected(bool isUpcoming) {
    setState(() {
      isUpcomingSelected = isUpcoming; // Update the selected tab state
    });
  }

  // Filter bookings based on status
  List<BarberBookingData> getFilteredBookings() {
    if (isUpcomingSelected) {
      // Upcoming: CONFIRMED and PENDING status
      return barberHomeController.bookings
          .where((booking) =>
              (booking.status == 'CONFIRMED' || booking.status == 'PENDING') && booking.bookingType != 'QUEUE')
          .toList();
    } else {
      // Previous: COMPLETED and CANCELLED status
      return barberHomeController.bookings
          .where((booking) =>
              booking.status == 'COMPLETED' || booking.status == 'CANCELLED')
          .toList();
    }
  }

  // Format date time for display
  String formatDateTime(DateTime dateTime) {
    return DateFormat('EEE dd MMM yyyy \'at\' hh:mm a').format(dateTime);
  }

  // Get status badge color
  Color getStatusColor(String status) {
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
        appBarContent: "Bookings",
        appBarBgColor: AppColors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 20),
        child: Column(
          children: [
            // Pass the isUpcomingSelected state to the CustomTabBar to manage the tab state and color
            CustomTabBar(
              onTabSelected: _onTabSelected,
              isUpcomingSelected: isUpcomingSelected,
            ),
            SizedBox(
              height: 10.h,
            ),
            // Show bookings based on API data
            Expanded(
              child: Obx(() {
                // Check loading state
                if (barberHomeController.bookingStatus.value.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // Check error state
                if (barberHomeController.bookingStatus.value.isError) {
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
                          onPressed: () => barberHomeController.fetchBookings(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                // Get filtered bookings
                final filteredBookings = getFilteredBookings();

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

                // Show bookings list
                return ListView.builder(
                  itemCount: filteredBookings.length,
                  itemBuilder: (context, index) {
                    final booking = filteredBookings[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomBookingCard(
                        onTap: () {
                          if (widget.isBarber) {
                            debugPrint(
                                'Navigating to Booking Details for Barber');
                            AppRouter.route.pushNamed(
                              RoutePath.bookingDetailsScreen,
                              extra: {
                                'userRole': userRole,
                                'bookingData': booking,
                              },
                            );
                          }
                        },
                        imageUrl: booking.userImage ?? AppConstants.shop,
                        title: booking.userFullName,
                        dateTime: formatDateTime(booking.startDateTime),
                        location: booking.userEmail,
                        price: "£${booking.totalPrice.toStringAsFixed(2)}",
                        // Status Badge
                        badge: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: getStatusColor(booking.status),
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
          ],
        ),
      ),
    );
  }
}
