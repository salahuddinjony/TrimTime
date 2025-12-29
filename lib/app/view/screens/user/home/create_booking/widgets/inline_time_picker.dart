import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InlineTimePicker extends StatefulWidget {
  final String slotStartTime;
  final String slotEndTime;
  final int totalServiceDuration; // in minutes
  final Function(String selectedTime) onTimeSelected;
  final String? initialSelectedTime;

  const InlineTimePicker({
    Key? key,
    required this.slotStartTime,
    required this.slotEndTime,
    required this.totalServiceDuration,
    required this.onTimeSelected,
    this.initialSelectedTime,
  }) : super(key: key);

  @override
  State<InlineTimePicker> createState() => _InlineTimePickerState();
}

class _InlineTimePickerState extends State<InlineTimePicker> {
  String? selectedTime;
  List<String> availableTimes = [];

  @override
  void initState() {
    super.initState();
    _generateAvailableTimes();
    // Set initial selected time if provided
    if (widget.initialSelectedTime != null &&
        widget.initialSelectedTime!.isNotEmpty) {
      selectedTime = widget.initialSelectedTime;
    }
  }

  @override
  void didUpdateWidget(InlineTimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.slotStartTime != widget.slotStartTime ||
        oldWidget.slotEndTime != widget.slotEndTime ||
        oldWidget.totalServiceDuration != widget.totalServiceDuration) {
      _generateAvailableTimes();
      selectedTime = widget.initialSelectedTime;
    }
  }

  void _generateAvailableTimes() {
    final startDateTime = _parseTime(widget.slotStartTime);
    final endDateTime = _parseTime(widget.slotEndTime);

    if (startDateTime == null || endDateTime == null) return;

    // Calculate the latest start time that allows for service duration
    final latestStartTime = endDateTime.subtract(
      Duration(minutes: widget.totalServiceDuration),
    );

    DateTime currentTime = startDateTime;
    availableTimes.clear();

    // Generate time slots in 15-minute intervals
    while (currentTime.isBefore(latestStartTime) ||
        currentTime.isAtSameMomentAs(latestStartTime)) {
      availableTimes.add(_formatTime(currentTime));
      currentTime = currentTime.add(const Duration(minutes: 15));
    }
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
    return Container(
      margin: EdgeInsets.only(top: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: "Select Start Time",
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ],
          ),
          SizedBox(height: 10.h),

          // Info section
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: "Available Slot:",
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.gray500,
                    ),
                    CustomText(
                      text: "${widget.slotStartTime} - ${widget.slotEndTime}",
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: "Service Duration:",
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.gray500,
                    ),
                    CustomText(
                      text: "${widget.totalServiceDuration} min",
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 15.h),

          // Time selection horizontal scrollable list
          if (availableTimes.isEmpty)
            Container(
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
            )
          else
            SizedBox(
              height: 60.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: availableTimes.length,
                itemBuilder: (context, index) {
                  final time = availableTimes[index];
                  final isSelected = selectedTime == time;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTime = time;
                      });
                      widget.onTimeSelected(time);
                    },
                    child: Chip(
                      label: CustomText(
                        text: time,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? AppColors.white
                            : AppColors.black,
                      ),
                      backgroundColor: isSelected
                          ? AppColors.secondary
                          : Colors.transparent,
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.app
                            : AppColors.secondary,
                        width: isSelected ? 2 : 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      avatar: isSelected
                          ? Container(
                              padding: EdgeInsets.all(2.r),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check,
                                color: AppColors.secondary,
                                size: 12.sp,
                              ),
                            )
                          : null,
                      labelPadding: EdgeInsets.symmetric(
                        horizontal: isSelected ? 4.w : 8.w,
                        vertical: 0,
                      ),
                      materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.symmetric(
                        horizontal: isSelected ? 2.w : 8.w,
                        vertical: 8.h,
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(width: 10.w),
              ),
            ),
        ],
      ),
    );
  }
}

