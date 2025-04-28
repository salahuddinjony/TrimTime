import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/global/controller/auth_controller/auth_controller.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/common_home_app_bar/common_home_app_bar.dart';
import 'package:barber_time/app/view/common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

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
                    Color(0xCCEDC4AC), // First color (with opacity)
                    Color(0xFFE9864E),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  children: [
                    // Container(
                    //   height: 250,
                    //   width: 250,
                    //   decoration: BoxDecoration(
                    //     border: Border.all(color: Colors.white, width: 2),
                    //     borderRadius: BorderRadius.circular(15),
                    //   ),
                    //   child: MobileScanner(
                    //     onDetect: (capture) {
                    //       final List<Barcode> barcodes = capture.barcodes;
                    //       for (final barcode in barcodes) {
                    //         setState(() {
                    //           scannedData = barcode.rawValue ?? "Invalid QR Code";
                    //         });
                    //       }
                    //     },
                    //   ),
                    // ),
                    Assets.images.scannerImage.image(),

                    SizedBox(
                      height: 50.h,
                    ),
                    CustomButton(
                      onTap: () {
                        context.pushNamed(RoutePath.ownerHomeScreen,
                            extra: userRole);
                      },
                      textColor: AppColors.white50,
                      title: "Next",
                      fillColor: AppColors.black,
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
