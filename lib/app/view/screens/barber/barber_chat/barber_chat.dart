import 'package:barber_time/app/core/bottom_navbar.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BarberChat extends StatelessWidget {
  const BarberChat({super.key});

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
    return Scaffold(
      appBar: AppBar(title: const Text('BarberChat')),
      bottomNavigationBar: BottomNavbar(
        currentIndex: 1,
        role: userRole,
      ),
    );
  }
}
