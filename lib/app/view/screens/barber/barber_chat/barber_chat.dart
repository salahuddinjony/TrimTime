import 'package:barber_time/app/core/bottom_navbar.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:flutter/material.dart';

class BarberChat extends StatelessWidget {
  const BarberChat({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Direct UserRole সেট করা
    UserRole userRole = getRoleFromString("barber");

    return Scaffold(
      appBar: AppBar(title: const Text('BarberChat')),
      bottomNavigationBar: BottomNavbar(
        currentIndex: 1,
        role: userRole,
      ),
    );
  }
}
