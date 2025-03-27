import 'package:barber_time/app/core/bottom_navbar.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OwnerQue extends StatelessWidget {
  const OwnerQue({super.key});

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
    return  Scaffold(
      bottomNavigationBar: BottomNavbar(
        currentIndex: 1,
        role: userRole,
      ),
      backgroundColor: AppColors.linearFirst,
      appBar: const CustomAppBar(
        appBarContent: AppStrings.barbersTime,
        appBarBgColor: AppColors.linearFirst,
      ),
    );
  }
}
