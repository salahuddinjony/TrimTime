import 'dart:async';
import 'dart:typed_data';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
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
  final RxBool isScannerActive = false.obs;

  // Captured image for freeze effect
  final Rx<Uint8List?> capturedImage = Rx<Uint8List?>(null);

  // MobileScannerController
  late final MobileScannerController mobileScannerController;

  // Timer for debouncing
  Timer? _debounceTimer;
  String? _lastScannedCode;
  DateTime? _lastScanTime;

  @override
  void onInit() {
    super.onInit();
    print('🎯 ScannerController: onInit called');
    initializeScanner();
  }

  void initializeScanner() {
    mobileScannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
      returnImage: true, // Enable image capture
    );
    print('🎥 MobileScannerController initialized');
  }

  /// Start scanner
  Future<void> startScanner() async {
    try {
      if (isScannerActive.value) {
        print('⚠️ Scanner already active');
        return;
      }

      print('▶️ Starting scanner...');
      await mobileScannerController.start();
      isScannerActive.value = true;
      capturedImage.value = null; // Clear any captured image
      print('✅ Scanner started successfully');
    } catch (e) {
      print('❌ Error starting scanner: $e');
      isScannerActive.value = false;

      // Retry once after delay
      await Future.delayed(const Duration(milliseconds: 500));
      try {
        await mobileScannerController.start();
        isScannerActive.value = true;
        print('✅ Scanner started on retry');
      } catch (retryError) {
        print('❌ Retry failed: $retryError');
      }
    }
  }

  /// Stop scanner completely
  Future<void> stopScanner() async {
    try {
      if (!isScannerActive.value) {
        print('⚠️ Scanner already stopped');
        return;
      }

      print('🛑 Stopping scanner...');
      await mobileScannerController.stop();
      isScannerActive.value = false;
      capturedImage.value = null;
      _cancelDebounce();
      print('✅ Scanner stopped successfully');
    } catch (e) {
      print('❌ Error stopping scanner: $e');
      isScannerActive.value = false;
    }
  }

  /// Pause scanner temporarily
  Future<void> pauseScanner() async {
    try {
      if (isScannerActive.value) {
        print('⏸️ Pausing scanner...');
        await mobileScannerController.stop();
        print('✅ Scanner paused');
      }
    } catch (e) {
      print('❌ Error pausing scanner: $e');
    }
  }

  /// Resume scanner
  Future<void> resumeScanner() async {
    try {
      if (isScannerActive.value && !isVerifying.value) {
        print('▶️ Resuming scanner...');
        await mobileScannerController.start();
        print('✅ Scanner resumed');
      }
    } catch (e) {
      print('❌ Error resuming scanner: $e');
    }
  }

  /// Reset and restart scanner
  Future<void> resetAndRestart() async {
    print('🔄 Resetting and restarting scanner...');

    // Reset state
    _lastScannedCode = null;
    _lastScanTime = null;
    capturedImage.value = null;
    isVerifying.value = false;
    _cancelDebounce();

    // Stop and restart
    await stopScanner();
    await Future.delayed(const Duration(milliseconds: 300));
    await startScanner();

    print('✅ Scanner reset and restarted');
  }

  /// Cancel debounce timer
  void _cancelDebounce() {
    _debounceTimer?.cancel();
    _debounceTimer = null;
  }

  /// Check if scan is duplicate
  bool _isDuplicateScan(String code) {
    final now = DateTime.now();

    // Same code scanned within 3 seconds
    if (_lastScannedCode == code && _lastScanTime != null) {
      final difference = now.difference(_lastScanTime!);
      if (difference.inSeconds < 3) {
        print('⚠️ Duplicate scan detected (within 3s)');
        return true;
      }
    }

    return false;
  }

  /// Verify scanned QR code with backend
  Future<void> verifyQrCode(
    String rawQrData,
    BuildContext context,
    UserRole userRole,
  ) async {
    // Prevent duplicate scans
    if (isVerifying.value) {
      print('⚠️ Already verifying, ignoring scan');
      return;
    }

    if (_isDuplicateScan(rawQrData)) {
      return;
    }

    // Check if context is still mounted
    if (!context.mounted) {
      print('⚠️ Context not mounted, aborting verification');
      return;
    }

    try {
      // Freeze the screen immediately
      isVerifying.value = true;
      scannedData.value = rawQrData;
      _lastScannedCode = rawQrData;
      _lastScanTime = DateTime.now();

      // Stop scanner to freeze the frame
      await mobileScannerController.stop();

      print('🔍 Verifying QR Code: $rawQrData');
      print('🎥 Screen frozen with captured frame');

      // Call API without showing success loader
      final response = await ApiClient.getData(
        '${ApiUrl.verifyQrCode}/$rawQrData',
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException('Verification request timed out');
        },
      );

      print('📡 API Response Status: ${response.statusCode}');
      print('📡 API Response Body: ${response.body}');

      // Check if context is still valid
      if (!context.mounted) {
        print('⚠️ Context unmounted during verification');
        return;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ QR Code verified successfully');

        // Navigate immediately without success message
        if (context.mounted) {
          await stopScanner();

          //***********/ there have a , when navigate to other scanner screen,
          //********** the camera still working to scan but camera not show on the screen, will fix it later
          // await mobileScannerController.stop();
          // mobileScannerController.dispose();
          // debugPrint('stop scanner called before navigation');
          // debugPrint('Navigating to UserBookingScreen with role: $userRole');
          // Get.delete<ScannerController>(force: true);
          context.pushNamed(RoutePath.topRatedScreen, extra: {
            'userRole': userRole,
          });
        }
      } else {
        print('❌ Verification failed: ${response.statusCode}');

        if (context.mounted) {
          EasyLoading.showError(
            'Verification failed',
            duration: const Duration(seconds: 2),
          );
        }

        // Reset and restart scanner after error
        await Future.delayed(const Duration(seconds: 2));
        if (!context.mounted) return;

        await _resetAfterFailure();
      }
    } on TimeoutException catch (e) {
      print('⏱️ Timeout error: $e');

      if (context.mounted) {
        EasyLoading.showError(
          'Request timed out',
          duration: const Duration(seconds: 2),
        );
      }

      await _resetAfterFailure();
    } catch (e) {
      print('❌ Error verifying QR code: $e');

      if (context.mounted) {
        EasyLoading.showError(
          'Error verifying QR code',
          duration: const Duration(seconds: 2),
        );
      }

      await _resetAfterFailure();
    } finally {
      isVerifying.value = false;
    }
  }

  /// Reset scanner after verification failure
  Future<void> _resetAfterFailure() async {
    print('🔄 Resetting after failure...');

    _lastScannedCode = null;
    _lastScanTime = null;
    capturedImage.value = null;

    // Restart scanner if it was active
    if (isScannerActive.value) {
      await Future.delayed(const Duration(milliseconds: 500));
      try {
        await mobileScannerController.start();
        print('✅ Scanner restarted after failure');
      } catch (e) {
        print('❌ Failed to restart scanner: $e');
      }
    }
  }

  /// Reset scanner state completely
  Future<void> resetScanner() async {
    print('🔄 Resetting scanner state...');

    _cancelDebounce();
    _lastScannedCode = null;
    _lastScanTime = null;
    scannedData.value = '';
    capturedImage.value = null;
    isVerifying.value = false;

    if (isScannerActive.value) {
      try {
        await mobileScannerController.start();
        print('✅ Scanner reset complete');
      } catch (e) {
        print('❌ Error in resetScanner: $e');
      }
    }
  }

  @override
  void onClose() {
    print('🗑️ ScannerController: onClose called');
    _cancelDebounce();
    stopScanner();
    super.onClose();
  }
}
