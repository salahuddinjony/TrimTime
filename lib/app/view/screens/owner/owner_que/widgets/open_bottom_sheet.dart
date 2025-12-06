import 'package:barber_time/app/global/helper/validators/validators.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_text_field/custom_text_field.dart';
import 'package:barber_time/app/view/screens/owner/owner_que/widgets/select_show_dialog.dart';
import 'package:barber_time/app/view/screens/user/home/controller/user_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class OpenBottomSheet {
  static void showChooseBarberBottomSheet<T>(BuildContext context,
      {required T controller, UserRole? userRole, String? saloonOwnerId, String? barberId}) {
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
            initialChildSize: 0.5,
            minChildSize: 0.5,
            maxChildSize: 0.7,
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
                            Text( 
                             userRole == UserRole.user ? "Add to Queue" : "Register Customer" , 
                              style: const TextStyle(
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
                    if(userRole != UserRole.user)...[
                          CustomTextField(
                          isColor: true,
                          hintText: "Name",
                          prefixIcon: const Icon(Icons.person),
                          textEditingController:
                              (controller as dynamic).nameController,
                          validator: Validators.nameValidator,
                        ),
                        const SizedBox(height: 18),

                        // Email
                        CustomTextField(
                          isColor: true,
                          hintText: "Email Address",
                          prefixIcon: const Icon(Icons.email),
                          textEditingController:
                              (controller as dynamic).emailController,
                          validator: Validators.emailValidator,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 18),
                    ],

                        // Time
                        // CustomTextField(
                        //   isColor: true,
                        //   readOnly: true,
                        //   onTap: () async {
                        //     await controller.selecTime(context: context);
                        //     // After selecting time, trigger a UI update
                        //     setState(() {});
                        //   },
                        //   hintText: "Select Time",
                        //   prefixIcon: const Icon(Icons.access_time),
                        //   textEditingController: controller.timeController,
                        // ),
                        // const SizedBox(height: 20),

                        Obx(() {
                          return GestureDetector(
                            onTap: () {
                              if ((controller as dynamic)
                                  .servicesList
                                  .isEmpty) {
                                EasyLoading.showInfo(
                                    "Please select time first");
                                return;
                              }
                              selectShowDialog.showMultiSelectDialog(
                                context,
                                title: "Select Services",
                                controller: controller as dynamic,
                                onSave: () async {
                                  if ((controller as dynamic)
                                      .services
                                      .isEmpty) {
                                    EasyLoading.showInfo(
                                        "There are no services available");
                                    return;
                                  }

                                  // After selecting services, clear barber list and selected barber
                                  // controller.barberList.clear();
                                  (controller as dynamic)
                                      .selectedBarbderId
                                      .value = '';

                                  Navigator.pop(context);
                                  // await controller.getBarber();
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
                                color: (controller as dynamic).services.isEmpty
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
                                      (controller as dynamic)
                                              .servicesSelected
                                              .isEmpty
                                          ? "Select Services"
                                          : (controller as dynamic)
                                                      .servicesSelected
                                                      .length >
                                                  2
                                              ? "${(controller as dynamic).servicesSelected.length} services selected"
                                              : ((controller as dynamic)
                                                      .services as List)
                                                  .where((service) =>
                                                      (controller as dynamic)
                                                          .servicesSelected
                                                          .contains(service.id))
                                                  .map(
                                                      (service) => service.name)
                                                  .join(", "),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: (controller as dynamic)
                                                .services
                                                .isEmpty
                                            ? Colors.grey.shade400
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  (controller as dynamic)
                                          .getServicesStatus
                                          .value
                                          .isLoading
                                      ? const SizedBox(
                                          height: 15,
                                          width: 15,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 1,
                                            color: AppColors.black,
                                          ),)
                                      : (controller as dynamic).services.isEmpty
                                          ? const SizedBox.shrink()
                                          : const Icon(Icons.arrow_drop_down),
                                ],
                              ),
                            ),
                          );
                        }),

                        const SizedBox(height: 20),

                        // Obx(() {
                        //   return GestureDetector(
                        //       onTap: () {
                        //         if (controller.servicesSelected.isEmpty) {
                        //           EasyLoading.showInfo(
                        //               "Please select services first");
                        //           return;
                        //         }
                        //         if (controller.barberList.isNotEmpty) {
                        //           selectShowDialog.showSingleSelectDialog(
                        //             context,
                        //             title: "Select Barber",
                        //             controller: controller,
                        //             onSelect: (barberId) {
                        //               controller.selectedBarbderId.value =
                        //                   barberId;
                        //             },
                        //           );
                        //         }
                        //       },
                        //       child: Column(
                        //         children: [
                        //           Container(
                        //             padding: const EdgeInsets.symmetric(
                        //                 horizontal: 12, vertical: 14),
                        //             decoration: BoxDecoration(
                        //               color: controller.barberList.isEmpty
                        //                   ? Colors.grey.shade300
                        //                   : Colors.white,
                        //               borderRadius: BorderRadius.circular(12),
                        //               border: Border.all(
                        //                   color: Colors.grey.shade300),
                        //             ),
                        //             child: Row(
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.spaceBetween,
                        //               children: [
                        //                 Expanded(
                        //                   child: Text(
                        //                     controller.selectedBarbderId.isEmpty
                        //                         ? controller.message.isNotEmpty
                        //                             ? controller.message
                        //                             : "Select Barber"
                        //                         : (controller.barberList
                        //                                 .firstWhereOrNull(
                        //                                     (barber) =>
                        //                                         barber
                        //                                             .user.id ==
                        //                                         controller
                        //                                             .selectedBarbderId
                        //                                             .value)
                        //                                 ?.user
                        //                                 .fullName ??
                        //                             controller.selectedBarbderId
                        //                                 .value),
                        //                     overflow: TextOverflow.ellipsis,
                        //                     style: TextStyle(
                        //                       color:
                        //                           controller.message.isNotEmpty
                        //                               ? Colors.red
                        //                               : controller.barberList
                        //                                       .isEmpty
                        //                                   ? Colors.grey.shade400
                        //                                   : Colors.black,
                        //                     ),
                        //                   ),
                        //                 ),
                        //                 controller.getBarberWithDateTimeStatus
                        //                         .value.isLoading
                        //                     ? SizedBox(
                        //                         height: 20,
                        //                         width: 20,
                        //                         child:
                        //                             CircularProgressIndicator(
                        //                           strokeWidth: 2,
                        //                           color: AppColors.black,
                        //                         ),
                        //                       )
                        //                     : controller.barberList.isEmpty
                        //                         ? const SizedBox.shrink()
                        //                         : const Icon(
                        //                             Icons.arrow_drop_down),
                        //               ],
                        //             ),
                        //           ),
                        //           if (controller.barberList.isEmpty &&
                        //               controller.message.isEmpty &&
                        //               controller.getBarberWithDateTimeStatus
                        //                   .value.isSuccess) ...[
                        //             const SizedBox(height: 6),
                        //             Container(
                        //                 alignment: Alignment.centerLeft,
                        //                 padding: const EdgeInsets.only(
                        //                     top: 6, left: 4),
                        //                 child: Row(
                        //                   children: [
                        //                     const Icon(
                        //                       Icons.info_outline,
                        //                       size: 16,
                        //                       color: AppColors.app,
                        //                     ),
                        //                     const SizedBox(width: 4),
                        //                     Expanded(
                        //                       child: Text(
                        //                         controller.barberList.isEmpty
                        //                             ? "No barbers available for the selected time and services."
                        //                             : "",
                        //                         style: const TextStyle(
                        //                           fontSize: 12,
                        //                           color: AppColors.app,
                        //                         ),
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ))
                        //           ]
                        //         ],
                        //       ));
                        // }),

                        // const SizedBox(height: 20),

                        // Notes
                        CustomTextField(
                          hintText: "Notes",
                          prefixIcon: const Icon(Icons.note),
                          textEditingController:
                              (controller as dynamic).notesController,
                          isColor: true,
                        ),

                        const SizedBox(height: 25),

                        // Save
                        CustomButton(
                          onTap: () async {
                            if (!(controller as dynamic).isAllFiledFilled(userRole: userRole ?? null)) {
                              EasyLoading.showInfo(
                                  "Please fill all the fields");
                              return;
                            }
                            debugPrint("Saving Queue");
                            final result =userRole ==UserRole.user? await (controller as dynamic).addToQueue(

                                  userRole: userRole,
                                  saloonOwnerId: saloonOwnerId!,
                                  barberId: barberId ?? null,
                            ) :await (controller as dynamic)
                                .registerCustomerQue();
                            if (result) {
                              Navigator.pop(context); // Close bottom sheet
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
