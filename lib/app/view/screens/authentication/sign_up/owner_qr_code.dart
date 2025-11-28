import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/route_path.dart';
import '../../../../core/routes.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/enums/user_role.dart';
import '../../../common_widgets/custom_button/custom_button.dart';

class OwnerQrCode extends StatefulWidget {
  const OwnerQrCode({super.key});

  @override
  State<OwnerQrCode> createState() => _OwnerQrCodeState();
}

class _OwnerQrCodeState extends State<OwnerQrCode> {
  String scannedData = "No QR code scanned yet";

  @override
  Widget build(BuildContext context) {
    final userRole = GoRouterState.of(context).extra as UserRole?;
    debugPrint("Selected Roles============================${userRole?.name}");
    return Scaffold(
      appBar:const CustomAppBar(appBarContent: "Unique QR code",iconData: Icons.arrow_back,),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [

            Container(
              height: 600.h,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: MobileScanner(
                onDetect: (capture) {
                  final List<Barcode> barcodes = capture.barcodes;
                  for (final barcode in barcodes) {
                    setState(() {
                      scannedData = barcode.rawValue ?? "Invalid QR Code";
                    });
                  }
                },
              ),
            ),
            SizedBox(height: 10.h,),
            CustomButton(
              onTap: () {
                AppRouter.route.goNamed(RoutePath.ownerHomeScreen,extra:
                   userRole );

              },
              textColor: AppColors.white50,
              title: "Next",
              fillColor: AppColors.black,
            ),
          ],
        ),
      ),
    );
  }
}
