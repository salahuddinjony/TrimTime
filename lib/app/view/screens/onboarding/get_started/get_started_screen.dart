import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/view/common_widgets/curved_short_clipper/curved_short_clipper.dart';
import 'package:barber_time/app/view/common_widgets/custom_container_button/custom_container_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ClipPath(
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomContainerButton(
              isArrow: false,
              text: "sing ",
              icon: Assets.images.customer.image(),
              onTap: () {
                context.push(RoutePath.signInScreen);
              },
            ),
          ),
        ],
      ),
    );
  }
}
