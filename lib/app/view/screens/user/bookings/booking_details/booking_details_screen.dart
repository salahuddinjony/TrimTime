import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/global/helper/extension/extension.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/models/barber_booking/barber_booking_model.dart';
import 'package:barber_time/app/view/screens/user/bookings/models/customer_bookins_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;

// Helper to format date/time
String formatDateTime(DateTime dateTime) {
  return "${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}";
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

class BookingDetailsScreen<T> extends StatelessWidget {
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  final UserRole? userRole;
  final dynamic bookingData; // Accepts BarberBookingData or CustomerBooking
  final T? controller;
  final String? bookingType;
  const BookingDetailsScreen(
      {super.key,
      this.userRole,
      required this.bookingData,
      this.controller,
      this.bookingType});

  @override
  Widget build(BuildContext context) {
    // Map CustomerBooking to a compatible structure if needed
    final isCustomerBooking = bookingData is CustomerBooking;

    // Common fields
    final String imageUrl = isCustomerBooking
        ? (bookingData.customerImage?.isNotEmpty == true
            ? bookingData.customerImage
            : AppConstants.shop)
        : (bookingData.userImage ?? AppConstants.shop);
    final String userFullName =
        isCustomerBooking ? bookingData.customerName : bookingData.userFullName;
    final String userEmail =
        isCustomerBooking ? bookingData.customerEmail : bookingData.userEmail;
    final String userPhoneNumber = isCustomerBooking
        ? bookingData.customerContact
        : bookingData.userPhoneNumber;
    final double totalPrice = isCustomerBooking
        ? (bookingData.totalPrice is int
            ? (bookingData.totalPrice as int).toDouble()
            : (bookingData.totalPrice as double))
        : (bookingData.totalPrice is int
            ? (bookingData.totalPrice as int).toDouble()
            : (bookingData.totalPrice as double));
    final String status =
        isCustomerBooking ? bookingData.status : bookingData.status;
    final DateTime createdAt =
        isCustomerBooking ? bookingData.date : bookingData.createdAt;
    final DateTime startDateTime =
        isCustomerBooking ? bookingData.date : bookingData.startDateTime;
    
    // Extract startTime and endTime for CustomerBooking
    final String? startTime = isCustomerBooking ? bookingData.startTime : null;
    final String? endTime = isCustomerBooking ? bookingData.endTime : null;
    final String bookingTypeDisplay = isCustomerBooking 
        ? (bookingData.bookingType == 'QUEUE' ? 'Queue' : 'Booking')
        : 'Booking';

    // Services
    final List<Map<String, dynamic>> services = isCustomerBooking
        ? List.generate(
            bookingData.serviceNames.length,
            (i) => {
              'serviceName': bookingData.serviceNames[i],
              'duration': bookingData.serviceDurations.length > i
                  ? bookingData.serviceDurations[i]
                  : 0,
              'price': null, // No price per service in CustomerBooking
            },
          )
        : (bookingData.bookedServices is List<BookedService>
            ? (bookingData.bookedServices as List<BookedService>)
                .map((s) => {
                      'serviceName': s.serviceName,
                      'duration': s.duration,
                      'price': s.price,
                    })
                .toList()
            : (bookingData.bookedServices is List
                ? (bookingData.bookedServices as List)
                    .map((s) =>
                        s is Map<String, dynamic> ? s : <String, dynamic>{})
                    .toList()
                : []));

    return Scaffold(
      backgroundColor: AppColors.white50,
      appBar: CustomAppBar(
        iconData: Icons.arrow_back,
        appBarContent: "$bookingTypeDisplay Details",
        appBarBgColor: AppColors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomNetworkImage(
                imageUrl: imageUrl,
                borderRadius: BorderRadius.circular(10.r),
                height: 200.h,
                width: double.infinity,
              ),
              SizedBox(height: 10.h),
              BookingInfoCard(
                userFullName: userFullName.safeCap(),
                userEmail: userEmail,
                userPhoneNumber: userPhoneNumber,
                startDateTime: startDateTime,
                services: services,
                startTime: startTime,
                endTime: endTime,
              ),
              // Status badge moved above Selected services
              Row(
                children: [
                  CustomText(
                    text: "Status",
                    fontSize: 14.sp,
                    color: AppColors.gray500,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(width: 10.w),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: getStatusColor(status),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Spacer(),
                  CustomText(
                    text: "Created at: ${formatDateTime(createdAt)}",
                    fontSize: 14.sp,
                    color: AppColors.gray500,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
              SizedBox(height: 30),

              CustomText(
                text: "Selected services",
                fontWeight: FontWeight.w500,
                fontSize: 20.sp,
                color: AppColors.black,
              ),
              ...services.map((service) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        top: 10,
                        text:
                            "${service['serviceName']} - ${service['duration']} Minutes",
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        color: AppColors.black,
                      ),
                      if (service['price'] != null)
                        CustomText(
                          top: 2,
                          text: "£ ${service['price']}",
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
                    text: "Total: £$totalPrice",
                    fontWeight: FontWeight.w500,
                    fontSize: 18.sp,
                    color: AppColors.black,
                    right: 10,
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              if (userRole == UserRole.user &&
                  (status.toLowerCase() != "cancelled" &&
                      status.toLowerCase() != "completed" &&
                      status.toLowerCase() != "confirmed")) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showCancelBookingDialog(
                          context, 
                          controller,
                          bookingId: isCustomerBooking ? bookingData.bookingId : "",
                          bookingType: bookingTypeDisplay,
                        );
                      },
                      child: Container(
                        padding: bookingType?.toLowerCase() != 'booking'
                            ? EdgeInsets.symmetric(
                                vertical: 13.r, horizontal: 30.r)
                            : EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.r)),
                            border: Border.all(color: AppColors.black)),
                        child: CustomText(
                          text: bookingTypeDisplay == 'Queue' 
                              ? "Cancel Queue" 
                              : "Cancel Booking",
                          fontSize: bookingType?.toLowerCase() != 'booking'
                              ? 16.sp
                              : 14.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    if (bookingType?.toLowerCase() == 'booking') ...[
                      SizedBox(width: 20.w),
                      GestureDetector(
                        onTap: () {
                          debugPrint("Reschedule tapped");
                          debugPrint(
                              "Passing userId: ${isCustomerBooking ? bookingData.saloonOwnerId + "sealoon" : bookingData.userId}");

                          // Extract service names and durations
                          List<String> serviceNamesList = [];
                          List<int> serviceDurationsList = [];

                          if (isCustomerBooking) {
                            serviceNamesList = bookingData.serviceNames;
                            serviceDurationsList = bookingData.serviceDurations;

                            //
                            // get barber with date
                            (controller as dynamic)?.getbarberWithDate(
                                barberId: bookingData.saloonOwnerId,
                                date: intl.DateFormat('yyyy-MM-dd').format(
                                    (controller as dynamic).selectedDate));
                          } else {
                            // For BarberBookingData
                            if (bookingData.bookedServices != null) {
                              for (var service in bookingData.bookedServices) {
                                serviceNamesList.add(service.serviceName);
                                serviceDurationsList.add(service.duration);
                              }
                            }
                          }

                          AppRouter.route
                              .pushNamed(RoutePath.rescheduleScreen, extra: {
                            'bookingId': bookingData.bookingId,
                            'userRole': userRole,
                            'controller': controller,
                            'userId': isCustomerBooking
                                ? bookingData.saloonOwnerId
                                : bookingData.userId,
                            'serviceNames': serviceNamesList,
                            'serviceDurations': serviceDurationsList,
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.r, horizontal: 20.r),
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
                    ],
                  ],
                )
              ],
              SizedBox(height: 30.h),
              // Row(
              //   children: [
              //     Container(
              //       padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              //       decoration: BoxDecoration(
              //         color: getStatusColor(status),
              //         borderRadius: BorderRadius.circular(8),
              //       ),
              //       child: Text(
              //         status,
              //         style: TextStyle(
              //           color: Colors.white,
              //           fontSize: 12.sp,
              //           fontWeight: FontWeight.bold,
              //           letterSpacing: 0.5,
              //         ),
              //       ),
              //     ),
              //     SizedBox(width: 10.w),
              //     CustomText(
              //       text: "Status",
              //       fontSize: 12.sp,
              //       color: AppColors.gray500,
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void showCancelBookingDialog(BuildContext context, T? controller,
      {required String bookingId, String? bookingType}) {
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
            text: bookingType == 'Queue'
                ? "Are you sure you want \n to cancel this queue?"
                : "Are you sure you want \n to cancel this booking?",
            maxLines: 2,
            fontSize: 16.sp,
            color: AppColors.black,
          ),
          actions: <Widget>[
            // Cancel Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    minimumSize: Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                SizedBox(width: 10),
                // Confirm Button
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    minimumSize: Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () async {
                    debugPrint('Cancel booking confirmed');
                    final success = await (controller as dynamic)
                        .cancelBooking(bookingId: bookingId);
                    if (success) {
                      Navigator.of(context).pop(); // Close the dialog
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Confirm',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}

// Modern, professional info card widget
class BookingInfoCard extends StatelessWidget {
  final String userFullName;
  final String userEmail;
  final String userPhoneNumber;
  final DateTime startDateTime;
  final List<Map<String, dynamic>> services;
  final String? startTime;
  final String? endTime;
  const BookingInfoCard({
    Key? key,
    required this.userFullName,
    required this.userEmail,
    required this.userPhoneNumber,
    required this.startDateTime,
    required this.services,
    this.startTime,
    this.endTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int totalMinutes = 0;
    if (services.isNotEmpty) {
      totalMinutes = services.fold<int>(
          0, (sum, s) => sum + ((s['duration'] ?? 0) as int));
    }
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
        border: Border.all(color: AppColors.gray500.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Date and duration in a colored card
          Container(
            padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.calendar_month,
                          color: AppColors.secondary, size: 20),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      formatDateTime(startDateTime),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 17.sp,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                // Display time range if available, otherwise show duration
                if (startTime != null && endTime != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.access_time, 
                                color: AppColors.secondary, size: 16),
                            SizedBox(width: 6.w),
                            Text(
                              startTime!,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                                color: AppColors.black,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6.w),
                              child: Text(
                                '-',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                  color: AppColors.gray500,
                                ),
                              ),
                            ),
                            Text(
                              endTime!,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                                color: AppColors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    totalMinutes > 0 ? "$totalMinutes min duration" : "-",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13.sp,
                      color: AppColors.gray500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ] else ...[
                  Text(
                    totalMinutes > 0 ? "$totalMinutes min duration" : "-",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15.sp,
                      color: AppColors.gray500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: 18.h),
          // Name centered and bold
          Text(
            userFullName,
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
                  color: AppColors.secondary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.all(6),
                child: Icon(Icons.email, color: AppColors.secondary, size: 20),
              ),
              SizedBox(width: 12),
              Flexible(
                child: Text(
                  userEmail,
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
            userPhoneNumber,
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
