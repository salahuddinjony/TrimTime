





import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/common_shop_card/common_shop_card.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_text_field/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
class NearYouShopScreen extends StatefulWidget {
  const NearYouShopScreen({super.key});

  @override
  State<NearYouShopScreen> createState() => _NearYouShopScreenState();
}

class _NearYouShopScreenState extends State<NearYouShopScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Shop> _allShops = [];
  List<Shop> _filteredShops = [];

  @override
  void initState() {
    super.initState();
    // Initialize your shops here - replace with real data or API call
    _allShops = List.generate(20, (index) => Shop(
      title: "Barber Time $index",
      rating: "5.0 ★ (169)",
      location: "Oldesloer Strasse 82",
      discount: "15%",
      imageUrl: AppConstants.shop,
    ));
    _filteredShops = List.from(_allShops);

    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredShops = _allShops.where((shop) {
        return shop.title.toLowerCase().contains(query) ||
            shop.location.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userRole = GoRouter.of(context).state.extra as UserRole?;

    if (userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.white50,
      appBar: const CustomAppBar(
        appBarContent: AppStrings.nearYou,
        appBarBgColor: AppColors.linearFirst,
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
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: _filteredShops.isEmpty
                  ? Center(child: Text("No shops found", style: TextStyle(fontSize: 16.sp)))
                  : ListView.builder(
                itemCount: _filteredShops.length,
                itemBuilder: (context, index) {
                  final shop = _filteredShops[index];
                  return GestureDetector(
                    onTap: () {
                      context.pushNamed(RoutePath.userBookingScreen, extra: userRole);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: CommonShopCard(
                        imageUrl: shop.imageUrl,
                        title: shop.title,
                        rating: shop.rating,
                        location: shop.location,
                        discount: shop.discount,
                        onSaved: () => debugPrint("Saved Clicked!"),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Shop {
  final String title;
  final String rating;
  final String location;
  final String discount;
  final String imageUrl;

  Shop({
    required this.title,
    required this.rating,
    required this.location,
    required this.discount,
    required this.imageUrl,
  });
}

//
// class NearYouShopScreen extends StatelessWidget {
//   const NearYouShopScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final userRole = GoRouter.of(context).state.extra as UserRole?;
//
//     if (userRole == null) {
//       return Scaffold(
//         appBar: AppBar(title: const Text('Error')),
//         body: const Center(child: Text('No user role received')),
//       );
//     }
//     return Scaffold(
//       backgroundColor: AppColors.white50,
//       appBar: const CustomAppBar(
//         appBarContent: AppStrings.nearYou,
//         appBarBgColor: AppColors.linearFirst,
//         iconData: Icons.arrow_back,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         child: Column(
//           children: [
//             const CustomTextField(
//               inputTextStyle: TextStyle(color: AppColors.black),
//               prefixIcon: Icon(Icons.search),
//               hintText: "Search",
//             ),
//             SizedBox(height: 20.h,),
//             Expanded(
//               child: ListView.builder(itemBuilder: (context, index) {
//                 return GestureDetector(
//                   onTap: () {
//                     context.pushNamed(RoutePath.userBookingScreen,extra: userRole);
//
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     child: CommonShopCard(
//                       imageUrl: AppConstants.shop,
//                       title: "Barber Time ",
//                       rating: "5.0 ★ (169)",
//                       location: "Oldesloer Strasse 82",
//                       discount: "15%",
//                       onSaved: () => debugPrint("Saved Clicked!"),
//                     ),
//                   ),
//                 );
//               }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
