import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:barber_time/app/utils/app_colors.dart';

class QrCodeDisplayWidget extends StatelessWidget {
  final String qrData;
  final double? size;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final GlobalKey? repaintKey;

  const QrCodeDisplayWidget({
    Key? key,
    required this.qrData,
    this.size,
    this.backgroundColor,
    this.foregroundColor,
    this.repaintKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: repaintKey,
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: qrData.isEmpty
            ? _buildPlaceholder()
            : QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: size ?? 250.w,
                backgroundColor: backgroundColor ?? Colors.white,
                eyeStyle: QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: foregroundColor ?? AppColors.black,
                ),
                dataModuleStyle: QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: foregroundColor ?? AppColors.black,
                ),
                embeddedImage: const AssetImage('assets/images/logo.png'),
                embeddedImageStyle: QrEmbeddedImageStyle(
                  size: Size(40.w, 40.w),
                ),
                errorCorrectionLevel: QrErrorCorrectLevel.H,
              ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: size ?? 250.w,
      height: size ?? 250.w,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.qr_code_2,
              size: 60.sp,
              color: Colors.grey[400],
            ),
            SizedBox(height: 8.h),
            Text(
              'Generating QR Code...',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
