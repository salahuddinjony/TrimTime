import 'package:barber_time/app/core/bottom_navbar.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:flutter/material.dart';

class OwnerHomeScreen extends StatelessWidget {
  const OwnerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Direct UserRole সেট করা
    UserRole userRole = getRoleFromString("owner");

    return Scaffold(
      appBar: AppBar(title: const Text('Owner Home')),
      bottomNavigationBar: BottomNavbar(
        currentIndex: 0,
        role: userRole, // ✅ Direct পাঠানো হচ্ছে
      ),
    );
  }
}
