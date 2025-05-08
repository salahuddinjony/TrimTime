import 'package:barber_time/app/core/bottom_navbar.dart';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class OwnerRequestBooking extends StatefulWidget {
  const OwnerRequestBooking({super.key});

  @override
  _ServiceListScreenState createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<OwnerRequestBooking> {
  // List of services with their details
  final List<Map<String, dynamic>> services = [
    {
      'name': 'Hair Cut & Beard Cut',
      'time': '09:00 - 09:30',
      'barber': 'Talha',
      'price': 35.0,
      'image': 'assets/talha.png',
      // Make sure to add the barber image in your assets
    },
    {
      'name': 'Arm Wax',
      'time': '09:00 - 09:30',
      'barber': 'Talha',
      'price': 20.0,
      'image': 'assets/talha.png',
    },
    {
      'name': 'Arm Wax',
      'time': '09:00 - 09:30',
      'barber': 'Talha',
      'price': 20.0,
      'image': 'assets/talha.png',
    },
    {
      'name': 'Arm Wax',
      'time': '09:00 - 09:30',
      'barber': 'Talha',
      'price': 20.0,
      'image': 'assets/talha.png',
    },
    {
      'name': 'Hair Cut & Beard Cut',
      'time': '09:00 - 09:30',
      'barber': 'Talha',
      'price': 35.0,
      'image': 'assets/talha.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarContent: "Booking",
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: ListView.builder(
          itemCount: services.length,
          itemBuilder: (context, index) {
            var service = services[index];
            return GestureDetector(
              onTap: () {
                _showBookingDialog(context);
              },
              child: ServiceTile(
                serviceName: service['name'],
                serviceTime: service['time'],
                barberName: service['barber'],
                price: service['price'],
                imagePath: service['image'],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showBookingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(),
                SizedBox(
                  height: 8,
                ),
                IconTextRow(
                  icon: Icons.calendar_month,
                  text: '26 December 2023',
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
                  text: '09:00 am - 09:30am',
                ),
                SizedBox(
                  height: 8,
                ),
                Divider(),
                SizedBox(
                  height: 8,
                ),
                IconTextRow(
                  icon: Icons.person,
                  text: 'Barber: Faizan',
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
                Row(
                  children: [
                    SizedBox(width: 30.w,),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10.r),
                        color: AppColors.secondary,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: "Hair Cut & Beard Cut",
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                              color: AppColors.black,
                            ),
                            Row(
                              children: [
                                CustomText(
                                  text: "Client: Jacob Shawn",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                  color: AppColors.seconderDark,
                                ),
                                     Spacer(),
                                CustomText(
                                  text: "\$10",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                  color: AppColors.black,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
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
                    title: "Request Cancel",
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                Expanded(
                  flex: 5,
                  child: CustomButton(
                    onTap: () {
                      context.pushNamed(RoutePath.rescheduleScreen,);
                    },
                    textColor: AppColors.white,
                    fillColor: AppColors.secondary,
                    title: "Request reschedule",
                  ),
                ),
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

  const IconTextRow({
    super.key,
    required this.icon,
    required this.text,
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
          text: text,
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        ),
      ],
    );
  }
}
