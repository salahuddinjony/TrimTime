import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimePickerDialog extends StatefulWidget {
  final String slotStartTime;
  final String slotEndTime;
  final int totalServiceDuration; // in minutes
  final Function(String selectedTime) onTimeSelected;
  final String? initialSelectedTime;

  const TimePickerDialog({
    Key? key,
    required this.slotStartTime,
    required this.slotEndTime,
    required this.totalServiceDuration,
    required this.onTimeSelected,
    this.initialSelectedTime,
  }) : super(key: key);

  @override
  State<TimePickerDialog> createState() => _TimePickerDialogState();
}

class _TimePickerDialogState extends State<TimePickerDialog> {
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

  void _generateAvailableTimes() {
    final startDateTime = _parseTime(widget.slotStartTime);
    final endDateTime = _parseTime(widget.slotEndTime);

    if (startDateTime == null || endDateTime == null) return;

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
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: EdgeInsets.only(top: 12.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.gray300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: "Select Start Time",
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: AppColors.gray500),
                            onPressed: () => Navigator.of(context).pop(),
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
                                  text:
                                      "${widget.slotStartTime} - ${widget.slotEndTime}",
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

                      // Time selection grid
                      if (availableTimes.isEmpty)
                        Expanded(
                          child: Center(
                            child: CustomText(
                              text:
                                  "No available times for selected services duration",
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.gray500,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: GridView.builder(
                            controller: scrollController,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10.w,
                              mainAxisSpacing: 10.h,
                              childAspectRatio: 2,
                            ),
                            itemCount: availableTimes.length,
                            itemBuilder: (context, index) {
                              final time = availableTimes[index];
                              final isSelected = selectedTime == time;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedTime = time;
                                  });
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
                          ),
                        ),

                      SizedBox(height: 15.h),

                      // Confirm button
                      SizedBox(
                        width: 0.8.sw,
                        child: ElevatedButton(
                          onPressed: selectedTime != null
                              ? () {
                                  widget.onTimeSelected(selectedTime!);
                                  Navigator.of(context).pop();
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            disabledBackgroundColor: AppColors.gray300,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: CustomText(
                            text: "Confirm Time",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
