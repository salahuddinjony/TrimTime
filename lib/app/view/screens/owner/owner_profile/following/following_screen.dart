import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/following_card/following_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';

class FollowingScreen extends StatefulWidget {
  const FollowingScreen({super.key});

  @override
  _FollowingScreenState createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  // List of users that are followed
  List<Map<String, String>> followingUsers = [
    {
      "name": "Christian Ronaldo",
      "imageUrl": AppConstants.demoImage,
      "status": "Unfollow",
    },
    {
      "name": "Lionel Messi",
      "imageUrl": AppConstants.demoImage,
      "status": "Unfollow",
    },
    // Add more users as needed
  ];

  // Method to handle unfollow action
  void _unfollowUser(int index) {
    setState(() {
      followingUsers.removeAt(index); // Remove the user from the list
    });
  }

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
      body:
      ClipPath(
        clipper: CurvedBannerClipper(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 1.2,
          decoration: const BoxDecoration(
              // color: AppColors.searchScreenBg,
            gradient: LinearGradient(
              colors: [
                Color(0xCCEDC4AC), // First color (with opacity)
                Color(0xFFE9874E),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child:
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: ListView.builder(
              itemCount: followingUsers.length,
              itemBuilder: (context, index) {
                final user = followingUsers[index];
                return FollowingCard(
                  imageUrl: user["imageUrl"]!,
                  name: user["name"]!,
                  status: user["status"]!,
                  onUnfollowPressed: () {
                    _unfollowUser(index); // Unfollow the user at the selected index
                  },
                );
              },
            ),
          ),
        ),
      ),

    );
  }
}
