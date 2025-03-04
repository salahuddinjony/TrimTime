import 'package:barber_time/app/core/bottom_navbar.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import 'package:barber_time/app/view/common_widgets/curved_short_clipper/curved_short_clipper.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // String roleFromDatabase = "user";
    // UserRole userRole = getRoleFromString(roleFromDatabase);
    // return Scaffold(
    //   bottomNavigationBar: RoleBasedBottomNav(role: userRole),
    //
    // );
    return Scaffold(
      body: ClipPath(
        clipper: CurvedShortClipper(),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height/2, // Adjust height according to your design
          color: Color(0xFFB36A51), // Brown color similar to your design
          child: Center(
            child: Text(
              'Your Content Here',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      )
    );
  }
}

