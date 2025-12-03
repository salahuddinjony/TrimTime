import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/user_nav_bar/user_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class UserQueScreen extends StatelessWidget {
  const UserQueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final extra = GoRouter.of(context).state.extra;
    UserRole? userRole;
    if (extra is UserRole) {
      userRole = extra;
    } else if (extra is Map) {
      try {
        userRole = extra['userRole'] as UserRole?;
      } catch (_) {
        userRole = null;
      }
    }
    if (userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }
    return Scaffold(
      bottomNavigationBar: CustomNavBar(currentIndex: 1, role: userRole),
      backgroundColor: AppColors.searchScreenBg,
      appBar: const CustomAppBar(
        appBarContent: AppStrings.barbersTime,
        appBarBgColor: AppColors.searchScreenBg,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Hero Image/Icon Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(40.w),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .05),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        color: AppColors.black.withValues(alpha: .05),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.qr_code_scanner_rounded,
                        size: 80.sp,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'Join the Queue',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'Scan the shop QR code to join the queue and get your spot instantly',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40.h),

              // Features Section
              // _buildFeatureCard(
              //   icon: Icons.timer_outlined,
              //   title: 'Save Time',
              //   description:
              //       'No more waiting in line. Track your position in real-time',
              // ),

              // // SizedBox(height: 16.h),

              // // _buildFeatureCard(
              // //   icon: Icons.notifications_active_outlined,
              // //   title: 'Get Notified',
              // //   description: 'Receive notifications when it\'s almost your turn',
              // // ),

              // SizedBox(height: 16.h),

              // _buildFeatureCard(
              //   icon: Icons.schedule_outlined,
              //   title: 'Flexible Schedule',
              //   description: 'Join the queue from anywhere, anytime',
              // ),

              SizedBox(height: 40.h),

              // Scan Button
              Container(
                width: double.infinity,
                height: 56.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.black,
                      AppColors.black.withValues(alpha: 0.8)
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    AppRouter.route.pushNamed(
                      RoutePath.scannerScreen,
                      extra: userRole,
                    );
                  },
                  icon: Icon(
                    Icons.qr_code_scanner_rounded,
                    size: 24.sp,
                  ),
                  label: Text(
                    'Scan Shop QR Code',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // // Help Text
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Icon(
              //       Icons.info_outline,
              //       size: 16.sp,
              //       color: Colors.grey[600],
              //     ),
              //     SizedBox(width: 8.w),
              //     Text(
              //       'Ask the shop for their QR code',
              //       style: TextStyle(
              //         fontSize: 12.sp,
              //         color: Colors.grey[600],
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.black.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              icon,
              size: 24.sp,
              color: AppColors.black,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
