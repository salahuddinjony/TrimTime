import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/core/route_path.dart';

import 'package:barber_time/app/view/common_widgets/custom_container_button/custom_container_button.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ChoseAuthScreen extends StatelessWidget {
  const ChoseAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            // Adding some vertical space for better layout
            SizedBox(height: 50.h),

            // Logo in the center
            Center(child: Assets.images.logo.image()),

            // Spacer for better alignment
            SizedBox(height: 40.h),

            CustomContainerButton(
              isArrow: false,
              text: "sing ",
              icon: Assets.images.customer.image(),
              onTap: () {
                context.push(RoutePath.getStartedScreen);
              },
            ),
          ],
        ),
      ),
    );
  }
}
