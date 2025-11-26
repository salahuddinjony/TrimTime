import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_text_field/custom_text_field.dart';
import 'package:barber_time/app/view/common_widgets/common_shop_card/common_shop_card.dart';
import 'package:barber_time/app/view/screens/user/home/controller/user_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class SearchSaloonScreen extends StatelessWidget {
  SearchSaloonScreen({super.key});
  static final UserHomeController homeController =
      Get.put(UserHomeController(), permanent: true);
  static final TextEditingController _searchController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userRole = GoRouter.of(context).state.extra as UserRole?;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text("What are you looking for?"),
        centerTitle: true,
        backgroundColor: AppColors.searchUserFillColor,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.lasts, // start color
              AppColors.last, // end color
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _searchController,
                    builder: (context, value, child) {
                      final hasText = value.text.isNotEmpty;
                      return CustomTextField(
                        isColor: true,
                        textEditingController: _searchController,
                        fieldBorderColor: AppColors.black,
                        fillColor: AppColors.white,
                        hintText: AppStrings.searchSaloons,
                        suffixIcon: hasText
                            ? GestureDetector(
                                onTap: () {
                                  _searchController.clear();
                                  homeController.searchesSaloons.clear();
                                },
                                child:
                                    const Icon(Icons.close, color: Colors.grey),
                              )
                            : const Icon(Icons.search),
                        onChanged: (value) {
                          if (value.trim().isNotEmpty &&
                              value.trim().length >= 2) {
                            homeController.fetchSelons(
                                tag: tags.searches, searchQuery: value.trim());
                          } else {
                            homeController.searchesSaloons.clear();
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _searchController,
                      builder: (context, value, child) {
                        final query = value.text.trim();
                        if (query.isEmpty) {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search,
                                    size: 48, color: Colors.white),
                                SizedBox(height: 12),
                                Text(
                                  "Type to search for salons...",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        }
                        return Obx(() {
                          final salons = homeController.searchesSaloons;
                          if (salons.isEmpty &&
                              !homeController.fetchStatus.value.isLoading) {
                            return const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.store_mall_directory,
                                      size: 48, color: Colors.white),
                                  SizedBox(height: 12),
                                  Text(
                                    "No salons found.",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          }
                          return ListView.builder(
                            itemCount: salons.length,
                            itemBuilder: (context, index) {
                              final salon = salons[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    debugPrint(
                                        "Salon Clicked: ${salon.shopName}");
                                    // Do NOT clear search text or results here
                                    context.pushNamed(
                                        RoutePath.userBookingScreen,
                                        extra: userRole);
                                  },
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
                          );
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Obx(() => homeController.fetchStatus.value.isLoading
                ? Container(
                    color: Colors.black.withValues(alpha: .2),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}
