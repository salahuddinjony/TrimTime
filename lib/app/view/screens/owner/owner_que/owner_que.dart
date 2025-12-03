import 'package:barber_time/app/core/bottom_navbar.dart';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/screens/owner/owner_que/controller/que_controller.dart';
import 'package:barber_time/app/view/screens/owner/owner_que/controller/mixin/queue_management/model/que_model_data.dart';
import 'package:barber_time/app/view/screens/owner/owner_que/widgets/open_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
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
                      } else if (controller.queList.value?.barbers.isEmpty ??
                          true) {
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
                          itemCount:
                              controller.queList.value?.barbers.length ?? 0,
                          itemBuilder: (context, index) {
                            QueBarber barber =
                                controller.queList.value!.barbers[index];
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

                    OpenBottomSheet.showChooseBarberBottomSheet<QueController>(
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
}
