import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_barber_card/custom_barber_card.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/controller/owner_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/route_path.dart';
import '../../../../../core/routes.dart';

class HiringBarber extends StatelessWidget {
  final UserRole userRole;
  final bool isOwner;
  final OwnerProfileController controller;
  const HiringBarber({
    super.key,
    required this.userRole,
    this.isOwner = false,
    required this.controller,
  });

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

    debugPrint("==================={userRole?.name}");
    if (userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }
    return Scaffold(
      backgroundColor: AppColors.linearFirst,

      ///============================ Header ===============================
      appBar: const CustomAppBar(
        appBarContent: AppStrings.barber,
        iconData: Icons.arrow_back,
        appBarBgColor: AppColors.linearFirst,
      ),

      ///============================ body ===============================
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Obx(() {
            final hiredBarbers = controller.hiredBarberList;
            if (controller.hiredBarberStatus.value.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.white,
                ),
              );
            }
            if (hiredBarbers.isEmpty) {
              return Center(
                child: Text(
                  isOwner ? "No Barber Hired Yet" : "No Hired Barber Found",
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                  ),
                ),
              );
            }
            if (controller.hiredBarberStatus.value.isError) {
              return Center(
                child: Text(
                  isOwner ? "No Barber Hired Yet" : "No Hired Barber Found",
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                  ),
                ),
              );
            }
            return ListView.separated(
              itemCount: hiredBarbers.length,
              separatorBuilder: (context, index) => const SizedBox(height: 15),
              itemBuilder: (context, index) {
                final barber = hiredBarbers[index];
                return GestureDetector(
                  onTap: () {
                    // AppRouter.route.pushNamed(RoutePath.visitShop,
                    // extra: userRole);

                    final barberId = barber.barberId;
                    debugPrint("Barber ${barber.barberFullName} clicked");
                    debugPrint("Barber ID: $barberId");

                    // Navigate to professional profile with barber ID
                    AppRouter.route.pushNamed(
                      RoutePath.professionalProfile,
                      extra: {
                        'userRole': userRole,
                        'barberId': barberId,
                        'isForActionButton': true,
                      },
                    );
                  },
                  child: CustomBarberCard(
                    imageUrl: barber.barberImage ?? '', // Barber's image URL
                    name: barber.barberFullName, // Barber's name
                    role: barber.barberEmail, // Barber's role
                    contact: barber.barberPhoneNumber ??
                        'N/A', // Barber's contact number
                  ),
                );
              },
            );
          })),
    );
  }
}
