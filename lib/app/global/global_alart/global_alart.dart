import 'package:barber_time/app/global/controller/auth_controller/auth_controller.dart';
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
        // final TextEditingController name = TextEditingController();
        final TextEditingController emailController = TextEditingController();
        final TextEditingController passwordController =
            TextEditingController();

        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Text(title),
              const SizedBox(height: 12),
              // TextField(
              //   controller: name,
              //   keyboardType: TextInputType.name,
              //   decoration: InputDecoration(
              //     labelText: 'Name',
              //     border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(8)),
              //   ),
              // ),
              // const SizedBox(height: 12),
              CustomFromCard(
                  isPassword: false,
                  hinText: "Enter Your Email",
                  title: AppStrings.email,
                  controller: emailController,
                  validator: (v) {
                    return null;
                  }),

              CustomFromCard(
                  isPassword: true,
                  hinText: AppStrings.enterYourPassword,
                  title: AppStrings.password,
                  controller: passwordController,
                  validator: (v) {
                    return null;
                  }),
            ],
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
                  // final enteredName = name.text.trim();
                  final email = emailController.text.trim();
                  final password = passwordController.text;
                  authController.deleteAccount(
                    email,
                    password,
                  );

                  // Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.normalHover),
                child: Text(AppStrings.deleteAccount,
                    style: const TextStyle(color: Colors.white))),
          ],
        );
      },
    );
  } //Delete Dialog
}
