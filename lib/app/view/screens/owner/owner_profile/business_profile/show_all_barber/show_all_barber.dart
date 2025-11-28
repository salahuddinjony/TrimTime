import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/business_profile/show_all_barber/barber_grid_card.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/controller/owner_profile_controller.dart';
import 'package:flutter/material.dart';

class ShowAllBarber extends StatelessWidget {
  final UserRole userRole;
  final OwnerProfileController controller;
  const ShowAllBarber(
      {super.key, required this.userRole, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarContent: "All My Hired Barber",
        iconData: Icons.arrow_back,
      ),
      backgroundColor: const Color(0xFFFFD0A3),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xCCEDC4AC),
              Color(0xFFE9864E),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Obx(() {
                  if (controller.businessProfileStatus.value.isLoading) {
                    // Show shimmer loading grid
                    return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    height: 100,
                                    color: Colors.grey[300],
                                  ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(16),
                                      bottomRight: Radius.circular(16),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 16,
                                        color: Colors.grey[300],
                                        margin: const EdgeInsets.only(bottom: 8),
                                      ),
                                      Container(
                                        width: 60,
                                        height: 12,
                                        color: Colors.grey[300],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      await controller.fetchBusinessProfiles();
                    },
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: controller.businessProfileData.value?.barbers.length ?? 0,
                      itemBuilder: (context, index) {
                        final barber = controller.businessProfileData.value!.barbers[index];
                        return GestureDetector(
                          onTap: () {
                            final barberId = barber.id;
                            debugPrint("Barber ${barber.fullName} clicked");
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
                          child: BarberGridCard(barber: barber),
                        );
                      },
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
