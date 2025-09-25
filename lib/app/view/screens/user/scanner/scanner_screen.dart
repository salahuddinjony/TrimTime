
import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  String scannedData = "No QR code scanned yet";

  @override
  Widget build(BuildContext context) {
    final extra = GoRouter.of(context).state.extra;
    UserRole? userRole;
    if (extra is UserRole) {
      userRole = extra;
    } else if (extra is Map) {
      try {
        userRole = extra['userRole'] as UserRole?;
      } catch (_) {
        userRole = null;
      }
    }

    if (userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.last,
      appBar: const CustomAppBar(
        iconData: Icons.arrow_back,
        appBarContent: AppStrings.scanQrCode,
        appBarBgColor: AppColors.last,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
          child: Column(
            children: [
              // QR Scanner Box
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
              const SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }
}
