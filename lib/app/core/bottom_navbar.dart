import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/screens/barber/barber_history/barber_history_screen.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/barber_home_screen.dart';
import 'package:barber_time/app/view/screens/barber/barber_profile/barber_profile.dart';
import 'package:barber_time/app/view/screens/owner/owner_hiring/owner_hiring_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_home/owner_home_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_message/owner_messaging_screen.dart';
import 'package:barber_time/app/view/screens/user/home/home_screen.dart';
import 'package:barber_time/app/view/screens/user/que/que_screen.dart';
import 'package:barber_time/app/view/screens/user/scanner/scanner_screen.dart';
import 'package:flutter/material.dart';


class RoleBasedBottomNav extends StatefulWidget {
  final UserRole role; // Enum UserRole
  const RoleBasedBottomNav({super.key, required this.role});

  @override
  _RoleBasedBottomNavState createState() => _RoleBasedBottomNavState();
}

class _RoleBasedBottomNavState extends State<RoleBasedBottomNav> {
  int _selectedIndex = 0;
  late List<Widget> _pages;
  late List<BottomNavigationBarItem> _navItems;

  @override
  void initState() {
    super.initState();
    _pages = getScreensByRole(widget.role);
    _navItems = getNavItemsByRole(widget.role);
  }

  List<Widget> getScreensByRole(UserRole role) {
    switch (role) {
      case UserRole.owner:
        return [const OwnerHomeScreen(), const OwnerMessagingScreen(), const OwnerHiringScreen()];
      case UserRole.barber:
        return [const BarberHomeScreen(), const BarberHistoryScreen(), const BarberProfile()];
      case UserRole.user:
      default:
        return [const HomeScreen(), const QueScreen(), const ScannerScreen()];
    }
  }

  List<BottomNavigationBarItem> getNavItemsByRole(UserRole role) {
    switch (role) {
      case UserRole.owner:
        return [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.book_online), label: "Bookings"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ];
      case UserRole.barber:
        return [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: "Schedule"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ];
      case UserRole.user:
      default:
        return [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Appointments"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: _navItems,
      ),
    );
  }
}
