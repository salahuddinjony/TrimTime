import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/screens/user/home/create_booking/models/selected_barber_free_slots_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HorizontalTimePicker extends StatefulWidget {
  final String? slotStartTime;
  final String? slotEndTime;
  final List<TimeSlot>? freeSlots; // List of all free slots
  final int totalServiceDuration; // in minutes
  final Function(String selectedTime) onTimeSelected;
  final String? initialSelectedTime;

  const HorizontalTimePicker({
    Key? key,
    this.slotStartTime,
    this.slotEndTime,
    this.freeSlots,
    required this.totalServiceDuration,
    required this.onTimeSelected,
    this.initialSelectedTime,
  }) : super(key: key);

  @override
  State<HorizontalTimePicker> createState() => _HorizontalTimePickerState();
}

class _HorizontalTimePickerState extends State<HorizontalTimePicker> {
  late RxString selectedTime;

  @override
  void initState() {
    super.initState();
    selectedTime = RxString(widget.initialSelectedTime ?? '');
  }

  @override
  void didUpdateWidget(HorizontalTimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.slotStartTime != widget.slotStartTime ||
        oldWidget.slotEndTime != widget.slotEndTime ||
        oldWidget.freeSlots != widget.freeSlots ||
        oldWidget.totalServiceDuration != widget.totalServiceDuration ||
        oldWidget.initialSelectedTime != widget.initialSelectedTime) {
      selectedTime.value = widget.initialSelectedTime ?? '';
    }
  }

  List<String> _generateAvailableTimes() {
    List<String> availableTimes = [];
    Set<String> uniqueTimes = {}; // To avoid duplicates

    // If freeSlots list is provided, generate times from all slots
    if (widget.freeSlots != null && widget.freeSlots!.isNotEmpty) {
      for (final slot in widget.freeSlots!) {
        final startDateTime = _parseTime(slot.start);
        final endDateTime = _parseTime(slot.end);

        if (startDateTime == null || endDateTime == null) continue;

        // Calculate the latest start time that allows for service duration
        final latestStartTime = endDateTime.subtract(
          Duration(minutes: widget.totalServiceDuration),
        );

        DateTime currentTime = startDateTime;

        // Generate time slots in 15-minute intervals for this slot
        while (currentTime.isBefore(latestStartTime) ||
            currentTime.isAtSameMomentAs(latestStartTime)) {
          final timeString = _formatTime(currentTime);
          if (uniqueTimes.add(timeString)) {
            availableTimes.add(timeString);
          }
          currentTime = currentTime.add(const Duration(minutes: 15));
        }
      }
    } else if (widget.slotStartTime != null && widget.slotEndTime != null) {
      // Fallback to single slot for backward compatibility
      final startDateTime = _parseTime(widget.slotStartTime!);
      final endDateTime = _parseTime(widget.slotEndTime!);

      if (startDateTime != null && endDateTime != null) {
        // Calculate the latest start time that allows for service duration
        final latestStartTime = endDateTime.subtract(
          Duration(minutes: widget.totalServiceDuration),
        );

        DateTime currentTime = startDateTime;

        // Generate time slots in 15-minute intervals
        while (currentTime.isBefore(latestStartTime) ||
            currentTime.isAtSameMomentAs(latestStartTime)) {
          availableTimes.add(_formatTime(currentTime));
          currentTime = currentTime.add(const Duration(minutes: 15));
        }
      }
    }

    // Sort times chronologically
    availableTimes.sort((a, b) {
      final timeA = _parseTime(a);
      final timeB = _parseTime(b);
      if (timeA == null || timeB == null) return 0;
      return timeA.compareTo(timeB);
    });
    
    return availableTimes;
  }

  DateTime? _parseTime(String timeString) {
    try {
      // Remove spaces and handle AM/PM
      String cleaned = timeString.replaceAll(' ', '');
      RegExp regex =
          RegExp(r'^(\d{1,2}):(\d{2})(AM|PM)?$', caseSensitive: false);
      final match = regex.firstMatch(cleaned);

      if (match != null) {
        int hour = int.parse(match.group(1)!);
        int minute = int.parse(match.group(2)!);
        String? period = match.group(3)?.toUpperCase();

        if (period != null) {
          if (period == 'PM' && hour != 12) hour += 12;
          if (period == 'AM' && hour == 12) hour = 0;
        }

        final now = DateTime.now();
        return DateTime(now.year, now.month, now.day, hour, minute);
      }
      return null;
    } catch (e) {
      debugPrint('Error parsing time: $e');
      return null;
    }
  }

  String _formatTime(DateTime dateTime) {
    int hour = dateTime.hour;
    int minute = dateTime.minute;

    String period = hour >= 12 ? 'PM' : 'AM';
    int displayHour = hour % 12 == 0 ? 12 : hour % 12;

    return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  @override
  Widget build(BuildContext context) {
    final availableTimes = _generateAvailableTimes();

    if (availableTimes.isEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Center(
          child: CustomText(
            text: "No available times for selected services duration",
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.gray500,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 60.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: availableTimes.length,
            itemBuilder: (context, index) {
              final time = availableTimes[index];
              return Obx(() {
                final isSelected = selectedTime.value == time;
                return GestureDetector(
                  onTap: () {
                    selectedTime.value = time;
                    widget.onTimeSelected(time);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOut,
                    margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 10.h),
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.secondary : Colors.transparent,
                      borderRadius: BorderRadius.circular(12.r),
                      border: isSelected
                          ? Border.all(color: AppColors.app, width: 2)
                          : Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: Center(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOut,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? AppColors.white : AppColors.black,
                        ),
                        child: Text(time),
                      ),
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

