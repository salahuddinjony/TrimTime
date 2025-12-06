import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart'; 
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/following_card/following_card.dart';
import 'package:barber_time/app/view/common_widgets/show_custom_snackbar/show_custom_snackbar.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/controller/owner_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';

class FollowingScreen extends StatelessWidget {
  final UserRole userRole;
  final OwnerProfileController? controller;
  const FollowingScreen({super.key, required this.userRole, this.controller});

  @override
  Widget build(BuildContext context) {
      // controller?.fetchFollowerOrFollowingData(
      //                           isFollowers: false);
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
        title: const Text(AppStrings.myFollowing),
      ),
      body: ClipPath(
        clipper: CurvedBannerClipper(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 1.2,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xCCEDC4AC),
                Color(0xFFE9874E),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Obx(() {
              final followingList = controller?.followingList;
              if (controller?.followingStatus.value.isLoading ?? true) {
                return ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) => _buildShimmerCard(),
                );
              } else if (followingList?.isEmpty ?? true) {
                return RefreshIndicator(
                  onRefresh: () async {
                    await controller?.fetchFollowerOrFollowingData(
                      isFollowers: false,
                      needLoader: true,
                    );
                  },
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 200),
                      Center(child: Text('No following found.')),
                    ],
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  await controller?.fetchFollowerOrFollowingData(
                    isFollowers: false,
                    needLoader: true,
                  );
                },
                child: ListView.builder(
                  itemCount: followingList!.length,
                  itemBuilder: (context, index) {
                    final user = followingList[index];
                    return GestureDetector(
                      onTap: () {
                     final Id = user.followingId;
                    final followerRole = user.followingRole;


                    if(Id.isEmpty || userRole == null) {
                      debugPrint("Invalid barber ID or user role");
                      return;
                    }

                    if(followerRole.isNotEmpty &&
                        followerRole == "CUSTOMER") {
                      debugPrint("Customer ${user.followingName} clicked");
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
                          'userId': user.followingId,
                          'controller': controller,
                          'isShowOwnerInfo': true,
                        },
                      );
                      return;
                    }

                  if(followerRole.isNotEmpty &&
                      followerRole == "BARBER") {
                     debugPrint("Barber ${user.followingName} clicked");
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
                        // Handle card tap if needed
                      },
                      child: FollowingCard(
                        imageUrl: user.followingImage,
                        name: user.followingName,
                        status: 'Unfollow',
                        email: user.followingEmail,
                        onUnfollowPressed: () async {
                          controller?.followingList.removeAt(index);
                          final result = await controller?.toggleFollow(
                              userId: user.followingId,
                              isfollowUnfollow: false);

                          if (result == true) {
                            controller?.followingList.refresh();
                            controller?.fetchFollowerOrFollowingData(
                                isFollowers: false, needLoader: false);
                          } else {
                            controller?.followingList.insert(index, user);
                            controller?.followingList.refresh();
                            toastMessage(
                                message:
                                    "Failed to unfollow ${user.followingName}");
                          }
                        },
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.r),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          padding: EdgeInsets.all(25.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8.r)),
            border: Border.all(color: AppColors.gray500, width: 1),
          ),
          child: Row(
            children: [
              // Profile Image placeholder
              Container(
                height: 50.r,
                width: 50.r,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 12.r),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name placeholder
                    Container(
                      width: 120.w,
                      height: 14.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // Email and button row
                    Row(
                      children: [
                        // Email placeholder
                        Expanded(
                          child: Container(
                            height: 12.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        // Button placeholder
                        Container(
                          width: 70.w,
                          height: 24.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
