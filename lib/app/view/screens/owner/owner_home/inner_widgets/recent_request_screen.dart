import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_hiring_pending_card/custom_hiring_pending_card.dart';
import 'package:barber_time/app/view/screens/owner/owner_home/controller/barber_owner_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../common_widgets/curved_short_clipper/curved_short_clipper.dart';

class RecentRequestScreen extends StatelessWidget {
  const RecentRequestScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final extra = GoRouter.of(context).state.extra;

    UserRole? userRole;
    BarberOwnerHomeController? controller;

    if (extra is Map<String, dynamic>) {
      userRole = extra['userRole'] as UserRole?;
      controller = extra['controller'] as BarberOwnerHomeController?;
    }

    debugPrint("===================${userRole?.name}");
    if (userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }

    if (controller == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No controller received')),
      );
    }

    // Now controller is guaranteed to be non-null
    final nonNullController = controller;
    final nonNullUserRole = userRole;
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.linearFirst,
          title: const Text(AppStrings.recentRequest),
        ),
        body: Stack(
          children: [
            // Curved background decoration
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ClipPath(
                clipper: CurvedShortClipper(),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 1.5,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xCCEDBEA3), // First color (with opacity)
                        Color(0xFFE98F5A),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
            ),
            // Data content on top
            Obx(() {
              final jobApplicationsList = nonNullController.jobHistoryList
                  .where((job) => job.status.toLowerCase() == 'pending')
                  .toList();

              if (nonNullController.isJobHistoryLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (jobApplicationsList.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () async {
                    await nonNullController.getAllJobHistory(
                        isBarberOwner: true);
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height - 200,
                      child: const Center(
                        child: Text(
                          'No recent requests found',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  await nonNullController.getAllJobHistory(isBarberOwner: true);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: jobApplicationsList.length,
                    itemBuilder: (context, index) {
                      final application = jobApplicationsList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: GestureDetector(
                          onTap: () {
                            // AppRouter.route.pushNamed(RoutePath.visitShop,
                            //     extra: nonNullUserRole);
                            final barber = jobApplicationsList[index].barber;
                            // Use userId if available, otherwise use id
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
                                if (application.status == 'PENDING') ...{
                                  'onActionApprove': () {
                                    controller?.updateJobStatus(
                                        applicationId: application.id,
                                        status: 'COMPLETED',
                                        context: context);
                                  },
                                  'onActionReject': () {
                                    controller?.updateJobStatus(
                                        applicationId: application.id,
                                        status: 'REJECTED',
                                        context: context);
                                  },
                                },
                              },
                            );
                          },
                          child: CustomHiringCard(
                            isMessage: true,
                            imageUrl: application.barber.image ??
                                AppConstants.demoImage,
                            name: application.barber.fullName,
                            role: application.barber.email,
                            rating: 4.5,
                            location: "New York, USA",
                            onHireTap: () {},
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }),
          ],
        ));
  }
}
