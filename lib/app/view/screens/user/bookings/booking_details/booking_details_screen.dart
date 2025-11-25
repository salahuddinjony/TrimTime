import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/models/barber_booking/barber_booking_model.dart';
import 'package:barber_time/app/view/screens/user/bookings/widget/booking_cancel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Helper to format date/time
String formatDateTime(DateTime dateTime) {
  return "${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
}

// Helper to get duration text
String durationText(BarberBookingData data) {
  if (data.bookedServices.isNotEmpty) {
    final totalMinutes =
        data.bookedServices.fold<int>(0, (sum, s) => sum + (s.duration));
    return "${totalMinutes} min duration";
  }
  return "-";
}

class BookingDetailsScreen extends StatelessWidget {
  final UserRole? userRole;
  final BarberBookingData bookingData;
  const BookingDetailsScreen(
      {super.key, this.userRole, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white50,
      appBar: const CustomAppBar(
        iconData: Icons.arrow_back,
        appBarContent: "Booking Details",
        appBarBgColor: AppColors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomNetworkImage(
                imageUrl: bookingData.userImage ?? AppConstants.shop,
                borderRadius: BorderRadius.circular(10.r),
                height: 174.h,
                width: double.infinity,
              ),
              SizedBox(height: 10.h),
              // Modern booking info card
              BookingInfoCard(bookingData: bookingData),
              // Modern, professional info card widget

              CustomText(
                text: "Selected services",
                fontWeight: FontWeight.w500,
                fontSize: 20.sp,
                color: AppColors.black,
              ),
              ...bookingData.bookedServices.map((service) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        top: 10,
                        text:
                            "${service.serviceName} - ${service.duration} Minutes",
                        fontWeight: FontWeight.w500,
                        fontSize: 18.sp,
                        color: AppColors.black,
                      ),
                      CustomText(
                        top: 2,
                        text: "£ ${service.price}",
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        color: AppColors.gray500,
                      ),
                    ],
                  )),
              const Divider(),
              Row(
                children: [
                  CustomText(
                    top: 10,
                    text: "Total: £${bookingData.totalPrice}",
                    fontWeight: FontWeight.w500,
                    fontSize: 18.sp,
                    color: AppColors.black,
                    right: 10,
                  ),
                  if (userRole != UserRole.barber) ...[
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          showCancelBookingDialog(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(10.r),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.r)),
                              border: Border.all(color: AppColors.black)),
                          child: CustomText(
                            text: "Cancel Booking",
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    GestureDetector(
                      onTap: () {
                        AppRouter.route.pushNamed(RoutePath.rescheduleScreen,
                            extra: userRole);
                      },
                      child: Container(
                        padding: EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.r)),
                            border: Border.all(color: AppColors.black)),
                        child: CustomText(
                          text: "Reschedule",
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white50,
                        ),
                      ),
                    ),
                  ]
                ],
              ),
              SizedBox(height: 10.h),
              CustomText(
                text: "Booking ID: ${bookingData.bookingId}",
                fontSize: 12.sp,
                color: AppColors.gray500,
              ),
              CustomText(
                text: "Status: ${bookingData.status}",
                fontSize: 12.sp,
                color: AppColors.gray500,
              ),
              CustomText(
                text: "Created at: ${formatDateTime(bookingData.createdAt)}",
                fontSize: 12.sp,
                color: AppColors.gray500,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showCancelBookingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: CustomText(
            text: "Are you sure want \n to cancel the booking?",
            maxLines: 2,
            fontSize: 16.sp,
            color: AppColors.black,
          ),
          actions: <Widget>[
            // Cancel Button
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              onPressed: () {
                // Handle cancel action
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            // Confirm Button
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppColors.secondary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              onPressed: () {
                bookingCancel(context);
                print('Booking canceled');
              },
              child: const Text(
                'Confirm',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Modern, professional info card widget
class BookingInfoCard extends StatelessWidget {
  final BarberBookingData bookingData;
  const BookingInfoCard({Key? key, required this.bookingData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .06),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.gray500.withValues(alpha: .08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Date and duration in a colored card
          Container(
            padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: .08),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: .18),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.calendar_month,
                          color: AppColors.secondary, size: 20),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      formatDateTime(bookingData.startDateTime),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 17.sp,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  durationText(bookingData),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15.sp,
                    color: AppColors.gray500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 18.h),
          // Name centered and bold
          Text(
            bookingData.userFullName,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16.sp,
              color: AppColors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10.h),
          // Email with icon
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.all(6),
                child: Icon(Icons.email, color: AppColors.secondary, size: 20),
              ),
              SizedBox(width: 12),
              Flexible(
                child: Text(
                  bookingData.userEmail,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15.sp,
                    color: AppColors.gray500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          // Phone plain
          Text(
            bookingData.userPhoneNumber,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15.sp,
              color: AppColors.gray500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Info row widget for card
class InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;
  final TextStyle textStyle;
  const InfoRow({
    required this.icon,
    required this.iconColor,
    required this.text,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: .12),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.all(6),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        SizedBox(width: 12),
        Flexible(
          child: Text(
            text,
            style: textStyle,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}
