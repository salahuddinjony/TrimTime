import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_border_card/custom_border_card.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class JobPost extends StatelessWidget {
  const JobPost({
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
      ///============================ Header ===============================
      appBar: const CustomAppBar(
        appBarContent: AppStrings.jobPost,
        iconData: Icons.arrow_back,
        appBarBgColor: AppColors.linearFirst,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: CustomButton(
          textColor: AppColors.white50,
          fillColor: AppColors.black,
          onTap: () {
            AppRouter.route
                .pushNamed(RoutePath.createJobPost, extra: userRole);
          },
          title: AppStrings.addNew,
        ),
      ),

      ///============================ body ===============================
       body:   Padding(
         padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
         child: Column(
           children: List.generate(2, (index) {
             return CustomBorderCard(
               isEdit: true,
               isEditTap: (){
                 debugPrint("gg");
               },
               title: 'Barber Shop',
               time: '10:00am-10:00pm',
               price: '£20.00/Per hr',
               date: '02/10/23',
               buttonText: 'Apply',
               isButton: false,
               isSeeDescription: true,
               onButtonTap: () {
                 // Handle button tap logic
               },
               logoImage: Assets.images.logo.image(height: 50),
               seeDescriptionTap: () {},
             );
           }),
         ),
       ),
    );
  }
}
