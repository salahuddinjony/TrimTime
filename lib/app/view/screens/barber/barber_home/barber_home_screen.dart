import 'package:barber_time/app/core/bottom_navbar.dart';
import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/common_home_app_bar/common_home_app_bar.dart';
import 'package:barber_time/app/view/common_widgets/custom_feed_card/custom_feed_card.dart';
import 'package:barber_time/app/view/common_widgets/custom_border_card/custom_border_card.dart';
import 'package:barber_time/app/view/common_widgets/custom_title/custom_title.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/controller/barber_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class BarberHomeScreen extends StatelessWidget {
  BarberHomeScreen({super.key});

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final BarberHomeController controller = Get.find<BarberHomeController>();

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
      bottomNavigationBar: BottomNavbar(
        currentIndex: 0,
        role: userRole,
      ),
      body: Column(
        children: [
          ///: <<<<<<======🗄️🗄️🗄️🗄️🗄️🗄️💡💡 Appbar💡💡🗄️🗄️🗄️🗄️🗄️🗄️🗄️>>>>>>>>===========
          CommonHomeAppBar(
            onCalender: () {
              AppRouter.route
                  .pushNamed(RoutePath.scheduleScreen, extra: userRole);
            },
            isCalender: true,
            scaffoldKey: scaffoldKey,
            name: "Barber",
            image: AppConstants.demoImage,
            onTap: () {
              AppRouter.route
                  .pushNamed(RoutePath.notificationScreen, extra: userRole);
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              // Wrap everything in a SingleChildScrollView
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    ///: <<<<<<======✅✅ job post✅✅>>>>>>>>===========
                    CustomTitle(
                      title: AppStrings.jobPost,
                      actionText: AppStrings.seeAll,
                      onActionTap: () {
                        AppRouter.route
                            .pushNamed(RoutePath.jobPostAll, extra: userRole);
                      },
                      actionColor: AppColors.secondary,
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    // Barber shop cards
                    Obx(() {
                      if (controller.jobPostList.isEmpty) {
                        // Show a demo job post when there are no real posts
                        final demoJobShopName = 'Elite Saloon';
                        final demoSalary = '£1200';
                        final demoDate = '01/09/2025 - 31/12/2025';
                        final demoLogo =
                            'https://lerirides.nyc3.digitaloceanspaces.com/saloon-logos/1754542797566_icon-6951393_1280.jpg';
                        return CustomBorderCard(
                          title: demoJobShopName,
                          time: '10:00am-10:00pm',
                          price: demoSalary,
                          date: demoDate,
                          buttonText: 'Apply',
                          isButton: true,
                          isSeeDescription: true,
                          onButtonTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Apply for Job'),
                                content: Text('Apply to $demoJobShopName?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Application sent to $demoJobShopName')),
                                      );
                                    },
                                    child: const Text('Apply'),
                                  ),
                                ],
                              ),
                            );
                          },
                          logoImage: (demoLogo.isNotEmpty)
                              ? Image.network(demoLogo,
                                  height: 50, width: 50, fit: BoxFit.cover)
                              : Assets.images.logo.image(height: 50),
                          seeDescriptionTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text(demoJobShopName),
                                content: const SingleChildScrollView(
                                  child: Text(
                                      'Looking for an experienced barber to join our team.'),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('Close'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }

                      return Column(
                        children: List.generate(
                          controller.jobPostList.length > 2
                              ? 2
                              : controller.jobPostList.length,
                          (index) {
                            final job = controller.jobPostList[index];
                            // Format salary / price
                            final salary = job.salary != null
                                ? '£${job.salary.toString()}'
                                : '£20.00/Per hr';

                            // Format dates (show start - end if available)
                            String dateText = '';
                            if (job.startDate?.isNotEmpty == true &&
                                job.endDate?.isNotEmpty == true) {
                              final start = DateTime.tryParse(job.startDate!);
                              final end = DateTime.tryParse(job.endDate!);
                              if (start != null && end != null) {
                                dateText =
                                    '${start.day}/${start.month}/${start.year} - ${end.day}/${end.month}/${end.year}';
                              } else {
                                dateText = job.datePosted ?? '—';
                              }
                            } else if (job.datePosted?.isNotEmpty == true) {
                              final posted = DateTime.tryParse(job.datePosted!);
                              if (posted != null) {
                                dateText =
                                    '${posted.day}/${posted.month}/${posted.year}';
                              } else {
                                dateText = job.datePosted!;
                              }
                            } else {
                              dateText = '—';
                            }

                            // Logo image: prefer remote shopLogo, fallback to asset logo
                            final logoWidget =
                                (job.shopLogo?.isNotEmpty == true)
                                    ? Image.network(job.shopLogo!,
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover)
                                    : Assets.images.logo.image(height: 50);

                            return CustomBorderCard(
                              title: job.shopName ?? 'Barber Shop',
                              time: '10:00am-10:00pm',
                              price: salary,
                              date: dateText,
                              buttonText: 'Apply',
                              isButton: true,
                              isSeeDescription: true,
                              onButtonTap: () {
                                // Simple apply confirmation
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Apply for Job'),
                                    content: Text(
                                        'Apply to ${job.shopName ?? 'this shop'}?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Application sent to ${job.shopName ?? 'shop'}')),
                                          );
                                        },
                                        child: const Text('Apply'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              logoImage: logoWidget,
                              seeDescriptionTap: () {
                                // Show job description in a dialog
                                final desc = job.description ??
                                    'No description available';
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title:
                                        Text(job.shopName ?? 'Job Description'),
                                    content: SingleChildScrollView(
                                        child: Text(desc)),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text('Close'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      );
                    }),

                    ///: <<<<<<======✅✅ Feed✅✅>>>>>>>>===========

                    CustomTitle(
                      title: "Feed",
                      actionText: AppStrings.seeAll,
                      onActionTap: () {
                        AppRouter.route
                            .pushNamed(RoutePath.feedAll, extra: userRole);
                      },
                      actionColor: AppColors.secondary,
                    ),

                    SizedBox(
                      height: 12.h,
                    ),
                    Column(
                      children: List.generate(4, (index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: CustomFeedCard(
                            userImageUrl: AppConstants.demoImage,
                            userName: "Roger Hunt",
                            userAddress: "2972 Westheimer Rd. Santa Ana, Illinois 85486",
                            postImageUrl: AppConstants.demoImage,
                            postText: "Fresh Cut, Fresh Start! 🔥💈 Kickstart your day with confidence! #BarberLife #StayFresh",
                            rating: "5.0 ★ (169)",
                            onFavoritePressed: () {},
                            onVisitShopPressed: () => AppRouter.route.pushNamed(
                              RoutePath.shopProfileScreen,
                              extra: userRole,
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void showBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.check_circle,
              color: Colors.orange,
              size: 50.0,
            ),
            SizedBox(height: 16.0.h),
            const Text(
              'Congratulations!',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.0.h),
            const Text(
              'You have completed the job.',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.0.h),
            ElevatedButton(
              onPressed: () {
                // Navigate to Home or any other action you want
                Navigator.pop(context); // Close the BottomSheet
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // button color
                minimumSize: const Size(double.infinity, 50), // full-width button
              ),
              child: const Text('Go to Home',style: TextStyle(color: AppColors.white),),
            ),
          ],
        ),
      );
    },
  );
}
