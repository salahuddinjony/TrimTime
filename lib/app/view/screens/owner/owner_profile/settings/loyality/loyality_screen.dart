import 'package:barber_time/app/global/helper/extension/extension.dart';
import 'package:shimmer/shimmer.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/settings/loyality/controller/loyality_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoyalityScreen extends StatelessWidget {
  LoyalityScreen({super.key}) {
    // Fetch loyalty data when the screen is created
    controller.fetchLoyalityData();
  }

  final controller = Get.find<LoyalityController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarBgColor: const Color(0xCCEDC4AC),
        add: false,
        appBarContent: AppStrings.loyaLity.safeCap(),
        iconData: Icons.arrow_back,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xCCEDC4AC), // First color (with opacity)
              Color(0xFFE9874E),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Obx(() {
            if (controller.loyalityStatus.value.isLoading) {
              // Shimmer loader for loyalty cards (no Stack, no badge)
              return ListView.separated(
                itemCount: 2,
                separatorBuilder: (context, index) => SizedBox(height: 20.h),
                itemBuilder: (context, index) {
                  return Shimmer.fromColors(
                    baseColor: Colors.orange.shade100,
                    highlightColor: Colors.orange.shade50,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.orange.shade50,
                            Colors.orange.shade100,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 24),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Loyalty badge shimmer (circle)
                            Container(
                              height: 56,
                              width: 56,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 20.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Service name shimmer
                                  Container(
                                    height: 18,
                                    width: 140,
                                    margin: EdgeInsets.only(top: 4, bottom: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  // Points shimmer
                                  Row(
                                    children: [
                                      Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: 6.w),
                                      Container(
                                        height: 16,
                                        width: 70,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.h),
                                  // Status shimmer
                                  Row(
                                    children: [
                                      Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: 6.w),
                                      Container(
                                        height: 15,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.h),
                                  // Created date shimmer
                                  Container(
                                    height: 13,
                                    width: 110,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (controller.loyalityStatus.value.isError) {
              return Center(
                  child: Text(
                      controller.loyalityStatus.value.errorMessage ?? 'Error'));
            } else if (controller.loyalityData.isEmpty) {
              return Center(child: Text('No loyalty data found'));
            }
            return ListView.separated(
              itemCount: controller.loyalityData.length,
              separatorBuilder: (context, index) => SizedBox(height: 20.h),
              itemBuilder: (context, index) {
                final item = controller.loyalityData[index];
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withValues(alpha: .18),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    gradient: LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.orange.shade50,
                        Colors.orange.shade100,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Loyalty badge
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.orange.shade400,
                                Colors.amber.shade200,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withValues(alpha: .2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Icon(Icons.card_giftcard,
                              color: Colors.white, size: 32),
                        ),
                        SizedBox(width: 20.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.serviceName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.sp,
                                  color: Colors.orange.shade900,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                children: [
                                  Icon(Icons.star,
                                      color: Colors.amber, size: 20),
                                  SizedBox(width: 6.w),
                                  Text(
                                    '${item.points} Points',
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Colors.orange.shade800,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                children: [
                                  Icon(
                                    item.isActive
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    color: item.isActive
                                        ? Colors.green
                                        : Colors.red,
                                    size: 20,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    item.isActive ? 'Active' : 'Inactive',
                                    style: TextStyle(
                                      color: item.isActive
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'Created: ${item.createdAt.substring(0, 10)}',
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }

  void showLoyaltyDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>(); // Key for the form
    TextEditingController visitTimeController = TextEditingController();
    TextEditingController discountController = TextEditingController();
    TextEditingController serviceController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Loyalty',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Visit time field
                TextFormField(
                  controller: visitTimeController,
                  decoration: const InputDecoration(
                    labelText: 'Visit time',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter visit time';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                // Discount or Free field
                TextFormField(
                  controller: discountController,
                  decoration: const InputDecoration(
                    labelText: 'Discount(%) or Free',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter discount or Free';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                // Service field
                TextFormField(
                  controller: serviceController,
                  decoration: const InputDecoration(
                    labelText: 'Service',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter service';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  // Process data (e.g., save it)
                  // You can use the data entered here, for example:
                  String visitTime = visitTimeController.text;
                  String discount = discountController.text;
                  String service = serviceController.text;

                  // Handle the data (e.g., save it to the database, etc.)
                  print('Visit Time: $visitTime');
                  print('Discount: $discount');
                  print('Service: $service');

                  // Close the dialog
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
