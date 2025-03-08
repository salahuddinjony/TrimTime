import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GlobalAlert {
//Delete Dialog
  static showDeleteDialog(
      BuildContext context, VoidCallback onConfirm, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: Text(title),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(AppStrings.cancel.tr,
                  style: const TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                onConfirm();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.normalHover),
              child: const Text(
                AppStrings.deleteAccount,
                style: TextStyle(color: AppColors.white50),
              ),
            ),
          ],
        );
      },
    );
  } //Delete Dialog
}
