import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/screens/authentication/owner/unique_qr_code/controller/qr_code_controller.dart';
import 'package:barber_time/app/view/screens/authentication/owner/unique_qr_code/widgets/qr_code_display_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class UniqueQrCode extends StatelessWidget {
  const UniqueQrCode({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the QR code controller using GetX
    final qrController = Get.put(QrCodeController());

    final userRole = GoRouterState.of(context).extra as UserRole?;
    debugPrint("Selected Role============================${userRole?.name}");

    return Scaffold(
      appBar: const CustomAppBar(
        appBarContent: "Qr Code",
        appBarBgColor: AppColors.linearFirst,
        iconData: Icons.arrow_back,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: ClipPath(
          clipper: CurvedBannerClipper(),
          child: Container(
              width: double.infinity,
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height / 1.3,
              ),
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
                    // QR Code Display with Obx for reactive updates
                    Obx(() {
                      if (qrController.isGenerating.value) {
                        return Column(
                          children: [
                            const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'Generating QR Code...',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        );
                      }
                      return AnimatedScale(
                        scale:
                            qrController.isSendingToServer.value ? 0.95 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: AnimatedOpacity(
                          opacity:
                              qrController.isSendingToServer.value ? 0.7 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          child: QrCodeDisplayWidget(
                            qrData: qrController.qrData.value,
                            size: 280.w,
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.black,
                            repaintKey: qrController.qrKey,
                          ),
                        ),
                      );
                    }),
                    SizedBox(height: 16.h),
                    // Server Sync Status Indicator
                    Obx(() {
                      if (qrController.isSendingToServer.value) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: .2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 16.w,
                                height: 16.h,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Syncing to server...',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (qrController.dataSentSuccessfully.value) {
                        return TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 500),
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: Transform.scale(
                                scale: value,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withValues(alpha: .9),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                        size: 16.sp,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        'Synchronized',
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                    SizedBox(
                      height: 20.h,
                    ),
                    // Regenerate Button
                    // Obx(() {
                    //   final isDisabled = qrController.isSendingToServer.value ||
                    //       qrController.isGenerating.value ||
                    //       qrController.isRegenerating.value;
                    //   return AnimatedContainer(
                    //     duration: const Duration(milliseconds: 300),
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(25),
                    //       boxShadow: isDisabled
                    //           ? []
                    //           : [
                    //               BoxShadow(
                    //                 color: const Color(0xFFEA8F5C)
                    //                     .withValues(alpha: .3),
                    //                 blurRadius: 16,
                    //                 offset: const Offset(0, 6),
                    //                 spreadRadius: 2,
                    //               ),
                    //             ],
                    //     ),
                    //     child: Material(
                    //       color: Colors.transparent,
                    //       child: InkWell(
                    //         onTap: isDisabled
                    //             ? null
                    //             : () => qrController.regenerateQrCode(),
                    //         borderRadius: BorderRadius.circular(25),
                    //         child: Container(
                    //           padding: EdgeInsets.symmetric(
                    //             horizontal: 20.w,
                    //             vertical: 10.h,
                    //           ),
                    //           decoration: BoxDecoration(
                    //             gradient: isDisabled
                    //                 ? LinearGradient(
                    //                     colors: [
                    //                       Colors.grey[300]!,
                    //                       Colors.grey[400]!,
                    //                     ],
                    //                   )
                    //                 : LinearGradient(
                    //                     colors: [
                    //                       Colors.white.withValues(alpha: .95),
                    //                       Colors.white.withValues(alpha: .85),
                    //                     ],
                    //                     begin: Alignment.topCenter,
                    //                     end: Alignment.bottomCenter,
                    //                   ),
                    //             borderRadius: BorderRadius.circular(25),
                    //             border: Border.all(
                    //               color: isDisabled
                    //                   ? Colors.grey[400]!
                    //                   : Colors.white.withValues(alpha: .9),
                    //               width: 1.5,
                    //             ),
                    //           ),
                    //           child: Row(
                    //             mainAxisSize: MainAxisSize.min,
                    //             children: [
                    //               // Rotating icon with click animation
                    //               AnimatedRotation(
                    //                 turns: qrController.isRegenerating.value ? 1.0 : 0.0,
                    //                 duration: const Duration(milliseconds: 600),
                    //                 curve: Curves.easeInOut,
                    //                 child: Icon(
                    //                   Icons.autorenew_rounded,
                    //                   color: isDisabled
                    //                       ? Colors.grey[600]
                    //                       : const Color(0xFFEA8F5C),
                    //                   size: 20.sp,
                    //                 ),
                    //               ),
                    //               SizedBox(width: 8.w),
                    //               Text(
                    //                 qrController.isRegenerating.value
                    //                     ? "Regenerating..."
                    //                     : "Regenerate QR",
                    //                 style: TextStyle(
                    //                   fontSize: 13.sp,
                    //                   fontWeight: FontWeight.w700,
                    //                   color: isDisabled
                    //                       ? Colors.grey[600]
                    //                       : const Color(0xFF333333),
                    //                   letterSpacing: 0.5,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   );
                    // }),
                    // SizedBox(height: 20.h),
                    // QR Code Info Text
                    Text(
                      'Scan this QR code to access',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'your barber shop',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Print Button
                        Obx(() {
                          final isDisabled =
                              qrController.isSendingToServer.value ||
                                  qrController.isGenerating.value ||
                                  qrController.isPrinting.value;
                          return AnimatedScale(
                            scale: isDisabled ? 0.95 : 1.0,
                            duration: const Duration(milliseconds: 200),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: isDisabled
                                    ? []
                                    : [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: .15),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: isDisabled
                                      ? null
                                      : () => qrController.printQrCode(),
                                  borderRadius: BorderRadius.circular(30),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 24.w,
                                      vertical: 14.h,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: isDisabled
                                          ? LinearGradient(
                                              colors: [
                                                Colors.grey[300]!,
                                                Colors.grey[400]!,
                                              ],
                                            )
                                          : const LinearGradient(
                                              colors: [
                                                Colors.white,
                                                Color(0xFFF8F8F8),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                        color: isDisabled
                                            ? Colors.grey[400]!
                                            : Colors.white
                                                .withValues(alpha: .8),
                                        width: 2,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (qrController.isPrinting.value)
                                          SizedBox(
                                            width: 18.w,
                                            height: 18.h,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: AppColors.black,
                                            ),
                                          )
                                        else
                                          Icon(
                                            Icons.print_outlined,
                                            color: isDisabled
                                                ? Colors.grey[600]
                                                : AppColors.black,
                                            size: 22.sp,
                                          ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          qrController.isPrinting.value
                                              ? "Printing..."
                                              : "Print",
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600,
                                            color: isDisabled
                                                ? Colors.grey[600]
                                                : AppColors.black,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                        SizedBox(width: 16.w),
                        // Download Button
                        Obx(() {
                          final isDisabled =
                              qrController.isSendingToServer.value ||
                                  qrController.isGenerating.value ||
                                  qrController.isDownloading.value;
                          return AnimatedScale(
                            scale: isDisabled ? 0.95 : 1.0,
                            duration: const Duration(milliseconds: 200),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: isDisabled
                                    ? []
                                    : [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: .15),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: isDisabled
                                      ? null
                                      : () =>
                                          qrController.downloadQrCode(context),
                                  borderRadius: BorderRadius.circular(30),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 24.w,
                                      vertical: 14.h,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: isDisabled
                                          ? LinearGradient(
                                              colors: [
                                                Colors.grey[300]!,
                                                Colors.grey[400]!,
                                              ],
                                            )
                                          : const LinearGradient(
                                              colors: [
                                                Colors.white,
                                                Color(0xFFF8F8F8),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                        color: isDisabled
                                            ? Colors.grey[400]!
                                            : Colors.white
                                                .withValues(alpha: .8),
                                        width: 2,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (qrController.isDownloading.value)
                                          SizedBox(
                                            width: 18.w,
                                            height: 18.h,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: AppColors.black,
                                            ),
                                          )
                                        else
                                          Icon(
                                            Icons.download_rounded,
                                            color: isDisabled
                                                ? Colors.grey[600]
                                                : AppColors.black,
                                            size: 22.sp,
                                          ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          qrController.isDownloading.value
                                              ? "Saving..."
                                              : "Download",
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600,
                                            color: isDisabled
                                                ? Colors.grey[600]
                                                : AppColors.black,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
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
