import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/global/controller/auth_controller/auth_controller.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/routes.dart';
import '../../../../common_widgets/custom_icon_button/custom_icon_button.dart';

class UniqueQrCode extends StatefulWidget {
  const UniqueQrCode({super.key});

  @override
  State<UniqueQrCode> createState() => _UniqueQrCodeState();
}

class _UniqueQrCodeState extends State<UniqueQrCode> {
  final AuthController authController = Get.find<AuthController>();
  String scannedData = "No QR code scanned yet";

  @override
  Widget build(BuildContext context) {
    final userRole = GoRouterState.of(context).extra as UserRole?;
    debugPrint("Selected Role============================${userRole?.name}");
    return Scaffold(
      appBar: const CustomAppBar(
        appBarContent: "Qr Code",
        appBarBgColor: AppColors.linearFirst,
        iconData: Icons.arrow_back,
      ),
      body: SingleChildScrollView(
        child: ClipPath(
          clipper: CurvedBannerClipper(),
          child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 1.3,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xCCEDBB9D), // First color (with opacity)
                    Color(0xFFEA8F5C),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Assets.images.scannerImage.image(),
                    SizedBox(
                      height: 50.h,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconButton(
                          iconColor:AppColors.black ,
                          textColor: AppColors.black,
                        isBgColor: AppColors.white,
                          onTap: () {
                            AppRouter.route.goNamed(RoutePath.ownerHomeScreen,
                                extra: userRole);
                          },
                          text: "Print",
                          iconPath: Assets.images.downloadIcon.path,
                          iconLeftPadding: 10,
                        ),
                        SizedBox(width: 20.w),
                        CustomIconButton(
                          iconColor: AppColors.black,
                          textColor: AppColors.black,
                          isBgColor: AppColors.white,
                          onTap: () {
                            AppRouter.route.goNamed(RoutePath.ownerHomeScreen,
                                extra: userRole);
                          },
                          text: "Download",
                          iconPath: Assets.images.downloadIcon.path,
                          iconLeftPadding: 5,
                        ),
                      ],
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
