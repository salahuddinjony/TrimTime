import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
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
        add: false,
        appBarContent: AppStrings.loyaLity,
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Obx(() {
          if (controller.loyalityStatus.value.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.loyalityStatus.value.isError) {
            return Center(child: Text(controller.loyalityStatus.value.errorMessage ?? 'Error'));
          } else if (controller.loyalityData.isEmpty) {
            return Center(child: Text('No loyalty data found'));
          }
          return ListView.separated(
            itemCount: controller.loyalityData.length,
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              final item = controller.loyalityData[index];
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Icon(Icons.card_giftcard, color: Colors.orange, size: 32),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.serviceName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 18),
                                SizedBox(width: 4.w),
                                Text(
                                  '${item.points} Points',
                                  style: TextStyle(fontSize: 15.sp, color: Colors.black87),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),
                            Row(
                              children: [
                                Icon(
                                  item.isActive ? Icons.check_circle : Icons.cancel,
                                  color: item.isActive ? Colors.green : Colors.red,
                                  size: 18,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  item.isActive ? 'Active' : 'Inactive',
                                  style: TextStyle(
                                    color: item.isActive ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Optionally, add a trailing icon or action
                    ],
                  ),
                ),
              );
            },
          );
        }),
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
