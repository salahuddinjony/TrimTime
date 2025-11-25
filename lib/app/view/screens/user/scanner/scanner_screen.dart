import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/screens/user/scanner/controller/scanner_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:ui';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with WidgetsBindingObserver {
  late final ScannerController scannerController;
  UserRole? userRole;
  bool _isDisposed = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Create a unique controller instance
    final tag = 'scanner_${DateTime.now().millisecondsSinceEpoch}';
    scannerController = Get.put(
      ScannerController(),
      tag: tag,
    );

    print('🎬 ScannerScreen: initState called');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get userRole from router extra
    final extra = GoRouterState.of(context).extra;
    if (extra is UserRole) {
      userRole = extra;
    } else if (extra is Map) {
      try {
        userRole = extra['userRole'] as UserRole?;
      } catch (_) {
        userRole = null;
      }
    }

    // Initialize scanner after first frame
    if (!_isInitialized && !_isDisposed) {
      _isInitialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_isDisposed) {
          print('📷 Starting camera from didChangeDependencies');
          scannerController.startScanner();
        }
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (_isDisposed || !mounted) return;

    print('🔄 App Lifecycle State: $state');

    switch (state) {
      case AppLifecycleState.resumed:
        print('▶️ App resumed - restarting scanner');
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted && !_isDisposed) {
            scannerController.startScanner();
          }
        });
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        print('⏸️ App paused - stopping scanner');
        scannerController.pauseScanner();
        break;
      case AppLifecycleState.detached:
        print('🛑 App detached - stopping scanner');
        scannerController.stopScanner();
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  void dispose() {
    print('🗑️ ScannerScreen: dispose called');
    _isDisposed = true;
    _isInitialized = false;

    WidgetsBinding.instance.removeObserver(this);

    // Stop and dispose scanner
    try {
      scannerController.stopScanner();
      scannerController.mobileScannerController.dispose();
    } catch (e) {
      print('⚠️ Error disposing scanner: $e');
    }

    // Remove controller from GetX
    try {
      Get.delete<ScannerController>(force: true);
    } catch (e) {
      print('⚠️ Error deleting controller: $e');
    }

    super.dispose();
  }

  // Handle when user navigates back to this screen
  void _onScreenResumed() {
    print('🔙 Screen resumed - restarting camera');
    if (mounted && !_isDisposed && _isInitialized) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && !_isDisposed) {
          scannerController.resetAndRestart();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final extra = GoRouterState.of(context).extra;
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

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) {
          print('⬅️ Back button pressed - stopping scanner');
          scannerController.stopScanner();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.last,
        appBar: CustomAppBar(
          iconData: Icons.arrow_back,
          appBarContent: AppStrings.scanQrCode,
          appBarBgColor: AppColors.last,
          onTap: () {
            print('⬅️ AppBar back tapped - stopping scanner');
            scannerController.stopScanner();
            context.pop();
          },
        ),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    // Listen for screen resume
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_isDisposed) {
        _onScreenResumed();
      }
    });

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            // QR Scanner Box with Freeze Effect
            Obx(() => Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 600.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(13),
                        child: Stack(
                          children: [
                            // Camera Scanner
                            MobileScanner(
                              controller:
                                  scannerController.mobileScannerController,
                              onDetect: (capture) {
                                if (_isDisposed || !mounted) return;

                                final List<Barcode> barcodes = capture.barcodes;
                                for (final barcode in barcodes) {
                                  final rawData = barcode.rawValue;
                                  if (rawData != null && rawData.isNotEmpty) {
                                    if (!scannerController.isVerifying.value) {
                                      debugPrint(
                                          '📱 Scanned QR Code: $rawData');

                                      // Capture the current frame image if available
                                      scannerController.capturedImage.value =
                                          capture.image;

                                      scannerController.verifyQrCode(
                                        rawData,
                                        context,
                                        userRole!,
                                      );
                                    }
                                  }
                                }
                              },
                            ),

                            // Camera status indicator
                            if (!scannerController.isScannerActive.value &&
                                !scannerController.isVerifying.value)
                              Container(
                                color: Colors.black,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.camera_alt_outlined,
                                        color: Colors.white54,
                                        size: 64,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Camera Initializing...',
                                        style: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    // Frozen frame with blur overlay when verifying
                    if (scannerController.isVerifying.value)
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(13),
                          child: Stack(
                            children: [
                              // Captured image or blurred background
                              if (scannerController.capturedImage.value != null)
                                Image.memory(
                                  scannerController.capturedImage.value!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                )
                              else
                                Container(color: Colors.black),

                              // Blur effect
                              BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                                child: Container(
                                  color: Colors.black.withValues(alpha: .3),
                                ),
                              ),

                              // Verification UI
                              Center(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 32.w,
                                    vertical: 24.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color:
                                          Colors.white.withValues(alpha: 0.3),
                                      width: 2,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Animated QR icon
                                      TweenAnimationBuilder<double>(
                                        tween: Tween(begin: 0.8, end: 1.1),
                                        duration:
                                            const Duration(milliseconds: 800),
                                        curve: Curves.easeInOut,
                                        builder: (context, scale, child) {
                                          return Transform.scale(
                                            scale: scale,
                                            child: Container(
                                              padding: const EdgeInsets.all(20),
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withValues(alpha: 0.2),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.qr_code_scanner,
                                                color: Colors.white,
                                                size: 50,
                                              ),
                                            ),
                                          );
                                        },
                                        onEnd: () {
                                          // Loop animation
                                          if (mounted) setState(() {});
                                        },
                                      ),

                                      const SizedBox(height: 24),

                                      // Loading indicator
                                      const SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 4,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 24),

                                      // Verifying text
                                      Text(
                                        'Verifying QR Code',
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          letterSpacing: 0.5,
                                        ),
                                      ),

                                      const SizedBox(height: 8),

                                      // Loading dots animation
                                      _buildLoadingDots(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                )),

            const SizedBox(height: 24),

            // Scan Prompt (only when not verifying)
            Obx(() {
              if (!(scannerController.isVerifying.value)) {
                return _buildScanPromptWidget();
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingDots() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
          onEnd: () {
            // Loop animation with delay based on index
            Future.delayed(Duration(milliseconds: index * 200), () {
              if (mounted) setState(() {});
            });
          },
        );
      }),
    );
  }

  Widget _buildScanPromptWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.qr_code_scanner_rounded,
            color: Colors.white.withValues(alpha: 0.7),
            size: 28,
          ),
          const SizedBox(width: 12),
          Text(
            'Point camera at QR code',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}
