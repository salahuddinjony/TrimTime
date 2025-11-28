import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:get/get.dart';

class HorizontalDatePicker<T> extends StatelessWidget {
  final dynamic controller;
  final UserRole userRole;
  final String? seloonId;
  const HorizontalDatePicker(
      {super.key,
      required this.controller,
      required this.userRole,
      this.seloonId});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  if (userRole == UserRole.user && seloonId != null) {
                    debugPrint(
                        "Fetching date: ${intl.DateFormat('yyyy-MM-dd').format(controller.selectedDate)} for seloonId: $seloonId");

                    controller.getbarberWithDate(
                        barberId: seloonId!,
                        date: intl.DateFormat('yyyy-MM-dd')
                            .format(controller.selectedDate));
                  }
                  controller.goToPreviousDate(
                      isDontCalled: userRole == UserRole.owner ? false : true);
                },
                icon: const Icon(Icons.arrow_back_ios_new,
                    color: Colors.black54, size: 18),
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              Text(
                intl.DateFormat('yyyy-MM-dd').format(controller.selectedDate),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {
                  if (userRole == UserRole.user && seloonId != null) {
                    debugPrint(
                        "Fetching date: ${intl.DateFormat('yyyy-MM-dd').format(controller.selectedDate)} for seloonId: $seloonId");
                    controller.getbarberWithDate(
                        barberId: seloonId!,
                        date: intl.DateFormat('yyyy-MM-dd')
                            .format(controller.selectedDate));
                  }
                  controller.goToNextDate(
                      isDontCalled: userRole == UserRole.owner ? false : true);
                },
                icon: const Icon(Icons.arrow_forward_ios,
                    color: Colors.black54, size: 18),
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 90,
          child: ListView.builder(
            controller: controller.datePickerScrollController,
            scrollDirection: Axis.horizontal,
            itemCount: controller.dates.length,
            itemBuilder: (context, index) {
              final date = controller.dates[index];
              return Obx(() {
                final isSelected = index == controller.selectedIndex.value;
                return GestureDetector(
                  onTap: () {
                    controller.selectDate(index);
                    if (userRole == UserRole.user && seloonId != null) {
                      controller.getbarberWithDate(
                          barberId: seloonId!,
                          date: intl.DateFormat('yyyy-MM-dd')
                              .format(controller.selectedDate));
                    }
                    if (userRole == UserRole.owner) {
                      controller.fetchDateWiseBookings(
                          date: intl.DateFormat('yyyy-MM-dd').format(date));
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOut,
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
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeInOut,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                          child: Text(intl.DateFormat('dd').format(date)),
                        ),
                        const SizedBox(height: 4),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeInOut,
                          style: TextStyle(
                            fontSize: 14,
                            color: isSelected ? Colors.white : Colors.grey[700],
                          ),
                          child: Text(intl.DateFormat('E').format(date)),
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
