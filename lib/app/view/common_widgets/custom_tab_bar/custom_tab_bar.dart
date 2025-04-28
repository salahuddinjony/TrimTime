import 'package:flutter/material.dart';

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({super.key});

  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  bool isUpcomingSelected = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: double.infinity,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          // Upcoming Tab
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isUpcomingSelected = true;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isUpcomingSelected ? Colors.orange : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Upcoming",
                  style: TextStyle(
                    color: isUpcomingSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          // Previous Tab
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isUpcomingSelected = false;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: !isUpcomingSelected ? Colors.orange : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Previous",
                  style: TextStyle(
                    color: !isUpcomingSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
