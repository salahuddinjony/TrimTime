import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter/material.dart';

// Custom Follow/Unfollow button
Widget customButton(String text, IconData icon) {
  return GestureDetector(
    onTap: null, // Toggle follow state on tap
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          CustomText(
            text: text,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ],
      ),
    ),
  );
}

Widget iconButton(Widget icon) {
  return GestureDetector(
    onTap: () {
      AppRouter.route.pushNamed(
        RoutePath.chatScreen,
      );
    },
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: icon,
    ),
  );
}
