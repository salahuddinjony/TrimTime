import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/common_profile_card/common_follow_msg_button.dart/common_msg_and_follow_button.dart';
import 'package:flutter/material.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';

class CommonProfileCard extends StatelessWidget {
  final String name;
  final String bio;
  final String imageUrl;
  final VoidCallback? onEditTap;
  final bool showEditIcon;
  final UserRole? userRole;
  final bool
      isBarberProfile; // This should be managed by state management in real use case

  const CommonProfileCard({
    super.key,
    required this.name,
    required this.bio,
    required this.imageUrl,
    this.onEditTap,
    this.showEditIcon = true,
    this.userRole,
    this.isBarberProfile = false,
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
              const SizedBox(height: 10),
              if (userRole != UserRole.owner && isBarberProfile)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    customButton(
                        true ? "Unfollow" : "Follow", Icons.person_add),
                    const SizedBox(width: 10),
                    iconButton(Assets.images.chartSelected.image(
                      color: Colors.white,
                      height: 15,
                    )),
                  ],
                ),
              const SizedBox(height: 20),
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
