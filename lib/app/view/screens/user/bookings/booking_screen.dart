import 'package:barber_time/app/core/bottom_navbar.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

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
      bottomNavigationBar: BottomNavbar(currentIndex: 2, role: userRole),
      backgroundColor: AppColors.white50,
      appBar: CustomAppBar(
        appBarContent: "Bookings",
        appBarBgColor: AppColors.linearFirst,
      ),
    );
  }
}
