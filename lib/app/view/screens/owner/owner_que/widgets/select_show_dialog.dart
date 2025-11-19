import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/view/screens/owner/owner_que/controller/que_controller.dart';
import 'package:flutter/material.dart';

class selectShowDialog {
  // static void showSingleSelectDialog(
  //   BuildContext context, {
  //   required String title,
  //   required Function(String) onSelect,
  //   required QueController controller,
  // }) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         backgroundColor: AppColors.white,
  //         title: Text(title),
  //         content: SizedBox(
  //           width: double.maxFinite,
  //           child: Obx(() => ListView(
  //                 shrinkWrap: true,
  //                 children: controller.barberList.map((barber) {
  //                   return RadioListTile<String>(
  //                     title: Row(
  //                       children: [
  //                         CircleAvatar(
  //                           radius: 12,
  //                           backgroundColor: AppColors.gray300,
  //                           child: Text(
  //                             barber.user.fullName[0],
  //                             style: const TextStyle(
  //                               color: AppColors.white,
  //                               fontSize: 14,
  //                               fontWeight: FontWeight.w600,
  //                             ),
  //                           ),
  //                         ),
  //                         const SizedBox(width: 8),
  //                         Text(barber.user.fullName),
  //                       ],
  //                     ),
  //                     value: barber.user.id,
  //                     groupValue: controller.selectedBarbderId.value,
  //                     onChanged: (value) {
  //                       onSelect(value!);
  //                       Navigator.pop(context);
  //                     },
  //                   );
  //                 }).toList(),
  //               )),
  //         ),
  //       );
  //     },
  //   );
  // }

  static void showMultiSelectDialog(
    BuildContext context, {
    required String title,
    required VoidCallback onSave,
    required QueController controller,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.white,
              title: Text(title),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: controller.services.map((service) {
                    final checked =
                        controller.servicesSelected.contains(service.id);
                    return CheckboxListTile(
                      title: Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: AppColors.gray300,
                            child: Text(
                              service.name[0],
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Text(service.name),
                        ],
                      ),
                      value: checked,
                      onChanged: (value) {
                        setState(() {
                          value == true
                              ? controller.servicesSelected.add(service.id)
                              : controller.servicesSelected.remove(service.id);
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    onSave();
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
