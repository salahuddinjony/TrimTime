import 'package:barber_time/app/core/bottom_navbar.dart';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_booking_card/custom_booking_card.dart';
import 'package:barber_time/app/view/common_widgets/custom_tab_bar/custom_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  bool isUpcomingSelected = true;

  // Mock Data for Upcoming and Previous
  final List<Map<String, String>> upcomingData = [
    {
      "title": "Italian Barbers THL",
      "dateTime": "Fri 28 Sep 2023 at 11:30 AM",
      "location": "Berlin strasse 87",
      "price": "£90",
    },
    {
      "title": "London Barber Shop",
      "dateTime": "Mon 02 Oct 2023 at 1:00 PM",
      "location": "Oxford strasse 45",
      "price": "£75",
    },
  ];

  final List<Map<String, String>> previousData = [
    {
      "title": "Barber Time Salon",
      "dateTime": "Thu 15 Sep 2023 at 10:00 AM",
      "location": "King's Road 58",
      "price": "£50",
    },
    {
      "title": "Cut & Style Studio",
      "dateTime": "Tue 12 Sep 2023 at 9:30 AM",
      "location": "High Street 21",
      "price": "£80",
    },
  ];

  // Method to handle the tab change
  void _onTabSelected(bool isUpcoming) {
    setState(() {
      isUpcomingSelected = isUpcoming; // Update the selected tab state
    });
  }

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
      backgroundColor: AppColors.white50,
      appBar: const CustomAppBar(
        iconData: Icons.arrow_back,
        appBarContent: "Bookings",
        appBarBgColor: AppColors.linearFirst,
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
            // Conditionally render upcoming or previous data based on the selected tab
            Expanded(
              child: ListView.builder(
                itemCount: isUpcomingSelected ? upcomingData.length : previousData.length,
                itemBuilder: (context, index) {
                  final data = isUpcomingSelected ? upcomingData[index] : previousData[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomBookingCard(
                      onTap: () {
                        AppRouter.route.pushNamed(RoutePath.bookingDetailsScreen,
                            extra: userRole);
                      },
                      imageUrl: AppConstants.shop,
                      title: data["title"] ?? "",
                      dateTime: data["dateTime"] ?? "",
                      location: data["location"] ?? "",
                      price: data["price"] ?? "",
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

