import 'package:barber_time/app/global/helper/extension/extension.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/screens/owner/owner_home/controller/barber_owner_home_controller.dart';
import 'package:barber_time/app/view/screens/owner/owner_home/inner_widgets/monitization_date_picar.dart';
import 'package:barber_time/app/view/screens/owner/owner_home/model/date_wise_booking_data/date_wise_booking_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class OwnerRequestBooking extends StatelessWidget {
  final BarberOwnerHomeController controller;
  final userRole;
  const OwnerRequestBooking(
      {super.key, required this.controller, this.userRole});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarContent: "Booking",
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          children: [
            HorizontalDatePicker(
              controller: controller,
            ),
            Expanded(
              child: Obx(() {
                if (controller.dateWiseBookingsStatus.value.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final data = controller.dateWiseBookings;
                if (data.isEmpty) {
                  return Center(
                    child: CustomText(
                      text:
                          "No bookings available for ${controller.selectedDate.formatDate()}.",
                      fontSize: 16.sp,
                      maxLines: 2,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        _showBookingDialog(context, data[index]);
                      },
                      child: ServiceTile(
                        serviceName: data[index].customerName.safeCap(),
                        serviceTime:
                            data[index].startTime + " - " + data[index].endTime,
                        barberName: data[index].barberName,
                        price: data[index].totalPrice,
                        imagePath: data[index].barberImage,
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showBookingDialog(BuildContext context, BookingData bookingData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final maxHeight = MediaQuery.of(context).size.height * 0.8;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Center(
            child: Row(
              children: [
                Text(
                  'Booking Details',
                  style:
                      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.black,
                    ))
              ],
            ),
          ),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: maxHeight,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(),
                  SizedBox(
                    height: 8,
                  ),
                  IconTextRow(
                    icon: Icons.calendar_month,
                    text: DateTime.tryParse(bookingData.bookingDate)
                            ?.formatDate() ??
                        '',
                    subtitle: bookingData.status.safeCap(),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Divider(),
                  SizedBox(
                    height: 8,
                  ),
                  IconTextRow(
                    icon: Icons.watch_later,
                    text: bookingData.startTime + " - " + bookingData.endTime,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Divider(),
                  SizedBox(
                    height: 8,
                  ),
                  CustomerInfo(customerData: {
                    'name': bookingData.customerName,
                    'email': bookingData.customerEmail,
                    'phone': bookingData.customerPhone,
                    'notes': bookingData.notes,
                    'image': bookingData.customerImage,
                  }),
                  IconTextRow(
                    icon: Icons.cut,
                    text: 'Barber: ${bookingData.barberName}',
                    subtitle: null,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Divider(),
                  IconTextRow(
                    icon: Icons.notes,
                    text: 'Services',
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 30.w),
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.list_alt,
                                color: AppColors.secondary, size: 20),
                            SizedBox(width: 8.w),
                            CustomText(
                              text:
                                  "${bookingData.services.length} Services Selected",
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                              color: AppColors.black,
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        ...bookingData.services
                            .map((service) => Container(
                                  margin: EdgeInsets.only(bottom: 8.h),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.h, horizontal: 8.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(
                                        color: AppColors.secondary
                                            .withValues(alpha: 0.2)),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.cut,
                                          color: AppColors.secondary, size: 18),
                                      SizedBox(width: 8.w),
                                      Expanded(
                                        child: CustomText(
                                          text: service.serviceName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.sp,
                                          color: AppColors.seconderDark,
                                        ),
                                      ),
                                      CustomText(
                                        text:
                                            "\$${service.price.toStringAsFixed(2)}",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.sp,
                                        color: AppColors.black,
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  CustomText(
                    text:
                        "Total Price: \$${bookingData.totalPrice.toStringAsFixed(2)}",
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    color: AppColors.black,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: CustomButton(
                    onTap: () {

                      context.pop();
                    },
                    textColor: AppColors.white,
                    fillColor: AppColors.secondary,
                    title: "Booking Cancel",
                  ),
                ),
                // SizedBox(
                //   width: 8.w,
                // ),
                // Expanded(
                //   flex: 5,
                //   child: CustomButton(
                //     onTap: () {
                //       context.pushNamed(
                //         RoutePath.rescheduleScreen,
                //       );
                //     },
                //     textColor: AppColors.white,
                //     fillColor: AppColors.secondary,
                //     title: "Reschedule",
                //   ),
                // ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget serviceTiles(String serviceName, String client, double price) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.orange, width: 1),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundImage:
                AssetImage('assets/talha.png'), // Replace with actual image
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                serviceName,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                client,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey),
              ),
            ],
          ),
          Spacer(),
          Text(
            '\$$price',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceTile extends StatelessWidget {
  final String serviceName;
  final String serviceTime;
  final String barberName;
  final double price;
  final String imagePath;

  const ServiceTile({
    super.key,
    required this.serviceName,
    required this.serviceTime,
    required this.barberName,
    required this.price,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.orange300,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.orange, width: 1),
      ),
      child: Row(
        children: [
          // Barber's Image
          CustomNetworkImage(
            imageUrl: AppConstants.demoImage,
            height: 43,
            width: 43,
            boxShape: BoxShape.circle,
          ),
          SizedBox(width: 12.w),
          // Service Details
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                serviceName,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                serviceTime,
                style: TextStyle(fontSize: 14.sp, color: Colors.white),
              ),
              SizedBox(height: 4.h),
              Text(
                'Barber: $barberName',
                style: TextStyle(fontSize: 14.sp, color: Colors.white),
              ),
            ],
          ),
          Spacer(),
          // Price
          Text(
            '\$${price.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable IconTextRow widget
class IconTextRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final String? subtitle;

  const IconTextRow({
    super.key,
    required this.icon,
    required this.text,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.black,
        ),
        SizedBox(width: 8.0), // Adjust the spacing between the icon and text
        CustomText(
          left: 8.0,
          text: text.safeCap(),
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        ),
        if (subtitle != null) ...[
          SizedBox(width: 8.0),
          CustomText(
            left: 8.0,
            text: subtitle!,
            fontSize: 11.0,
            fontWeight: FontWeight.w400,
            color: AppColors.bodyGrayMedium,
          ),
        ],
      ],
    );
  }
}

class CustomerInfo extends StatelessWidget {
  final Map<String, dynamic> customerData;
  const CustomerInfo({super.key, required this.customerData});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 8.w, right: 8.w, bottom: 8.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(color: AppColors.secondary.withValues(alpha: .15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.secondary.withValues(alpha: .15),
                backgroundImage: customerData['image'] != null
                    ? CachedNetworkImageProvider(customerData['image'])
                    : null,
                child: customerData['image'] == null
                    ? Icon(Icons.person_4_rounded, color: AppColors.secondary)
                    : null,
                radius: 20.r,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: customerData['name'] ?? "N/A",
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                      color: AppColors.black,
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Icon(Icons.email,
                            size: 16, color: AppColors.bodyGrayMedium),
                        SizedBox(width: 4.w),
                        Flexible(
                          child: CustomText(
                            text: customerData['email'] ?? "N/A",
                            fontWeight: FontWeight.w400,
                            fontSize: 13.sp,
                            color: AppColors.bodyGrayMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Icon(Icons.phone, size: 16, color: AppColors.bodyGrayMedium),
              SizedBox(width: 4.w),
              CustomText(
                text: customerData['phone'] ?? "N/A",
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
                color: AppColors.black,
              ),
            ],
          ),
          if ((customerData['notes'] ?? "").toString().isNotEmpty) ...[
            SizedBox(height: 10.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.sticky_note_2,
                    size: 16, color: AppColors.bodyGrayMedium),
                SizedBox(width: 4.w),
                Flexible(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: CustomText(
                      text: customerData['notes'],
                      fontWeight: FontWeight.w400,
                      fontSize: 13.sp,
                      color: AppColors.bodyGrayMedium,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
