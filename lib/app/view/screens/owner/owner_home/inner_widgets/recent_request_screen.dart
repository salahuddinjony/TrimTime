import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_hiring_pending_card/custom_hiring_pending_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../common_widgets/curved_short_clipper/curved_short_clipper.dart';

class RecentRequestScreen extends StatelessWidget {
  const RecentRequestScreen({
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
        backgroundColor: AppColors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.linearFirst,
          title: const Text(AppStrings.recentRequest),
        ),
        body: ClipPath(
            clipper: CurvedShortClipper(),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 1.5,
              decoration: const BoxDecoration(
                // color: Colors.transparent,
                gradient: LinearGradient(
                  colors: [
                    Color(0xCCEDBEA3), // First color (with opacity)
                    Color(0xFFE98F5A),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(2, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: GestureDetector(
                          onTap: () {
                            AppRouter.route.pushNamed(RoutePath.visitShop,
                                extra: userRole);
                          },
                          child: CustomHiringCard(
                            isMessage: true,
                            imageUrl: AppConstants.demoImage,
                            // Image URL (dynamic)
                            name: "Unknown",
                            // Dynamic title (Job name)
                            role: "Barber",
                            // Hardcoded or dynamic role
                            rating: 4.5,
                            // Hardcoded or dynamic rating
                            location: "New York, USA",
                            // Dynamic location or hardcoded
                            onHireTap: () {}, // Hire button action
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            )));
  }
}
