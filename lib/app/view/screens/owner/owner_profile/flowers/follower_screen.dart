import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/following_card/following_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FollowerScreen extends StatefulWidget {
  const FollowerScreen({super.key});

  @override
  _FollowingScreenState createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowerScreen> {
  // List of users that are followed
  List<Map<String, String>> followingUsers = [
    {
      "name": "Christian Ronaldo",
      "imageUrl": AppConstants.demoImage,
      "status": "",
    },
    {
      "name": "Lionel Messi",
      "imageUrl": AppConstants.demoImage,
      "status": "",
    },
    // Add more users as needed
  ];

  // Method to handle unfollow action
  void unfollowUser(int index) {
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
        title: const Text("My Followers"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ListView.builder(
          itemCount: followingUsers.length,
          itemBuilder: (context, index) {
            final user = followingUsers[index];
            return FollowingCard(
              isFollower: false,
              imageUrl: user["imageUrl"]!,
              name: user["name"]!,
              status: user["status"]!,
              onUnfollowPressed: () {
                // _unfollowUser(index); // Unfollow the user at the selected index
              },
            );
          },
        ),
      ),
    );
  }
}
