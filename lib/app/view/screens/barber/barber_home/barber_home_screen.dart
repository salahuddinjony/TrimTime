import 'package:barber_time/app/core/bottom_navbar.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:flutter/material.dart';

class BarberHomeScreen extends StatelessWidget {
  const BarberHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UserRole userRole = getRoleFromString("barber");

    return Scaffold(
      appBar: AppBar(title: const Text('barber Home')),
      bottomNavigationBar: BottomNavbar(
        currentIndex: 0,
        role: userRole,
      ),
    );
  }
}
