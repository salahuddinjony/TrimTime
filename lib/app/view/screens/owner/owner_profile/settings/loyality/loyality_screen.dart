import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/view/common_widgets/common_home_app_bar/common_home_app_bar.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoyalityScreen extends StatelessWidget {
  const LoyalityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        add: true,
        onTapAdd: (){
          showLoyaltyDialog(context);
        },
        appBarContent: AppStrings.loyaLity,
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20,),
        child: Column(
          children: [
            SizedBox(height: 50.h,),
            Assets.images.dumy.image(),

          ],
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
