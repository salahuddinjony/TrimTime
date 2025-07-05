import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/route_path.dart';
import '../../../../core/routes.dart';
import '../../../../utils/enums/user_role.dart';

class UserBookingScreen extends StatefulWidget {
  const UserBookingScreen({Key? key}) : super(key: key);

  @override
  State<UserBookingScreen> createState() => _UserBookingScreenState();
}

class _UserBookingScreenState extends State<UserBookingScreen> {
  List<bool> selectedServices = [false, false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    final userRole = GoRouter.of(context).state.extra as UserRole?;

    if (userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = screenHeight * 0.4; // 40% of screen height

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image with Stack for icons
            Stack(
              children: [
                Image.network(
                  AppConstants.shop,
                  height: imageHeight,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),

                // Back button
                Positioned(
                  left: 10,
                  top: 25,
                  child: Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.black),
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                ),

                // Chat button
                Positioned(
                  right: 70,
                  top: 25,
                  child: Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.black),
                    child: IconButton(
                      onPressed: () {
                        AppRouter.route.pushNamed(RoutePath.chatScreen,
                            extra: userRole);
                      },
                      icon: const Icon(Icons.chat, color: Colors.white),
                    ),
                  ),
                ),

                // Call button
                Positioned(
                  right: 10,
                  top: 25,
                  child: Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.black),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.call, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),

            // Content container overlapping image slightly
            Container(
              transform: Matrix4.translationValues(0, -20, 0), // slight overlap
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -5))
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Barbers Time",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black)),
                  const SizedBox(height: 5),
                  const Row(
                    children: [
                      Text('5.0 (290)', style: TextStyle(fontSize: 14)),
                      Icon(Icons.star, color: Colors.orange, size: 16),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Location row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on, color: Colors.grey),
                      const SizedBox(width: 5),
                      const Expanded(
                        child: Text(
                          "Oldesloer Strasse 82",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.pushNamed(RoutePath.mapViewScreen,
                              extra: UserRole.user);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              color: AppColors.last,
                              borderRadius: BorderRadius.circular(20)),
                          child: const Text(
                            "Live Location",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Services header
                  Row(
                    children: const [
                      Text("Services",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black)),
                      Spacer(),
                      Text("(02 services selected)",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey)),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Example services
                  serviceTile('Hair Cut', '30 Minutes', 40.60, 0),
                  serviceTile('Deep Massage', '45 Minutes', 50.80, 1),
                  serviceTile('Arm Wax', '40 Minutes', 60.80, 2),
                  serviceTile('Hair Cut', '30 Minutes', 40.60, 3),
                  serviceTile('Deep Massage', '45 Minutes', 50.80, 4),
                  serviceTile('Arm Wax', '40 Minutes', 60.80, 5),

                  const SizedBox(height: 20),

                  // Continue button
                  CustomButton(
                    onTap: () {
                      context.pushNamed(RoutePath.chooseBarberScreen,
                          extra: userRole);
                    },
                    title: AppStrings.continues,
                    fillColor: AppColors.gray500,
                    textColor: AppColors.white,
                  ),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget serviceTile(
      String serviceName, String duration, double price, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          IconButton(
            icon: selectedServices[index]
                ? const Icon(Icons.check_circle, color: AppColors.last)
                : const Icon(Icons.radio_button_unchecked),
            onPressed: () {
              setState(() {
                selectedServices[index] = !selectedServices[index];
              });
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(serviceName,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Colors.black)),
              Text(duration,
                  style: const TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
          const Spacer(),
          Text('£ ${price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
