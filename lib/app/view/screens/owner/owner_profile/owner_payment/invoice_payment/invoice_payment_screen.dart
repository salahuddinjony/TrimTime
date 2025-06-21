import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/route_path.dart';
import '../../../../../../core/routes.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/enums/user_role.dart';
import '../../../../../common_widgets/custom_appbar/custom_appbar.dart';

class InvoicePaymentScreen extends StatelessWidget {
  const InvoicePaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userRole = GoRouterState.of(context).extra as UserRole?;
    debugPrint("Selected Roles============================${userRole?.name}");
    const backgroundColor = Color(0xFFFFA873); // Match Figma background
    const cardColor = Colors.white;
    const primaryText = Colors.black;
    const bold = FontWeight.bold;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const CustomAppBar(
        appBarContent:"Invoice",
        appBarBgColor: AppColors.last,
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Invoice Header
              const Text(
                'Invoice',
                style: TextStyle(fontSize: 22, fontWeight: bold, color: primaryText),
              ),
              const SizedBox(height: 6),
              const Text('Date: March 3, 2077'),
              const Text('Invoice: eL77701'),
              const SizedBox(height: 12),

              // Billing and Payment Info
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // BILL TO
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('BILL TO', style: TextStyle(fontWeight: bold)),
                      Text('Reptar Elmo'),
                      Text('Jakarta, Indonesia'),
                      Text('+62 813-xxxxxx'),
                    ],
                  ),

                  // PAY TO
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('PAY TO', style: TextStyle(fontWeight: bold)),
                      Text('Christian Ronaldo'),
                      Text('Jakarta, Indonesia'),
                      Text('+62 852-xxxxxx'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Invoice Table Header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black26),
                  ),
                ),
                child: Row(
                  children: const [
                    Expanded(flex: 2, child: Text('Type', style: TextStyle(fontWeight: bold))),
                    Expanded(flex: 2, child: Text('Description', style: TextStyle(fontWeight: bold))),
                    Expanded(flex: 2, child: Text('Duration', style: TextStyle(fontWeight: bold))),
                    Expanded(child: Text('Rate', style: TextStyle(fontWeight: bold))),
                    Expanded(child: Text('Qty', style: TextStyle(fontWeight: bold))),
                    Expanded(child: Text('Subtotal', style: TextStyle(fontWeight: bold))),
                  ],
                ),
              ),

              // Invoice Row
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: const [
                    Expanded(flex: 2, child: Text('Online')),
                    Expanded(flex: 2, child: Text('Hair cut')),
                    Expanded(flex: 2, child: Text('49 minute')),
                    Expanded(child: Text('\$20')),
                    Expanded(child: Text('1')),
                    Expanded(child: Text('\$20')),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Grand Total
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Grand Total      \$20/-',
                  style: TextStyle(fontWeight: bold, fontSize: 16),
                ),
              ),

              const SizedBox(height: 40),

              // Congratulations Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFD87D45),
                      ),
                      child: const Icon(Icons.check, color: Colors.white, size: 30),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Congratulations!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: bold,
                        color: primaryText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'You have completed the payment.',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 20),

                    // Go to Home Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD87D45),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        AppRouter.route.goNamed(RoutePath.ownerHomeScreen,
                            extra: userRole);
                      },
                      child: const Text(
                        'Go to Home',
                        style: TextStyle(color: Colors.white),
                      ),
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
