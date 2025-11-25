import 'package:barber_time/app/global/helper/extension/extension.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/data/local/shared_prefs.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../core/route_path.dart';
import '../../../../../core/routes.dart';
import '../../../../common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';

class QueScreen<T> extends StatelessWidget {
  final UserRole userRole;
  final String barberId;
  final T? controller;
  final String? saloonOwnerId;
  const QueScreen({
    super.key,
    required this.userRole,
    required this.barberId,
    this.saloonOwnerId,
    this.controller,
  });

  // -------- Dynamic Color --------
  Color generateColor(int i) {
    // Use DJ (Disc Jockey) color palette for more vibrant, party-like colors
    final v = [255, 0, 128, 0, 255]; // R, G, B, G, R for a DJ vibe
    return Color.fromARGB(255, v[i % 5], v[(i + 1) % 5], v[(i + 2) % 5]);
  }

  // -------- Dynamic Icon --------
  IconData generateIcon(int i) {
    const icons = [
      Icons.person,
      Icons.face,
      Icons.account_circle,
      Icons.emoji_people,
      Icons.sentiment_satisfied,
    ];
    return icons[i % icons.length];
  }

  @override
  Widget build(BuildContext context) {
    final dynamic controller = this.controller;
    Future<void> _refresh(BuildContext context) async {
      if (controller != null) {
        String? ownerId = saloonOwnerId;
        if (ownerId == null || ownerId.isEmpty) {
          // Fallback: try to get from shared preferences
          ownerId = await SharePrefsHelper.getString(AppConstants.userId);
        }
        await controller!.fetchBarbersCustomerQue(
          barberId: barberId,
          saloonOwnerId: ownerId,
        );
      }
    }

    final extra = GoRouter.of(context).state.extra;
    UserRole? role;

    if (extra is UserRole) role = extra;
    if (extra is Map) role = extra["userRole"];

    if (role == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: const Center(child: Text("No user role received")),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        iconData: Icons.arrow_back,
        appBarContent: AppStrings.que,
        appBarBgColor: AppColors.searchScreenBg,
      ),
      body: Obx(() {
        final loading = controller!.barbersCustomerQueStatus.value.isLoading;
        final data = controller!.barbersCustomerQue.value;

        return RefreshIndicator(
          onRefresh: () => _refresh(context),
          child: ClipPath(
            clipper: CurvedBannerClipper(),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xCCEDBC9F),
                    Color(0xFFE98952),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  if (userRole != UserRole.barber) ...[
                    loading
                        ? shimmerHeader()
                        : barberHeaderSection(
                            coverImage:
                                data?.shopLogo ?? AppConstants.demoImage,
                            profileImage: data?.image ?? AppConstants.demoImage,
                            barberName: data?.name ?? "Unknown",
                            onProfileTap: () {
                              final barberId = data?.barberId ?? "";
                              debugPrint("Barber \\${data?.name} clicked");
                              debugPrint("Barber ID: $barberId");
                              AppRouter.route.pushNamed(
                                RoutePath.professionalProfile,
                                extra: {
                                  'userRole': userRole,
                                  'barberId': barberId,
                                  'isForActionButton': true,
                                },
                              );
                            },
                          ),
                  ],
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (userRole == UserRole.barber) ...[
                          SizedBox(height: 10.h),
                        ],
                        loading
                            ? shimmerText(width: 150, height: 20)
                            : userRole == UserRole.barber
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        top: 16.0, bottom: 4.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const CustomText(
                                          text: "Ongoing Customers",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20,
                                          color: AppColors.gray500,
                                        ),
                                        const SizedBox(width: 10),
                                        Container(
                                          alignment: Alignment.center,
                                          height: 28,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12),
                                          decoration: BoxDecoration(
                                            color: AppColors.black,
                                            borderRadius:
                                                BorderRadius.circular(14),
                                          ),
                                          child: CustomText(
                                            text:
                                                "${data?.bookings.length ?? 0}",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const CustomText(
                                    top: 16,
                                    text: "Ongoing Customer",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                    color: AppColors.gray500,
                                  ),
                        const SizedBox(height: 12),
                        loading
                            ? shimmerGrid()
                            : (data?.bookings.isEmpty ?? true)
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 32.0),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Icon(Icons.hourglass_empty,
                                              size: 48, color: Colors.white),
                                          const SizedBox(height: 12),
                                          Text(
                                            "No customers in queue",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : buildCustomerGrid(data!.bookings),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  // --------------------------------------------------------------------------
  // -------------------------- SHIMMER WIDGETS -------------------------------
  // --------------------------------------------------------------------------

  Widget shimmerBox({double width = double.infinity, double height = 20}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget shimmerText({required double width, required double height}) {
    return shimmerBox(width: width, height: height);
  }

  Widget shimmerCircle(double size) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade200,
      child: Container(
        height: size,
        width: size,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget shimmerHeader() {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // Shimmer Cover Image
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                width: double.infinity,
                height: 200.h,
                color: Colors.white,
              ),
            ),

            // Floating Avatar Shimmer (same as real position)
            Positioned(
              bottom: -70, // EXACT same as real avatar position
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  width: 120.w,
                  height: 120.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 80), // Allow avatar overflow space

        // Name text shimmer
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            width: 140,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // "See profile" button shimmer
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            width: 110,
            height: 35,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }

  Widget shimmerGrid() {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 20,
        childAspectRatio: 0.9,
      ),
      itemCount: 6,
      itemBuilder: (_, __) {
        return Column(
          children: [
            shimmerCircle(60),
            const SizedBox(height: 6),
            shimmerBox(width: 60, height: 10),
            const SizedBox(height: 4),
            shimmerBox(width: 50, height: 10),
          ],
        );
      },
    );
  }

  // --------------------------------------------------------------------------
  // ---------------------------- ACTUAL UI -----------------------------------
  // --------------------------------------------------------------------------

  Widget buildCustomerGrid(List bookings) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12, // reduced spacing
        childAspectRatio: .85, // slightly more vertical space
      ),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        var customer = bookings[index];
        return LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                customer.customerImage != null &&
                        customer.customerImage!.isNotEmpty
                    ? CircleAvatar(
                        radius: 26, // slightly smaller
                        backgroundImage:
                            CachedNetworkImageProvider(customer.customerImage!),
                      )
                    : Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: generateColor(index),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          generateIcon(index),
                          size: 28,
                          color: Colors.white,
                        ),
                      ),
                const SizedBox(height: 4),
                Flexible(
                  child: CustomText(
                    text: "${customer.customerName.toString().safeCap()}",
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: AppColors.gray500,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .04),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: CustomText(
                      text: "${customer.startTime}-${customer.endTime}",
                      fontWeight: FontWeight.w500,
                      fontSize: 9,
                      color: AppColors.black,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Flexible(
                  child: CustomText(
                    text: "${customer.totalTime ?? 'N/A'} min",
                    fontWeight: FontWeight.w800,
                    fontSize: 9,
                    color: AppColors.gray500,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // --------------------------------------------------------------------------
  Widget barberHeaderSection({
    required String coverImage,
    required String profileImage,
    required String barberName,
    required VoidCallback onProfileTap,
  }) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 200.h,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(coverImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: -70,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image(
                    image: CachedNetworkImageProvider(profileImage),
                    width: 120.w,
                    height: 120.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 80),
        Text(
          barberName,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.gray500,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: onProfileTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              "See profile",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
