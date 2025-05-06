import 'package:barber_time/app/core/bottom_navbar.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RescheduleScreen extends StatefulWidget {
  const RescheduleScreen({super.key});

  @override
  _RescheduleScreenState createState() => _RescheduleScreenState();
}

class _RescheduleScreenState extends State<RescheduleScreen> {
  // Keeping track of selected date and time
  String selectedDate = '4 Wed';
  String selectedTime = '11:00 AM';

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
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        appBarContent: "Reschedule",
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Selection Row
            const Text(
              'Select reschedule date & time',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
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
            // Grid of Times
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
            // Confirm button

            CustomButton(
              onTap: () {
                context.pop();
              },
              textColor: AppColors.white,
              fillColor: AppColors.black,
              title: "Request for Reschedule",
            )
          ],
        ),
      ),
    );
  }
}
