import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/common_profile_total_card/common_profile_total_card.dart';

class ShopProfileScreen extends StatelessWidget {
  const ShopProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userRole = GoRouter.of(context).state.extra as UserRole?;
    debugPrint("===================${userRole?.name}");
    if (userRole == null) {
      return _errorScreen();
    }
    return Scaffold(
      appBar: const CustomAppBar(
        appBarBgColor: AppColors.last,
        appBarContent: "Shop Profile",
        iconData: Icons.arrow_back,
      ),
      body: _buildBody(context, userRole),
    );
  }

  // Error screen when userRole is null
  Widget _errorScreen() {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: const Center(child: Text('No user role received')),
    );
  }

  // Main body of the ShopProfileScreen
  Widget _buildBody(BuildContext context, UserRole? userRole) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.first, AppColors.last],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(context, userRole),
              Expanded(child: _buildProfileContent(context)),
            ],
          ),
        ),
      ),
    );
  }

  // Profile header widget with shop name, description, and buttons
  Widget _buildProfileHeader(BuildContext context, UserRole? userRole) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 60),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.1), blurRadius: 8, spreadRadius: 2, offset: const Offset(0, 8))],
          ),
          child: Column(
            children: [
              SizedBox(height: 50.h),
              CustomText(text: "Barber time", fontSize: 18.sp, fontWeight: FontWeight.w600, color: AppColors.black),
              SizedBox(height: 10.h),
              CustomText(
                maxLines: 20,
                text: "Great haircuts aren’t just a service; they’re an experience! With 10 years in the game, I specialize in fades, tapers, and beard perfection.",
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.black,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15.w),
              _buildActionButtons(context, userRole),
            ],
          ),
        ),
        Positioned(
          top: 0,
          child: CustomNetworkImage(
            imageUrl: AppConstants.shop,
            height: 100,
            width: 100,
            boxShape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  // Action buttons (Location and More Info)
  Widget _buildActionButtons(BuildContext context, UserRole? userRole) {
    return Row(
      children: [
        _buildActionButton(context, "View", Icons.location_on, () {
          AppRouter.route.pushNamed(RoutePath.mapViewScreen, extra: userRole);
        }),
        SizedBox(width: 10.w),
        _buildActionButton(context, "More Info", null, () {
          _showInformationDialog(context);
        }),
      ],
    );
  }

  // Reusable button widget for actions (e.g., "View" and "More Info")
  Widget _buildActionButton(BuildContext context, String label, IconData? icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(5.r),
        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(7)),
        child: Row(
          children: [
            if (icon != null) Icon(icon, color: Colors.white, size: 10),
            if (icon != null) SizedBox(width: 5.w),
            CustomText(text: label, fontSize: 10.sp, fontWeight: FontWeight.w400, color: AppColors.whiteColor),
          ],
        ),
      ),
    );
  }

  // Profile content widget (ratings, barbers, gallery, etc.)
  Widget _buildProfileContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          _buildTotalCards(),
          const CustomText(
            top: 10,
            bottom: 8,
            text: "All Barbers",
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
          _buildBarbersList(),
          const SizedBox(height: 10),
          _buildGallery(),
          _buildAddReviewButton(context),
        ],
      ),
    );
  }

  // Total cards for ratings, following, etc.
  Widget _buildTotalCards() {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CommonProfileTotalCard(title: AppStrings.ratings, value: "290+"),
        SizedBox(width: 8),
        CommonProfileTotalCard(title: AppStrings.following, value: "150+"),
        SizedBox(width: 8),
        CommonProfileTotalCard(title: "Follower", value: "500+"),
      ],
    );
  }

  // List of barbers
  Widget _buildBarbersList() {
    return Row(
      children: List.generate(4, (index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CustomNetworkImage(
                  imageUrl: AppConstants.demoImage,
                  height: 58.h,
                  boxShape: BoxShape.circle,
                  width: 58.h),
              const CustomText(
                text: "Jacob Jones",
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ],
          ),
        );
      }),
    );
  }

  // Gallery section
  Widget _buildGallery() {
    return Column(
      children: [
        const CustomText(
          top: 10,
          text: 'Gallery',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.gray500,
          bottom: 10,
        ),
        CustomNetworkImage(imageUrl: AppConstants.demoImage, height: 78, width: 96),
        const SizedBox(height: 20),
      ],
    );
  }

  // Add Review button
  Widget _buildAddReviewButton(BuildContext context) {
    return Center(
      child: CustomButton(
        width: MediaQuery.of(context).size.width / 2,
        fillColor: AppColors.last,
        borderColor: Colors.white,
        textColor: Colors.white,
        onTap: () {},
        title: AppStrings.addReview,
      ),
    );
  }

  // Show the information dialog
  void _showInformationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.white50,
          title: CustomText(
            text: "Information",
            fontSize: 20.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.black,
          ),
          content: _buildInformationDialogContent(),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInformationDialogContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildInfoRow(Icons.person, "James Tracy"),
        _buildInfoRow(Icons.cake, "22-03-1998"),
        _buildInfoRow(Icons.email, "James@gmail.com"),
        _buildInfoRow(Icons.phone, "+44 26537 26347"),
        _buildInfoRow(Icons.location_on, "Abu Dhabi"),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppColors.orange500),
        SizedBox(width: 8.w),
        CustomText(text: text, fontSize: 16.sp, fontWeight: FontWeight.w300, color: AppColors.black),
      ],
    );
  }
}
