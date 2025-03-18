import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/view/common_widgets/common_shop_card/common_shop_card.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:flutter/material.dart';

class NearYouShopScreen extends StatelessWidget {
  const NearYouShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white50,
      appBar: CustomAppBar(
        appBarContent: AppStrings.nearYou,
        appBarBgColor: AppColors.linearFirst,
        iconData: Icons.arrow_back,
      ),
      body: ListView.builder(itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: CommonShopCard(
            imageUrl: AppConstants.shop,
            title: "Barber Time ",
            rating: "5.0 ★ (169)",
            location: "Oldesloer Strasse 82",
            discount: "15%",
            onSaved: () => debugPrint("Saved Clicked!"),
          ),
        );
      }),
    );
  }
}
