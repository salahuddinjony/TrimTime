import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../utils/app_constants.dart';
import '../../../../../utils/enums/user_role.dart';
import '../../../../common_widgets/custom_hiring_pending_card/custom_hiring_pending_card.dart';

class TotalCustomerScreen extends StatelessWidget {
  const TotalCustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userRole = GoRouter.of(context).state.extra as UserRole?;

    if (userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }
    return  Scaffold(
      appBar: const CustomAppBar(
        appBarContent: 'Total Customer',
        iconData: Icons.arrow_back,
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: Column(
          children: [
            CustomHiringCard(
              isMessage: true,
              imageUrl: AppConstants.demoImage,
              // Image URL (dynamic)
              name: "Mosly",
              // Dynamic title (Job name)
              role: "Customer",
              // Hardcoded or dynamic role
              rating: 4.5,
              // Hardcoded or dynamic rating
              location: "New York, USA",
              // Dynamic location or hardcoded
              onHireTap: () {}, // Hire button action
            ),
          ],
        ),
      ),
    );
  }
}
