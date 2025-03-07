import 'package:barber_time/app/core/bottom_navbar.dart';
import 'package:flutter/material.dart';

class OwnerHomeScreen extends StatelessWidget {
  const OwnerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavbar(currentIndex: 0),
      appBar: AppBar(title: Text('ownerHome'),),
    );
  }
}
