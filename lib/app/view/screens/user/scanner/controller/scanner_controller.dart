import 'dart:convert';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerController extends GetxController {
  // Observable for scanned data
  final Rx<String> scannedData = ''.obs;

  // Loading state
  final RxBool isVerifying = false.obs;
  final RxBool verificationSuccess = false.obs;

  // Verification result data
  final Rx<Map<String, dynamic>?> verificationResult =
      Rx<Map<String, dynamic>?>(null);

  // MobileScannerController to control the scanner
  final MobileScannerController mobileScannerController =
      MobileScannerController();

  /// Verify scanned QR code with backend
  Future<void> verifyQrCode(String rawQrData, BuildContext context) async {
    try {
      isVerifying.value = true;
      verificationSuccess.value = false;
      scannedData.value = rawQrData;

      // Freeze the scanner (pause camera)
      mobileScannerController.stop();

      print('🔍 Scanner - Raw QR Data: $rawQrData');

      // // Parse the QR code data
      // Map<String, dynamic> qrDataMap;
      // try {
      //   qrDataMap = jsonDecode(rawQrData);
      // } catch (e) {
      //   print('❌ Failed to parse QR code data: $e');
      //   EasyLoading.showError('Invalid QR code format');
      //   return;
      // }

      // // Extract data from QR code
      // final userId = qrDataMap['userId'];
      // final email = qrDataMap['email'];
      // final timestamp = qrDataMap['timestamp'];

      // if (userId == null || email == null || timestamp == null) {
      //   print('❌ Missing required fields in QR code');
      //   EasyLoading.showError('QR code is missing required information');
      //   return;
      // }

      // Create the verification code string without spaces
      final verificationCode = "$rawQrData";

      print('🔍 Verification Code: $verificationCode');

      // Call the verification API
      final response = await ApiClient.getData(
        '${ApiUrl.verifyQrCode}/$verificationCode',
      );

      print('📡 API Response Status: ${response.statusCode}');
      print('📡 API Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        verificationSuccess.value = true;
        print('✅ QR Code verified successfully');
        EasyLoading.showSuccess('QR Code verified successfully');
        context.pushNamed(RoutePath.userBookingScreen);
      } else {
        print('❌ QR Code verification failed: ${response.statusCode}');
        verificationSuccess.value = false;
        EasyLoading.showError('Verification failed: ${response.body}');
        // Resume scanner after a short delay
        await Future.delayed(const Duration(seconds: 2));
        mobileScannerController.start();
      }
    } catch (e) {
      print('❌ Error verifying QR code: $e');
      verificationSuccess.value = false;
      if (context.mounted) {
        EasyLoading.showError('Error verifying QR code: $e');
      }
      // Resume scanner after a short delay
      await Future.delayed(const Duration(seconds: 2));
      mobileScannerController.start();
    } finally {
      isVerifying.value = false;
    }
  }

  /// Reset scanner state
  void resetScanner() {
    scannedData.value = '';
    verificationSuccess.value = false;
    verificationResult.value = null;
    mobileScannerController.start();
  }

  @override
  void onClose() {
    resetScanner();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    // Always start scanner when controller is initialized
    mobileScannerController.start();
  }
}
