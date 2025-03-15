import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/following_card/following_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FollowingScreen extends StatelessWidget {
  const FollowingScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final userRole = GoRouter.of(context).state.extra as UserRole?;

    debugPrint("===================${userRole?.name}");
    if (userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.linearFirst,
        title: const Text(AppStrings.myFollowing),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ListView(
          children: [
            FollowingCard(
              imageUrl: AppConstants.demoImage, // Replace with actual image URL
              name: "Christian Ronaldo", // Example name
              status: "Unfollow", // Button text can be "Follow" or "Unfollow"
              onUnfollowPressed: () {
                // Handle unfollow action here
                debugPrint("Unfollowed Christian Ronaldo");
              },
            ),
            FollowingCard(
              imageUrl: AppConstants.demoImage, // Replace with actual image URL
              name: "Lionel Messi", // Example name
              status: "Unfollow", // Button text can be "Follow" or "Unfollow"
              onUnfollowPressed: () {
                // Handle unfollow action here
                debugPrint("Unfollowed Lionel Messi");
              },
            ),
            // Add more FollowingCard widgets as needed
          ],
        ),
      ),
    );
  }
}
