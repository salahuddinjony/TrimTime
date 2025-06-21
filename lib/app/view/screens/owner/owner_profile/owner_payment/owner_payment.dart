import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:flutter/material.dart';

import '../../../../../core/route_path.dart';
import '../../../../../core/routes.dart';
import '../../../../../utils/app_constants.dart';
import '../../../../common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import '../../../../common_widgets/custom_barber_card/custom_barber_card.dart';

class OwnerPayment extends StatelessWidget {
  const OwnerPayment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarContent: "Barber",iconData: Icons.arrow_back,),
      body:
      ClipPath(
        clipper: CurvedBannerClipper(),
    child: Container(
    width: double.infinity,
    decoration: const BoxDecoration(
    gradient: LinearGradient(
    colors: [
    Color(0xCCEDC4AC), // First color (with opacity)
    Color(0xFFE9874E),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    ),
    ),child:
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: Column(
          children: [
            GestureDetector(
              onTap: (){
                AppRouter.route.pushNamed(RoutePath.hiringBarberPayment,
                    );
              },
              child: CustomBarberCard(
                imageUrl: AppConstants.demoImage, // Barber's image URL
                name: 'Christian Ronaldo', // Barber's name
                role: 'Barber', // Barber's role
                contact: '+1 111 467 378 399', // Barber's contact number
              ),
            ),
          ],
        ),
      ),))
    );
  }
}
