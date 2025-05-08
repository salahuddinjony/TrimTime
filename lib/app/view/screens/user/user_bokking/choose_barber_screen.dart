import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ChooseBarberScreen extends StatefulWidget {
  const ChooseBarberScreen({super.key});

  @override
  _ChooseBarberScreenState createState() => _ChooseBarberScreenState();
}

class _ChooseBarberScreenState extends State<ChooseBarberScreen> {
  String selectedDate = '4';
  String selectedTime = '11:00 AM';
  String selectedBarber = 'Talha'; // Default selected barber

  // Data for dates and times
  final List<String> dates = ['2 Mon', '3 Tue', '4 Wed', '5 Thu', '6 Fri'];
  final List<String> times = [
    '10:30 AM',
    '10:45 AM',
    '11:00 AM',
    '11:15 AM',
    '11:30 PM'
  ];

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
      backgroundColor: AppColors.first,
      appBar: const CustomAppBar(
        appBarContent: "Gentlemen’s..",
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Available Barber Section
            Text(
              'Available Barber',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                barberTile('Shakib', 'assets/shakib.png'),
                barberTile('Talha', 'assets/talha.png'),
                barberTile('Faizan', 'assets/faizan.png'),
              ],
            ),
            SizedBox(height: 20.h),

            SizedBox(height: 20),
            Text(
              'Select Date',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Grid of Dates
            SizedBox(
              height: 100,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: dates.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDate = dates[index];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: selectedDate == dates[index]
                            ? Colors.orange
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        dates[index],
                        style: TextStyle(
                          color: selectedDate == dates[index]
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 20),
            Text(
              'Select Time',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: times.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTime = times[index];
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: selectedTime == times[index]
                          ? Colors.orange
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      times[index],
                      style: TextStyle(
                        color: selectedTime == times[index]
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 100),

            CustomButton(
              onTap: () {
                // Using GoRouter for pushing a route
                context.pushNamed(RoutePath.summeryScreen,extra: userRole);
              },
              title: AppStrings.continues,
              fillColor: AppColors.gray500,
              textColor: AppColors.white,
            )
          ],
        ),
      ),
    );
  }

  // Barber selection tile
  Widget barberTile(String name, String imagePath) {
    bool isSelected = selectedBarber == name;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedBarber = name;
        });
      },
      child: Container(
        width: 90.w,
        margin: EdgeInsets.only(right: 10.w),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange.shade100 : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.grey,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            CustomNetworkImage(
              imageUrl: AppConstants.demoImage,
              height: 50,
              width: 50,
              boxShape: BoxShape.circle,
            ),
            SizedBox(height: 8.h),
            Text(
              name,
              style: TextStyle(fontSize: 14.sp),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Colors.orange,
              ),
          ],
        ),
      ),
    );
  }
}
