import 'package:barber_time/app/core/bottom_navbar.dart';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/global/helper/validators/validators.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/common_widgets/custom_text_field/custom_text_field.dart';
import 'package:barber_time/app/view/screens/owner/owner_que/controller/que_controller.dart';
import 'package:barber_time/app/view/screens/owner/owner_que/model/que_model_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:collection/collection.dart';
import '../../../common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';

class OwnerQue extends StatelessWidget {
  Future<void> _refresh() async {
    await controller.fetchQueList();
  }

  OwnerQue({super.key});
  final QueController controller = Get.put(QueController());

  @override
  Widget build(BuildContext context) {
    final extra = GoRouter.of(context).state.extra;
    UserRole? userRole;

    if (extra is UserRole) {
      userRole = extra;
    } else if (extra is Map) {
      userRole = extra['userRole'] as UserRole?;
    }

    if (userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }

    // String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return Scaffold(
      bottomNavigationBar: BottomNavbar(
        currentIndex: 1,
        role: userRole,
      ),
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        appBarContent: AppStrings.activeNow,
        appBarBgColor: AppColors.linearFirst,
      ),
      body: ClipPath(
        clipper: CurvedBannerClipper(),
        child: Container(
          height: MediaQuery.of(context).size.height / 1.5,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xCCEDBC9F),
                Color(0xFFE98952),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refresh,
                    child: Obx(() {
                      if (controller.queListStatus.value.isLoading) {
                        // Shimmer effect for loading state
                        return ListView.builder(
                          itemCount: 6,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        height: 62,
                                        width: 62,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Container(
                                        height: 14,
                                        width: 50,
                                        color: Colors.grey.shade300,
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 18),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SizedBox(height: 8),
                                      Container(
                                        height: 16,
                                        width: 80,
                                        color: Colors.grey.shade300,
                                      ),
                                      SizedBox(height: 16),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            height: 32,
                                            width: 32,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Container(
                                            height: 32,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else if (controller.queList.isEmpty) {
                        return ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [
                            SizedBox(height: 100),
                            Center(
                              child: Text(
                                'No data available.',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.gray500,
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return ListView.builder(
                          itemCount: controller.queList.length,
                          itemBuilder: (context, index) {
                            QueBarber barber = controller.queList[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomNetworkImage(
                                        imageUrl: barber.image,
                                        height: 62,
                                        width: 62,
                                        boxShape: BoxShape.circle,
                                      ),
                                      SizedBox(height: 6),
                                      CustomText(
                                        text: barber.name,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.gray500,
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 18),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SizedBox(height: 8),
                                      CustomText(
                                        textAlign: TextAlign.end,
                                        text: barber.schedule != null
                                            ? "${barber.schedule!.start}-${barber.schedule!.end}"
                                            : "No Schedule",
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.gray500,
                                      ),
                                      SizedBox(height: 16),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(8.r),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: AppColors.black,
                                              ),
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                            ),
                                            child: CustomText(
                                              text:
                                                  "${barber.totalQueueLength?.toString()}",
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.black,
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          GestureDetector(
                                            onTap: () {
                                              debugPrint(
                                                  "Navigating to Queue Screen for ${barber.name}");
                                              debugPrint(
                                                  "Barber ID: ${barber.barberId}");
                                              controller
                                                  .fetchBarbersCustomerQue(
                                                      barberId:
                                                          barber.barberId);
                                              AppRouter.route.pushNamed(
                                                RoutePath.queScreen,
                                                extra: {
                                                  'userRole': userRole,
                                                  'barberId': barber.barberId,
                                                  'controller': controller,
                                                },
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 8),
                                              decoration: BoxDecoration(
                                                color: AppColors.black,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: CustomText(
                                                text: "See Queue",
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    }),
                  ),
                ),
                SizedBox(height: 30.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: controller.isQueueEnabled.value
                                ? AppColors.black
                                : AppColors.black),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Obx(
                        () => CustomText(
                          text: controller.isQueueEnabled.value
                              ? "Enabled"
                              : "Disabled",
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: controller.isQueueEnabled.value
                              ? AppColors.white
                              : AppColors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Obx(() {
                      return Switch(
                        activeTrackColor: AppColors.black,
                        activeThumbColor: AppColors.secondary,
                        inactiveTrackColor: Colors.grey,
                        inactiveThumbColor: Colors.grey[600]!,
                        value: controller.isQueueEnabled.value,
                        onChanged: controller.toggleQueueStatus,
                      );
                    }),
                  ],
                ),
                SizedBox(height: 30.h),
                CustomButton(
                  onTap: () {
                    controller.getServices();

                    showChooseBarberBottomSheet(
                      context,
                      controller: controller,
                    );
                  },
                  textColor: AppColors.white,
                  fillColor: AppColors.black,
                  title: AppStrings.addNewCustomer,
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showChooseBarberBottomSheet(BuildContext context,
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
                          validator:Validators.emailValidator,
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
                              _showMultiSelectDialog(
                                context,
                                title: "Select Services",
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
                                  _showSingleSelectDialog(
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
                            if (result){
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

  void _showSingleSelectDialog(
    BuildContext context, {
    required String title,
    required Function(String) onSelect,
    required QueController controller,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          title: Text(title),
          content: SizedBox(
            width: double.maxFinite,
            child: Obx(() => ListView(
                  shrinkWrap: true,
                  children: controller.barberList.map((barber) {
                    return RadioListTile<String>(
                      title: Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: AppColors.gray300,
                            child: Text(
                              barber.user.fullName[0],
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(barber.user.fullName),
                        ],
                      ),
                      value: barber.user.id,
                      groupValue: controller.selectedBarbderId.value,
                      onChanged: (value) {
                        onSelect(value!);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                )),
          ),
        );
      },
    );
  }

  void _showMultiSelectDialog(
    BuildContext context, {
    required String title,
    required VoidCallback onSave,
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
