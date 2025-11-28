import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/common_profile_card/common_follow_msg_button.dart/common_msg_and_follow_button.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/controller/owner_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:get/get.dart';

class CommonProfileCard extends StatelessWidget {
  final String name;
  final String bio;
  final String imageUrl;
  final VoidCallback? onEditTap;
  final bool showEditIcon;
  final UserRole? userRole;
  final bool
      isBarberProfile; // This should be managed by state management in real use case

  final OwnerProfileController? controller;
  final String? userId;

  const CommonProfileCard({
    super.key,
    required this.name,
    required this.bio,
    required this.imageUrl,
    this.onEditTap,
    this.showEditIcon = true,
    this.userRole,
    this.isBarberProfile = false,
    this.controller,
    this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 60),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: .1),
                blurRadius: 8,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 50),
              CustomText(
                text: name,
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
              if (controller?.isMe == true) ...[
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 143, 115, 115)
                        .withValues(alpha: .08),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                        color: const Color.fromARGB(255, 177, 150, 150)
                            .withValues(alpha: .18)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified_user_rounded,
                          size: 18,
                          color: const Color.fromARGB(255, 163, 112, 112)),
                      const SizedBox(width: 8),
                      CustomText(
                        text: "Your profile",
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromARGB(255, 141, 102, 102),
                      ),
                    ],
                  ),
                ),
              ],
              if ((userRole != UserRole.owner && controller?.isMe != true) &&
                  isBarberProfile) ...[
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (controller != null)
                      Obx(
                        () => GestureDetector(
                          onTap: () {
                            controller?.isBarberFollowing();
                            controller?.toggleBarberFollow(
                              userId: userId ?? '',
                            );
                          },
                          child: customButton(
                              controller?.isFollowing.value ?? false
                                  ? "Unfollow"
                                  : "Follow",
                              controller!.isFollowing.value
                                  ? Icons.person_remove
                                  : Icons.person_add),
                        ),
                      ),
                    const SizedBox(width: 10),
                    iconButton(Assets.images.chartSelected.image(
                      color: Colors.white,
                      height: 15,
                    )),
                  ],
                ),
                const SizedBox(height: 15),
              ],
              const SizedBox(height: 05),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomText(
                  maxLines: 20,
                  text: bio,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
        Positioned(
          top: 0,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CustomNetworkImage(
                imageUrl: imageUrl,
                height: 100,
                width: 100,
                boxShape: BoxShape.circle,
              ),
              if (showEditIcon && onEditTap != null)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: onEditTap,
                    child: const CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.black,
                      child: Icon(
                        Icons.edit,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
