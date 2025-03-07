import 'package:barber_time/app/core/bottom_navbar.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:flutter/material.dart';

class OwnerHomeScreen extends StatelessWidget {
  const OwnerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String roleFromDatabase = "barber";
    UserRole userRole = getRoleFromString(roleFromDatabase);
    return Scaffold(
      bottomNavigationBar: BottomNavbar(
        currentIndex: 0,
        role: getRoleFromString(userRole.name),
      ),      appBar: AppBar(title: Text('ownerHome'),)
    );
  }
}
