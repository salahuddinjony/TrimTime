import 'package:barber_time/app/core/bottom_navbar.dart';
import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/screens/barber/barber_history/controller/history_controller.dart';
// removed unused custom border card import after redesign
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'constants/order_constants.dart';

class BarberHistoryScreen extends StatelessWidget {
  BarberHistoryScreen({super.key});

  // BarberHistoryScreen({super.key}) {
  //   // Refresh job history every time this page is constructed
  //   Future.microtask(() => controller.getAllJobHistory());
  // }

  final HistoryController controller = Get.find<HistoryController>();

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
          title: const Text(AppStrings.history),
        ),
        bottomNavigationBar: BottomNavbar(
          currentIndex: 3,
          role: userRole,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Obx(() {
            if (controller.isJobHistoryLoading.value) {
              return ListView.separated(
                itemCount: 4,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) =>
                    const Card(elevation: 1, child: _HistoryShimmerCard()),
              );
            }

            final jobs = controller.jobHistoryList.where((job) =>
                job.status != "PENDING").toList();
            if (jobs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Assets.images.logo.image(height: 120),
                    const SizedBox(height: 12),
                    const Text('No history yet',
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async => await controller.getAllJobHistory(),
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: jobs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final job = jobs[index];

                  String title = job.jobPost.shopName.isNotEmpty
                      ? job.jobPost.shopName
                      : job.barber.fullName;

                  String formatTimeRange() {
                    final start = job.jobPost.startDate;
                    final end = job.jobPost.endDate;
                    if (start == null && end == null) return '';
                    String fmt(DateTime d) =>
                        '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
                    if (start != null && end != null)
                      return '${fmt(start)} - ${fmt(end)}';
                    if (start != null) return fmt(start);
                    return fmt(end!);
                  }

                  final time = formatTimeRange();
                  final price = job.jobPost.hourlyRate != null
                      ? '£${job.jobPost.hourlyRate!.toStringAsFixed(2)}/hr'
                      : '—';
                  final date = job.createdAt != null
                      ? job.createdAt!.toLocal().toString().split(' ').first
                      : (job.jobPost.datePosted != null
                          ? job.jobPost.datePosted!
                              .toLocal()
                              .toString()
                              .split(' ')
                              .first
                          : '');
                  final Color statusColor =
                      Color(OrderConstants.getStatusColor(job.status));
                  final Color statusTextColor =
                      statusColor.computeLuminance() > 0.5
                          ? Colors.black
                          : Colors.white;

                  void showDetails() {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        titlePadding: EdgeInsets.zero,
                        title: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              AppColors.linearFirst,
                              AppColors.last
                            ]),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12)),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 26,
                                backgroundImage: job.barber.image != null &&
                                        job.barber.image!.isNotEmpty
                                    ? NetworkImage(job.barber.image!)
                                        as ImageProvider
                                    : const AssetImage(
                                        'assets/images/logo.png'),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(title,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    Text(date,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 12)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 6),
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  OrderConstants.getStatusDisplayText(
                                      job.status),
                                  style: TextStyle(
                                      color: statusTextColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.access_time,
                                    size: 16, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(time,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                                const Spacer(),
                                Text(price,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text('Description',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Text(job.jobPost.description.isNotEmpty
                                ? job.jobPost.description
                                : 'No description provided'),
                            const SizedBox(height: 12),
                            Row(
                              children: const [
                                Icon(Icons.location_on,
                                    size: 16, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Address',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(job.jobPost.shopAddress?.isNotEmpty == true
                                ? job.jobPost.shopAddress!
                                : 'No address provided'),
                          ],
                        ),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close')),
                        ],
                      ),
                    );
                  }

                  return GestureDetector(
                    onTap: showDetails,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundImage: job.barber.image != null &&
                                      job.barber.image!.isNotEmpty
                                  ? NetworkImage(job.barber.image!)
                                      as ImageProvider
                                  : const AssetImage('assets/images/logo.png'),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(title,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.access_time,
                                          size: 14, color: Colors.grey),
                                      const SizedBox(width: 6),
                                      Text(time.isNotEmpty ? time : '—',
                                          style: const TextStyle(
                                              color: Colors.grey)),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Text(price,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600)),
                                      const SizedBox(width: 12),
                                      Text(date,
                                          style: const TextStyle(
                                              color: Colors.grey)),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: statusColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    OrderConstants.getStatusDisplayText(
                                        job.status),
                                    style: TextStyle(
                                        color: statusTextColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                IconButton(
                                  icon: const Icon(Icons.chevron_right),
                                  onPressed: showDetails,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ));
  }
}

class _HistoryShimmerCard extends StatelessWidget {
  const _HistoryShimmerCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 14, width: double.infinity, color: Colors.white),
                  const SizedBox(height: 8),
                  Container(height: 12, width: 120, color: Colors.white),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(height: 12, width: 80, color: Colors.white),
                      const SizedBox(width: 12),
                      Container(height: 12, width: 60, color: Colors.white),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(height: 28, width: 80, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
