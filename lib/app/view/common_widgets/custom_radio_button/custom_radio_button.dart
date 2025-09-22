import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/controller/owner_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomRadioButtonRow extends StatelessWidget {
  final OwnerProfileController controller;  // GetX controller passed in
  final TextEditingController genderController;

  CustomRadioButtonRow({super.key, required this.controller, required this.genderController});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildRadioButton('Male'),
        _buildRadioButton('Female'),
        _buildRadioButton('Other'),
      ],
    );
  }

  // Build individual radio buttons
  Widget _buildRadioButton(String value) {
    return Row(
      children: [
        Obx(() {
          return Radio<String>(
            value: value,
            // ignore: deprecated_member_use
            groupValue: controller.selectedValue.value,
            // ignore: deprecated_member_use
            onChanged: (String? newValue) {
              controller.updateSelection(newValue!, genderController);  // Update the value in GetX controller and TextEditingController
              debugPrint('Selected value: $newValue');  // Print the selected value to console
            },
          );
        }),
        Text(value),
      ],
    );
  }
}