import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class UserBookingScreen extends StatefulWidget {
  const UserBookingScreen({super.key});

  @override
  UserBookingScreenState createState() => UserBookingScreenState();
}

class UserBookingScreenState extends State<UserBookingScreen> {
  // Simulating selection for services
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CustomNetworkImage(
                    imageUrl: AppConstants.shop,
                    height: 316.h,
                    width: double.infinity),
                Positioned(
                    left: 10,
                    top: 25,
                    child: Container(
                        padding: EdgeInsets.all(10.r),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.black),
                        child: IconButton(
                            onPressed: () {
                              print('object');
                              // Using GoRouter for navigation
                              GoRouter.of(context)
                                  .pop();
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ))))
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "Barbers Time",
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  const Row(
                    children: [
                      Text('5.0 (290)', style: TextStyle(fontSize: 14)),
                      Icon(Icons.star, color: Colors.orange),
                    ],
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on, color: Colors.grey),
                      CustomText(
                        text: "Oldesloer Strasse 82",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          // Using GoRouter to push to a new screen
                          context.pushNamed(RoutePath.mapViewScreen,
                              extra: UserRole.user);
                        },
                        child: Container(
                          padding: EdgeInsets.all(10.r),
                          decoration: BoxDecoration(
                              color: AppColors.secondary,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.r))),
                          child: CustomText(
                            text: "Live Location",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),

                  // Services List
                  CustomText(
                    top: 20.h,
                    text: "Services",
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                  SizedBox(height: 10.h),
                  serviceTile('Hair Cut', '30 Minutes', 40.60, 0),
                  serviceTile('Deep Massage', '45 Minutes', 50.80, 1),
                  serviceTile('Arm Wax', '40 Minutes', 60.80, 2),
                  serviceTile('Hair Cut', '30 Minutes', 40.60, 3),
                  serviceTile('Deep Massage', '45 Minutes', 50.80, 4),
                  serviceTile('Arm Wax', '40 Minutes', 60.80, 5),

                  CustomButton(
                    onTap: () {
                      // Using GoRouter for pushing a route
                      // context.pushNamed(RoutePath.someOtherScreen);
                    },
                    title: AppStrings.continues,
                    fillColor: AppColors.gray500,
                    textColor: AppColors.white,
                  )
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
                ? const Icon(Icons.check_circle, color: Colors.orange)
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
              Text(serviceName, style: TextStyle(fontSize: 16)),
              Text(duration,
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
          Spacer(),
          Text('£ ${price.toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
