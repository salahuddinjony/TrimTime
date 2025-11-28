import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/following_card/following_card.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/controller/owner_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class FollowerScreen extends StatelessWidget {
  final UserRole userRole;
  final OwnerProfileController? controller;
  const FollowerScreen({super.key, required this.userRole, this.controller});

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

    debugPrint("===================[36m${userRole?.name}");
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
        child: Obx(() {
          final followers = controller?.followersList ?? [];
          if (controller?.followersStatus.value.isLoading ?? true) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller?.followersStatus.value.isError ?? false) {
            return Center(
              child: Text(
                'Error: ${controller?.followersStatus.value.errorMessage}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (followers.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                await controller?.fetchFollowerOrFollowingData(
                  isFollowers: true,
                  needLoader: true,
                );
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 200),
                  Center(child: Text('No followers found.')),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              await controller?.fetchFollowerOrFollowingData(
                isFollowers: true,
                needLoader: true,
              );
            },
            child: ListView.builder(
              itemCount: followers.length,
              itemBuilder: (context, index) {
                final user = followers[index];
                return GestureDetector(
                  onTap: () {
                    final Id = user.followerId;
                    final followerRole = user.followerRole;


                    if(Id.isEmpty || userRole == null) {
                      debugPrint("Invalid barber ID or user role");
                      return;
                    }

                    if(followerRole.isNotEmpty &&
                        followerRole == "CUSTOMER") {
                      debugPrint("Customer ${user.followerName} clicked");
                      debugPrint("Customer ID: $Id");
                     AppRouter.route.pushNamed(
                      RoutePath.customerProfileScreen,
                      extra: {
                        'userRole': userRole,
                        'customerId': Id, 
                        'controller': controller,
                      },
                    );
                      return;
                    }
                    if (followerRole.isNotEmpty &&
                      followerRole == "SALOON_OWNER") {
                      AppRouter.route.pushNamed(
                        RoutePath.shopProfileScreen,
                        extra: {
                          'userRole': userRole,
                          'userId': user.followerId,
                          'controller': controller,
                          'isShowOwnerInfo': true,
                        },
                      );
                      return;
                    }

                  if(followerRole.isNotEmpty &&
                      followerRole == "BARBER") {
                     debugPrint("Barber ${user.followerName} clicked");
                    debugPrint("Barber ID: $Id");
                    AppRouter.route.pushNamed(
                      RoutePath.professionalProfile,
                      extra: {
                        'userRole': userRole,
                        'barberId': Id,
                        'isForActionButton': false,
                      },
                    );
                    return;
                  }
                  },
                  child: FollowingCard(
                    isFollower: false,
                    imageUrl: user.followerImage,
                    name: user.followerName,
                    status: '',
                    email: user.followerEmail,
                    onUnfollowPressed: () {},
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
