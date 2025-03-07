import 'package:barber_time/app/core/bottom_navbar.dart';
import 'package:flutter/material.dart';

class OwnerMessagingScreen extends StatelessWidget {
  const OwnerMessagingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      bottomNavigationBar: BottomNavbar(currentIndex: 1),

      appBar: AppBar(title: Text('OwnerMessagingScreen'),),
    );
  }
}
