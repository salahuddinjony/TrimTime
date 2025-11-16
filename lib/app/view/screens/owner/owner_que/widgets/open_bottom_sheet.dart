import 'package:barber_time/app/global/helper/validators/validators.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_text_field/custom_text_field.dart';
import 'package:barber_time/app/view/screens/owner/owner_que/controller/que_controller.dart';
import 'package:barber_time/app/view/screens/owner/owner_que/widgets/single_show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class OpenBottomSheet {
  static void showChooseBarberBottomSheet(BuildContext context,
      {required QueController controller}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
          ),
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.82,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder: (_, scrollController) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Register Customer",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.pop(context),
                            )
                          ],
                        ),
                        const SizedBox(height: 15),

                        // Name
                        CustomTextField(
                          isColor: true,
                          hintText: "Name",
                          prefixIcon: const Icon(Icons.person),
                          textEditingController: controller.nameController,
                        ),
                        const SizedBox(height: 18),

                        // Email
                        CustomTextField(
                          isColor: true,
                          hintText: "Email Address",
                          prefixIcon: const Icon(Icons.email),
                          textEditingController: controller.emailController,
                          validator: Validators.emailValidator,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 18),

                        // Time
                        CustomTextField(
                          isColor: true,
                          readOnly: true,
                          onTap: () async {
                            await controller.selecTime(context: context);
                            // After selecting time, trigger a UI update
                            setState(() {});
                          },
                          hintText: "Select Time",
                          prefixIcon: const Icon(Icons.access_time),
                          textEditingController: controller.timeController,
                        ),
                        const SizedBox(height: 20),

                        Obx(() {
                          return GestureDetector(
                            onTap: () {
                              if (controller.timeController.text.isEmpty) {
                                EasyLoading.showInfo(
                                    "Please select time first");
                                return;
                              }
                              selectShowDialog.showMultiSelectDialog(
                                context,
                                title: "Select Services",
                                controller: controller,
                                onSave: () async {
                                  if (controller.servicesSelected.isEmpty) {
                                    EasyLoading.showInfo(
                                        "Please select at least one service");
                                    return;
                                  }

                                  // After selecting services, clear barber list and selected barber
                                  controller.barberList.clear();
                                  controller.selectedBarbderId.value = '';

                                  Navigator.pop(context);
                                  await controller.getBarber();
                                  // controller.servicesSelected.value = List.from(
                                  //     controller.servicesSelected
                                  //         .value); // Update services list
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 14),
                              decoration: BoxDecoration(
                                color: controller.timeController.text.isEmpty
                                    ? Colors.grey.shade300
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      controller.servicesSelected.isEmpty
                                          ? "Select Services"
                                          : controller.servicesSelected.length >
                                                  2
                                              ? "${controller.servicesSelected.length} services selected"
                                              : controller.services
                                                  .where((service) => controller
                                                      .servicesSelected
                                                      .contains(service.id))
                                                  .map(
                                                      (service) => service.name)
                                                  .join(", "),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: controller
                                                .timeController.text.isEmpty
                                            ? Colors.grey.shade400
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  controller.timeController.text.isEmpty
                                      ? const SizedBox.shrink()
                                      : const Icon(Icons.arrow_drop_down),
                                ],
                              ),
                            ),
                          );
                        }),

                        const SizedBox(height: 20),

                        Obx(() {
                          return GestureDetector(
                              onTap: () {
                                if (controller.servicesSelected.isEmpty) {
                                  EasyLoading.showInfo(
                                      "Please select services first");
                                  return;
                                }
                                if (controller.barberList.isNotEmpty) {
                                  selectShowDialog.showSingleSelectDialog(
                                    context,
                                    title: "Select Barber",
                                    controller: controller,
                                    onSelect: (barberId) {
                                      controller.selectedBarbderId.value =
                                          barberId;
                                    },
                                  );
                                }
                              },
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 14),
                                    decoration: BoxDecoration(
                                      color: controller.barberList.isEmpty
                                          ? Colors.grey.shade300
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            controller.selectedBarbderId.isEmpty
                                                ? controller.message.isNotEmpty
                                                    ? controller.message
                                                    : "Select Barber"
                                                : (controller.barberList
                                                        .firstWhereOrNull(
                                                            (barber) =>
                                                                barber
                                                                    .user.id ==
                                                                controller
                                                                    .selectedBarbderId
                                                                    .value)
                                                        ?.user
                                                        .fullName ??
                                                    controller.selectedBarbderId
                                                        .value),
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color:
                                                  controller.message.isNotEmpty
                                                      ? Colors.red
                                                      : controller.barberList
                                                              .isEmpty
                                                          ? Colors.grey.shade400
                                                          : Colors.black,
                                            ),
                                          ),
                                        ),
                                        controller.getBarberWithDateTimeStatus
                                                .value.isLoading
                                            ? SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: AppColors.black,
                                                ),
                                              )
                                            : controller.barberList.isEmpty
                                                ? const SizedBox.shrink()
                                                : const Icon(
                                                    Icons.arrow_drop_down),
                                      ],
                                    ),
                                  ),
                                  if (controller.barberList.isEmpty &&
                                      controller.message.isEmpty &&
                                      controller.getBarberWithDateTimeStatus
                                          .value.isSuccess) ...[
                                    const SizedBox(height: 6),
                                    Container(
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.only(
                                            top: 6, left: 4),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.info_outline,
                                              size: 16,
                                              color: AppColors.app,
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                controller.barberList.isEmpty
                                                    ? "No barbers available for the selected time and services."
                                                    : "",
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: AppColors.app,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ))
                                  ]
                                ],
                              ));
                        }),

                        const SizedBox(height: 20),

                        // Notes
                        CustomTextField(
                          hintText: "Notes",
                          prefixIcon: const Icon(Icons.note),
                          textEditingController: controller.notesController,
                          isColor: true,
                        ),

                        const SizedBox(height: 25),

                        // Save
                        CustomButton(
                          onTap: () async {
                            if (!controller.isAllFiledFilled()) {
                              EasyLoading.showInfo(
                                  "Please fill all the fields");
                              return;
                            }
                            debugPrint("Saving Queue");
                            final result =
                                await controller.registerCustomerQue();
                            if (result) {
                              Navigator.pop(context); // Close bottom sheet
                              controller.clearControllers(); // Clear fields
                            }
                          },
                          fillColor: AppColors.black,
                          textColor: Colors.white,
                          title: "Save Queue",
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
