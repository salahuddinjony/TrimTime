import 'package:barber_time/app/view/screens/owner/owner_home/controller/barber_owner_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:barber_time/app/global/helper/extension/extension.dart';
import 'package:get/get.dart';

class HorizontalDatePicker extends StatelessWidget {
  final BarberOwnerHomeController controller;
  const HorizontalDatePicker({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  IconButton(
                    onPressed: () {
                      controller.goToPreviousDate();
                    },
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black54, size: 18),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                Text(
                  '${controller.selectedDate.formatDate()}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                  IconButton(
                    onPressed: () {
                      controller.goToNextDate();
                    },
                    icon: const Icon(Icons.arrow_forward_ios, color: Colors.black54, size: 18),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
              ],
            ),
            ),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.dates.length,
            itemBuilder: (context, index) {
              final date = controller.dates[index];

              return Obx(() {
                final isSelected = index == controller.selectedIndex.value;

                return GestureDetector(
                  onTap: () {
                    controller.selectDate(index);
                    controller.fetchDateWiseBookings(date:
                        intl.DateFormat('yyyy-MM-dd').format(date));
                  },
                  child: Container(
                    width: 60,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? Color(0xFFD27B50) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? null
                          : Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          intl.DateFormat('dd').format(date),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          intl.DateFormat('E').format(date), // Sat, Sun etc.
                          style: TextStyle(
                            fontSize: 14,
                            color: isSelected ? Colors.white : Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
            },
          ),
        ),
      ],
    );
  }
}
