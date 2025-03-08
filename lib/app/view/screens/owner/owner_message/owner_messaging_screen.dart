import 'package:barber_time/app/core/bottom_navbar.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import 'package:barber_time/app/view/common_widgets/custom_messaging_card/custom_messaging_card.dart';
import 'package:flutter/material.dart';

class OwnerMessagingScreen extends StatelessWidget {
  const OwnerMessagingScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String roleFromDatabase = "owner";
    UserRole userRole = getRoleFromString(roleFromDatabase);
    return Scaffold(
      bottomNavigationBar: BottomNavbar(
        currentIndex: 1,
        role: getRoleFromString(userRole.name),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(AppStrings.messaging),
      ),
      body: ClipPath(
        clipper: CurvedBannerClipper(),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 1.5,
          color: AppColors.orange700,
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: ListView.builder(
                  itemCount: 7,
                  itemBuilder: (context, index) {
                return CustomMessageCard(
                  senderName: 'Italian Fashion Saloon',
                  message: 'Hey, Can I get a side cut for hair? And the price?And the price?',
                  imageUrl: AppConstants.demoImage,
                  onTap: () => print('Message Clicked'),
                );
              })),
        ),
      ),
    );
  }
}
