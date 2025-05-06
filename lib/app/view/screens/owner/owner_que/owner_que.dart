import 'package:barber_time/app/core/bottom_navbar.dart';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OwnerQue extends StatefulWidget {
  const OwnerQue({super.key});

  @override
  State<OwnerQue> createState() => _OwnerQueState();
}

class _OwnerQueState extends State<OwnerQue> {
  bool isQueueEnabled = false; // State for the toggle switch

  @override
  Widget build(BuildContext context) {
    final userRole = GoRouter.of(context).state.extra as UserRole?;

    debugPrint("===================${userRole?.name}");
    if (userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }
    return Scaffold(
      bottomNavigationBar: BottomNavbar(
        currentIndex: 1,
        role: userRole,
      ),
      backgroundColor: AppColors.linearFirst,
      appBar: const CustomAppBar(
        appBarContent: AppStrings.activeNow,
        appBarBgColor: AppColors.linearFirst,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // List of barbers with queue details
            Expanded(
              child: ListView.builder(
                itemCount: 4, // Number of barbers
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            CustomNetworkImage(
                              imageUrl: AppConstants.demoImage,
                              height: 62,
                              width: 62,
                              boxShape: BoxShape.circle,
                            ),
                            const SizedBox(width: 15),
                            // User Info and Time Slot
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Jane Cooper', // Example name
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const Text(
                                    '9:00 - 11:00', // Example time slot
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            // "See Queue" Button
                            ElevatedButton(
                              onPressed: () {
                                AppRouter.route.pushNamed(RoutePath.queScreen,
                                    extra: userRole);
                                debugPrint(
                                    'See Queue clicked for barber ${index + 1}');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black, // Button color
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'See Queue',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            // Enable/Disable Queue switch
            // Enable/Disable Queue switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Enable Queue',
                  style: TextStyle(fontSize: 16),
                ),
                Switch(
                  value: isQueueEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      isQueueEnabled = value; // Update the state
                    });
                    debugPrint(
                        'Queue is ${isQueueEnabled ? 'enabled' : 'disabled'}');
                  },
                ),
              ],
            ),

            CustomButton(
              onTap: () {
                showChooseBarberDialog(context);
              },
              textColor: AppColors.white,
              fillColor: AppColors.black,
              title: AppStrings.addNewCustomer,
            )
          ],
        ),
      ),
    );
  }

  void showChooseBarberDialog(BuildContext context) {
    // Define a list of selected barbers and services
    List<bool> selectedBarbers = List.filled(5, false);  // Assuming 5 barbers
    List<bool> selectedServices = List.filled(4, false); // 4 service options

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Choice Barber',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // List of Barbers
                Column(
                  children: List.generate(5, (index) {
                    return Row(
                      children: [
                        CustomNetworkImage(
                          imageUrl: AppConstants.demoImage,
                          height: 30,
                          width: 30,
                          boxShape: BoxShape.circle,
                        ),
                        const SizedBox(width: 12),
                        Text('Jane Cooper'),
                        const Spacer(),
                        Checkbox(
                          value: selectedBarbers[index],
                          onChanged: (bool? value) {
                            selectedBarbers[index] = value ?? false;
                            // Refresh the UI
                            (context as Element).markNeedsBuild();
                          },
                        ),
                      ],
                    );
                  }),
                ),
                const SizedBox(height: 20),
                // Auto selection
                Row(
                  children: [
                    const Text('Auto', style: TextStyle(fontWeight: FontWeight.w600)),
                    const Spacer(),
                    Checkbox(
                      value: selectedBarbers[4], // Assuming Auto is the last option in the list
                      onChanged: (bool? value) {
                        selectedBarbers[4] = value ?? false;
                        (context as Element).markNeedsBuild();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Services Section
                const Text("Choice you’s Service", style: TextStyle(fontWeight: FontWeight.w600)),
                Column(
                  children: List.generate(4, (index) {
                    List<String> services = ['Hair Cut', 'Shaving', 'Beard Trim', 'Massage'];
                    return Row(
                      children: [
                        Text(services[index]),
                        const Spacer(),
                        Checkbox(
                          value: selectedServices[index],
                          onChanged: (bool? value) {
                            selectedServices[index] = value ?? false;
                            // Refresh the UI
                            (context as Element).markNeedsBuild();
                          },
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle saving the queue
                // Print selected barbers and services (you can replace this with saving functionality)
                print("Selected Barbers: ${selectedBarbers.where((e) => e).toList()}");
                print("Selected Services: ${selectedServices.where((e) => e).toList()}");

                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Save Queue'),
            ),
          ],
        );
      },
    );
  }

}
