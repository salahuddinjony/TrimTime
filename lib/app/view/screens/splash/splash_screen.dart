import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/view/screens/splash/controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
   SplashScreen({super.key});
final SplashController splashController = Get.find<SplashController>();

  @override
  Widget build(BuildContext context) {
  return  Scaffold(
    body: Center(child: Assets.images.logo.image()),
  );
  }
}
