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

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final extra = GoRouter.of(context).state.extra;
    UserRole? userRole;
    if (extra is UserRole) {
      userRole = extra;
    } else if (extra is Map) {
      try {
        userRole = extra['userRole'] as UserRole?;
      } catch (_) {
        userRole = null;
      }
    }

    if (userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }
    return Scaffold(
      bottomNavigationBar: BottomNavbar(currentIndex: 2, role: userRole),
      backgroundColor: AppColors.white50,
      appBar: const CustomAppBar(
        appBarContent: "Bookings",
        appBarBgColor: AppColors.linearFirst,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 20),
        child: Column(
          children: [
            const CustomTabBar(),
            SizedBox(
              height: 10.h,
            ),
            CustomBookingCard(
              onTap: (){
                AppRouter.route.pushNamed(RoutePath.bookingDetailsScreen,
                    extra: userRole);
              },
              imageUrl: AppConstants.shop,
              title: "Italian Barbers THL",
              dateTime: "Fri 28 Sep 2023 at 11:30 AM",
              location: "Berlin strasse 87",
              price: "£90",
            )
          ],
        ),
      ),
    );
  }
}
