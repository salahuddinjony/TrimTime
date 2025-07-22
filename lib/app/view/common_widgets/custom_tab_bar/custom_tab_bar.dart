import 'package:barber_time/app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  final ValueChanged<bool> onTabSelected;
  final bool isUpcomingSelected; // Track the selected tab

  const CustomTabBar({super.key, required this.onTabSelected, required this.isUpcomingSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: double.infinity,
      padding: const EdgeInsets.all(4),
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
                onTabSelected(true); // Notify the parent screen that "Upcoming" tab was selected
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isUpcomingSelected ? AppColors.secondary : Colors.transparent,
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
                onTabSelected(false); // Notify the parent screen that "Previous" tab was selected
              },
              child: Container(
                decoration: BoxDecoration(
                  color: !isUpcomingSelected ?AppColors.secondary  : Colors.transparent,
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

