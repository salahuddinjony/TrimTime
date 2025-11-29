import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/common_shop_card/common_shop_card.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_text_field/custom_text_field.dart';
import 'package:barber_time/app/view/screens/user/home/controller/user_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';

class NearYouShopScreen extends StatelessWidget {
  final UserRole userRole;

  NearYouShopScreen({super.key, required this.userRole});

  final UserHomeController homeController = Get.find<UserHomeController>();
  final TextEditingController _searchController = TextEditingController();

  final RxList filteredSalons = <dynamic>[].obs;

  @override
  Widget build(BuildContext context) {
    final extra = GoRouter.of(context).state.extra;
    UserRole? userRole;

    if (extra is UserRole) {
      userRole = extra;
    } else if (extra is Map<String, dynamic>) {
      userRole = extra['userRole'] as UserRole?;
    }

    debugPrint("===================${userRole?.name}");
    if (userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }

    // Initialize filteredSalons with all salons when the widget is first built
    if (filteredSalons.isEmpty && homeController.nearbySaloons.isNotEmpty) {
      filteredSalons.assignAll(homeController.nearbySaloons);
    }

    return Scaffold(
      backgroundColor: AppColors.searchScreenBg,
      appBar: const CustomAppBar(
        appBarContent: AppStrings.nearYou,
        appBarBgColor: AppColors.searchScreenBg,
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            CustomTextField(
              textEditingController: _searchController,
              inputTextStyle: const TextStyle(color: AppColors.black),
              prefixIcon: const Icon(Icons.search),
              hintText: "Search",
              onChanged: (value) {
                final query = value.trim().toLowerCase();
                if (query.isEmpty) {
                  filteredSalons.assignAll(homeController.nearbySaloons);
                } else {
                  filteredSalons.assignAll(
                    homeController.nearbySaloons.where((salon) {
                      final name = salon.shopName.toLowerCase();
                      final address = salon.shopAddress.toLowerCase();
                      return name.contains(query) || address.contains(query);
                    }),
                  );
                }
              },
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: Obx(() {
                final salons = filteredSalons.isNotEmpty ||
                        _searchController.text.isNotEmpty
                    ? filteredSalons
                    : homeController.nearbySaloons;
                if (homeController.fetchStatus.value.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    await homeController.fetchSelons(tag: tags.nearby);
                    filteredSalons.assignAll(homeController.nearbySaloons);
                  },
                  child: salons.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: Center(
                                child: Text(
                                  "No shops found",
                                  style: TextStyle(fontSize: 16.sp),
                                ),
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          itemCount: salons.length,
                          itemBuilder: (context, index) {
                            final salon = salons[index];
                            return GestureDetector(
                              onTap: () {
                                // context.pushNamed(RoutePath.userBookingScreen,
                                //     extra: userRole);
                                debugPrint(
                                    "Salon Clicked  : ${salon.shopName}");
                                AppRouter.route.pushNamed(
                                  RoutePath.shopProfileScreen,
                                  extra: {
                                    'userRole': userRole,
                                    'userId': salon.userId,
                                    'controller': homeController,
                                  },
                                );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: CommonShopCard(
                                  imageUrl: salon.shopLogo,
                                  title: salon.shopName,
                                  rating: "${salon.ratingCount} ★",
                                  location: salon.shopAddress,
                                  discount: salon.distance.toString(),
                                  onSaved: () => debugPrint("Saved Clicked!"),
                                ),
                              ),
                            );
                          },
                        ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
