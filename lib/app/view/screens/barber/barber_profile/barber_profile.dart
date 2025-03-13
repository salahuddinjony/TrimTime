import 'package:barber_time/app/core/bottom_navbar.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:flutter/material.dart';

class BarberProfile extends StatelessWidget {
  const BarberProfile({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Direct UserRole সেট করা
    UserRole userRole = getRoleFromString("barber");

    return Scaffold(
      appBar: AppBar(title: const Text('Barber Profile')),
      bottomNavigationBar: BottomNavbar(
        currentIndex: 4,
        role: userRole,
      ),
    );
  }
}
