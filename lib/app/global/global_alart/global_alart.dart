import 'package:barber_time/app/global/controller/auth_controller/auth_controller.dart';
import 'package:barber_time/app/global/helper/validators/validators.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/view/common_widgets/custom_from_card/custom_from_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GlobalAlert {
  final AuthController authController = Get.find<AuthController>();
//Delete Dialog
  void showDeleteDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController passwordController = TextEditingController();
        final TextEditingController confirmPasswordController = TextEditingController();

        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                CustomFromCard(
                  isPassword: true,
                  hinText: AppStrings.enterYourPassword,
                  title: AppStrings.password,
                  controller: passwordController,
                  validator: (v) {
                    return Validators.passwordValidator(v);
                  },
                ),
                CustomFromCard(
                  isPassword: true,
                  hinText: AppStrings.confirmPassword,
                  title: AppStrings.confirmPassword,
                  controller: confirmPasswordController,
                  validator: (v) {
                    return Validators.confirmPasswordValidator(
                      v, passwordController.text,
                    );
                  },
                ),
              ],
            ),
          ),
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
                final confirmPassword = confirmPasswordController.text.trim();
                final password = passwordController.text;
                authController.deleteAccount(
                  password,
                  confirmPassword,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.normalHover,
              ),
              child: Text(
                AppStrings.deleteAccount,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  } //Delete Dialog
}
