import 'package:barber_time/app/view/common_widgets/curved_short_clipper/curved_short_clipper.dart';
import 'package:flutter/material.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      ),
    );
  }
}
