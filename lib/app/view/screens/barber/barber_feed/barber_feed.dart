import 'package:barber_time/app/core/bottom_navbar.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:flutter/material.dart';

class BarberFeed extends StatelessWidget {
  const BarberFeed({super.key});

  @override
  Widget build(BuildContext context) {
    UserRole userRole = getRoleFromString("barber");

    return Scaffold(
      appBar: AppBar(title: const Text('BarberFeed')),
      bottomNavigationBar: BottomNavbar(
        currentIndex: 2,
        role: userRole,
      ),
    );
  }
}
