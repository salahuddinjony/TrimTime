import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
  return  Scaffold(
    body: Center(child: Assets.images.logo.image()),
  );
  }
}
