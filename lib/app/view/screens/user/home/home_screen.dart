import 'package:barber_time/app/core/bottom_navbar.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userRole = GoRouterState.of(context).extra as UserRole?;
    debugPrint("Selected Role============================${userRole?.name}");
    // String roleFromDatabase = "user";
    // UserRole userRole = getRoleFromString(roleFromDatabase);
    return Scaffold(
      backgroundColor: Colors.red,
      body: Column(
        children: [
          CustomText(text: "fff",fontSize: 20,)
        ],
      ),
      // bottomNavigationBar: RoleBasedBottomNav(role: ),
    );
  }
}
