import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/custom_assets/assets.gen.dart';
import '../../../../../../core/route_path.dart';
import '../../../../../../core/routes.dart';
import '../../../../../../utils/app_constants.dart';
import '../../../../../../utils/enums/user_role.dart';
import '../../../../../common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import '../../../../../common_widgets/custom_barber_card/custom_barber_card.dart';
import '../../../../../common_widgets/custom_icon_button/custom_icon_button.dart';

class HiringBarberPayment extends StatelessWidget {
  const HiringBarberPayment({super.key});

  @override
  Widget build(BuildContext context) {
    final userRole = GoRouter.of(context).state.extra as UserRole?;

    debugPrint("===================${userRole?.name}");
    if (userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }
    return Scaffold(
        appBar: const CustomAppBar(
          appBarContent: "Hiring Barber",
          iconData: Icons.arrow_back,
        ),
        body: ClipPath(
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
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    CustomBarberCard(
                      imageUrl: AppConstants.demoImage, // Barber's image URL
                      name: 'Christian Ronaldo', // Barber's name
                      role: 'Barber', // Barber's role
                      contact: '+1 111 467 378 399', // Barber's contact number
                    ),
                    SizedBox(height: 20.h,),
                    CustomIconButton(
                      iconColor: Colors.white,
                      textColor: Colors.white,
                      isBgColor: Colors.black,
                      text: 'Cash Payment',
                      iconPath: Assets.images.hugeiconsPayment02.path,
                      onTap: () {},
                    ),

                    SizedBox(height: 20.h,),
                    CustomIconButton(
                      iconColor: Colors.white,
                      textColor: Colors.white,
                      isBgColor: AppColors.secondary,
                      text: 'Online Payment',
                      iconPath: Assets.images.hugeiconsPayment02.path,
                      onTap: () {
                        AppRouter.route.pushNamed(RoutePath.ownerPaymentOption,
                            extra: userRole);
                      },
                    ),
                  ],
                ),
              ),
            )));
  }
}
