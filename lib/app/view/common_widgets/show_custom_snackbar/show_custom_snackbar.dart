import 'package:barber_time/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

void showCustomSnackBar(String? message,
    {bool isError = true, bool getXSnackBar = false}) {
  if (message == null || message.isEmpty) return;

  final snackBarContent = SnackBar(
    dismissDirection: DismissDirection.horizontal,
    margin: EdgeInsets.only(
      right: 10.h,
      top: 10.h,
      bottom: 10.h,
      left: 10.h,
    ),
    duration: const Duration(seconds: 3),
    backgroundColor: isError ? Colors.red : Colors.green,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
    content: Text(
      message,
      style: TextStyle(fontSize: 12.w),
    ),
  );

  // If explicitly requested or Get.context is not available, use GetSnackBar
  if (getXSnackBar || Get.context == null) {
    Get.showSnackbar(GetSnackBar(
      backgroundColor: isError ? Colors.red : Colors.green,
      message: message,
      duration: const Duration(seconds: 3),
      snackStyle: SnackStyle.FLOATING,
      margin: EdgeInsets.all(10.sp),
      borderRadius: 8.r,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
    ));
    return;
  }

  final ctx = Get.context;
  if (ctx != null) {
    try {
      ScaffoldMessenger.of(ctx).showSnackBar(snackBarContent);
    } catch (e) {
      // Fallback to Get snackbar if ScaffoldMessenger fails for any reason
      Get.showSnackbar(GetSnackBar(
        backgroundColor: isError ? Colors.red : Colors.green,
        message: message,
        duration: const Duration(seconds: 3),
        snackStyle: SnackStyle.FLOATING,
        margin: EdgeInsets.all(10.sp),
        borderRadius: 8.r,
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
      ));
    }
  } else {
    // As final fallback, show a toast
    Fluttertoast.showToast(msg: message, backgroundColor: isError ? Colors.red : Colors.green, textColor: Colors.white);
  }
}

void toastMessage({required String message}) {
  Fluttertoast.showToast(
    msg: message,
    backgroundColor: AppColors.homeColor,
    textColor: Colors.white,
    gravity: ToastGravity.BOTTOM,
    toastLength: Toast.LENGTH_LONG,
  );
}