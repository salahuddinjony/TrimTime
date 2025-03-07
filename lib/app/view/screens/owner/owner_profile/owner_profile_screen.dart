import 'package:barber_time/app/core/bottom_navbar.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:flutter/material.dart';

class OwnerProfileScreen extends StatelessWidget {
  const OwnerProfileScreen({super.key,});

  @override
  Widget build(BuildContext context) {
    String roleFromDatabase = "owner";
    UserRole userRole = getRoleFromString(roleFromDatabase);
    return Scaffold(
        bottomNavigationBar: BottomNavbar(
          currentIndex: 3,
          role: getRoleFromString(userRole.name),
        ),      appBar: AppBar(title: Text('profile'),)
    );
  }
}
